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

let globalQueue = DispatchQueue.global(qos: .userInitiated)
let serialQueue = DispatchQueue(label: "pl.training.serial")
let concurrentQueue = DispatchQueue(label: "pl.training.concurrent", attributes: .concurrent)
let otherConcurrentQueue = DispatchQueue(label: "pl.training.otherConcurrent", qos: .userInitiated, attributes: .concurrent) // Quality of service can be changed by system when submitting tasks with different qos value

// Submitting task using sync can be potentially dangerous (main thread blocking, deadlocks)

/*
concurrentQueue.sync {
    Thread.sleep(forTimeInterval: 1)
    print("Backgroud task \(Thread.current)")
}
print("After backgroud task \(Thread.current)") // after task complition
*/

/*
concurrentQueue.async {
    Thread.sleep(forTimeInterval: 1)
    print("Backgroud task \(Thread.current)")
}
print("After task \(Thread.current)")
*/

// Instead of using lambda, the task can be submitted as DispatchWorkItem instance. This allows cancellation of the task or notification of another DispatchWorkItem that it should be executed after the current task completes

/*
let task = DispatchWorkItem {
    Thread.sleep(forTimeInterval: 1)
    print("Task")
}

let otherTask = DispatchWorkItem {
    print("Other task")
}

task.notify(queue: .main, execute: otherTask)

concurrentQueue.async(execute: task)
*/

// Runs task on UI thread

/*
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
*/


// DispatchGroup allows to track the completion of a group of tasks

/*
 let group = DispatchGroup()
 
 concurrentQueue.async(group: group) {
    Thread.sleep(forTimeInterval: 60)
    print("Background task")
 }
 
 serialQueue.async(group: group) {
    print("Other background task")
 }
 
 if group.wait(timeout: .now() + 5) == .timedOut {
    print("The jobs didn't finished in expected time")
 } else {
    print("The jobs finised in expected time")
 }
*/

// In the case of nested asynchronous tasks, the programmer should indicate their completion so that it is clear when the main task should end

/*
let group = DispatchGroup()

concurrentQueue.async(group: group) {
    print("Background task")
    //group.enter()
    concurrentQueue.async(group: group) {
        Thread.sleep(forTimeInterval: 5)
        print("Inner cackground task")
        //group.leave()
    }
}

group.notify(queue: .main) {
    print("All jobs completed")
}
*/

// DispatchSemaphore allows to control how many threads have access to a shared resource

/*
let semaphore = DispatchSemaphore(value: 2)

for i in 1...5 {
    concurrentQueue.async {
        defer { semaphore.signal() }
        semaphore.wait()
        print("Before background task \(i)")
        Thread.sleep(forTimeInterval: 5)
        print("Background task \(i)")
    }
}
*/


class Cache<Key: Hashable, Value> {
    
    private var cache: [Key: Value] = [:]
    // private let semaphore = DispatchSemaphore(value: 1)
    
    // private let lock = NSLock()
    
    // private let serialQueue = DispatchQueue(label: "pl.traing.internalCacheQueue") // Synchronization using serial queue, can lead to thread explosion
   
    private let concurrentQueue = DispatchQueue(label: "pl.traing.internalCacheQueue", attributes: .concurrent)
    
    func getValue(forKey key: Key) -> Value? {
        // defer { semaphore.signal() }
        // semaphore.wait()
   
        
        // defer { lock.unlock() }
        // lock.lock()
   
        // return serialQueue.sync { cache[key] }
        
        return concurrentQueue.sync { cache[key] }
    }
    
    func setValue(_ value: Value, forKey key: Key) {
        // semaphore.wait()
        // lock.lock()
   
        // cache[key] = value
       
        // semaphore.signal()
        // lock.unlock()
        
       // serialQueue.sync { cache[key] = value }
        
        concurrentQueue.sync(flags: .barrier) { cache[key] = value } // modification requires .barrier flag (task won’t occur until all of the previous reads have completed)
    }
    
}

PlaygroundPage.current.needsIndefiniteExecution = true
























/*
https://en.wikipedia.org/wiki/Sleeping_barber_problem

This is a simple demonstration of how to solve the Sleeping Barber dilemma, a classic computer science problem
which illustrates the complexities that arise when there are multiple operating system processes. Here, we have
a finite number of barbers, a finite number of seats in a waiting room, a fixed length of time the barbershop is
open, and clients arriving at (roughly) regular intervals. When a barber has nothing to do, he or she checks the
waiting room for new clients, and if one or more is there, a haircut takes place. Otherwise, the barber goes to
sleep until a new client arrives. So the rules are as follows:

  - if there are no customers, the barber falls asleep in the chair
  - a customer must wake the barber if he is asleepf a customer arrives while the barber is working, t
  - ihe customer leaves if all chairs are occupied and sits in an empty chair if it's available
  - when the barber finishes a haircut, he inspects the waiting room to see if there are any waiting customers and falls asleep if there are none
  - shop can stop accepting new clients at closing time, but the barbers cannot leave until the waiting room isempty
  - after the shop is closed and there are no clients left in the waiting area, the barber goes home

 The Sleeping Barber was originally proposed in 1965 by computer science pioneer Edsger Dijkstra.
*/
