import PlaygroundSupport
import Foundation

/*
 Serial queue runs tasks using single thread - each task must complete before next task is able to start
 Concurrent queue runs tasks using many threads
 
 DispatchQueue.main - serial queue, responsible for UI management
 
 Queue label should be reverse dns name or some meaningful text (its much easier to identify the queue during debbuging), by default created queues are serial
 There is six default concurrent queues, with different quality of service (priority)
 
 QoS:
 .userInteractive - recommended for tasks that the user directly interacts with. UI-updating calculations, animations or anything needed to keep the UI responsive and fast
 .userInitiated - should be used when the user kicks off a task from the UI that needs to happen immediately, but can be done asynchronously
 .utility - for long-running computations, I/O, networking or continuous data feeds. The system tries to balance responsiveness and performance with energy efficiency
 .background - for tasks that the user is not directly aware. They don’t require user interaction and aren’t time sensitive. Prefetching, database maintenance, synchronizing remote servers and performing backups are all great examples. The OS will focus on energy efficiency instead of speed
 .default and .unspecified - should not use explicitly. There’s a .default option, which falls between .userInitiated and .utility and is the default value of the qos argument. It’s not intended for you to directly use. The .unspecified option exists to support legacy APIs
 
 */

let serialQueue = DispatchQueue(label: "ol.training.serial")
let concurrentQueue = DispatchQueue(label: "pl.training.concurrent", attributes: .concurrent)
let qlobalQueue = DispatchQueue.global(qos: .userInteractive) // concurrent
let customConcurrentQueue = DispatchQueue(label: "pl.training.concurrent.custom", qos: .userInitiated, attributes: .concurrent) // Quality of service can be changed by system when submitting tasks with different qos value

// Submitting task to synchronous queue can be potentially dangerous (main thread blocking, deadlocks)
concurrentQueue.sync {
    Thread.sleep(forTimeInterval: 1)
    print("Background task")
}
print("After task") // sync (after task complition)

concurrentQueue.async {
    Thread.sleep(forTimeInterval: 1)
    print("Background task")
}
print("After task")

// Instead of using lambda, the task can be submitted as DispatchWorkItem instance. This allows cancellation of the task or notification of another DispatchWorkItem that it should be executed after the current task completes

let task = DispatchWorkItem {
    print("Task")
}

let otherTask = DispatchWorkItem {
    print("Other Task")
}

task.notify(queue: .main, execute: otherTask)

concurrentQueue.async(execute: task)

// Runs task on UI thread
DispatchQueue.main.async {
    print("UI task")
}

func onMainThread(closure: @escaping () -> ()) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async(execute: closure)
    }
}

onMainThread {
    print("UI task")
}

// DispatchGroup allows to track the completion of a group of tasks

let group = DispatchGroup()

concurrentQueue.async(group: group) {
    print("Background async task")
}

serialQueue.async(group: group) {
    Thread.sleep(forTimeInterval: 10)
    print("Background async task")
}

//if group.wait(timeout: .now() + 60) == .timedOut {
//    print("The jobs didn't finished in 60 seconds")
//} else {
//    print("The jobs finished in 60 seconds")
//}

// In the case of nested asynchronous tasks, the programmer should indicate their completion so that it is clear when the main task should end
concurrentQueue.async(group: group) {
    print("Task")
    group.enter()
    concurrentQueue.async {
        Thread.sleep(forTimeInterval: 1)
        print("Inner Task")
        group.leave()
    }
}

group.notify(queue: .main) {
    print("All jobs completed")
}

// DispatchSemaphore allows to control how many threads have access to a shared resource
let semaphore = DispatchSemaphore(value: 2)

for i in 1...5 {
    concurrentQueue.async {
        defer { semaphore.signal() }
        semaphore.wait()
        Thread.sleep(forTimeInterval: 5)
        print("Image \(i) downloaded")
    }
}

class Cache<Key: Hashable, T> {
    
  private var cache: [Key: T] = [:]
  private let semaphore = DispatchSemaphore(value: 1)

  func getValue(forKey key: Key) -> T? {
    semaphore.wait()
    let value = cache[key]
    semaphore.signal()
    return value
  }
    
  func setValue(_ value: T, forKey key: Key) {
    semaphore.wait()
    cache[key] = value
    semaphore.signal()
  }
    
}

class Cache2<Key: Hashable, T> {
  
  private var cache: [Key: T] = [:]
  private let lock = NSLock()
    
  func getValue(forKey key: Key) -> T? {
    lock.lock()
    let value = cache[key]
    lock.unlock()
    return value
  }
    
  func setValue(_ value: T, forKey key: Key) {
    lock.lock()
    cache[key] = value
    lock.unlock()
  }
    
}

// Synchronization using serial queue, can lead to thread explosion)
class Counter {
    
    private let queue = DispatchQueue(label: "pl.training.internalQueue")
    private var _value = 0
    
    var value: Int {
        queue.sync { _value }
    }
    
    static func += (left: Counter, right: Int)  {
        left.increment(amount: right)
    }
    
    static func -= (left: Counter, right: Int)  {
        left.decrement(amount: right)
    }
    
    func increment(amount: Int = 1) -> Int {
        return queue.sync {
            _value += amount
            return _value
        }
    }
    
    func decrement(amount: Int = 1) -> Int {
        return queue.sync {
            _value -= amount
            return _value
        }
    }
}

var counter = Counter()
DispatchQueue.concurrentPerform(iterations: 10_000) { _ in
    counter += 1
}
print(counter.value)

// Synchronization using dispatch barrier (equivalent to read/write locks)
// Once the barrier hits, the queue pretends that it’s serial and only the barrier task can run until completion. Once it completes, all tasks that were submitted after the barrier task can again run concurrently
class Articles {
    
    private let queue = DispatchQueue(label: "pl.training.internalBarrierQueue", attributes: .concurrent) // queue should be concurrent
    private var _articles: [String] = []
    
    var articles: [String] {
        var copied: [String] = []
        queue.sync {
            copied = _articles
        }
        return copied
    }
    
    func add(article: String) {
        queue.sync(flags: .barrier) { [weak self] in // modification requires .barrier flag (task won’t occur until all of the previous reads have completed)
            self?._articles.append(article)
        }
    }
    
    func remove(at index: Int) -> String? {
        var removed: String? = nil
        queue.sync(flags: .barrier) { [weak self] in // modification requires .barrier flag
            removed = self?._articles.remove(at: index)
        }
        return removed
    }
    
}

PlaygroundPage.current.needsIndefiniteExecution = true
