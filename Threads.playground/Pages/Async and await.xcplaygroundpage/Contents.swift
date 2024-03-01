import PlaygroundSupport
import Foundation
import CoreLocation

let url = URL(string: "https://raw.githubusercontent.com/landrzejewski/bestweather-ios/main/data.json")!

/*
 Awaiting the async function pauses current execution and frees up the thread (it can be utilized for some other work). Once the async task is completed our original function can continue (not necessarily in the original thread). A regular function must be executed in one go, building up and unwinding its call stack uninterrupted, an asynchronous function does not have this limitation. It’s possible for Swift to take the call stack for an async function and put it aside for a while
 
 We can only call an async function only from a context that is already asynchronous e.g. using Task instance or task modifier (run on show, cancel on remove)
 
 Swift Concurrency ensures that there’s only a certain number of threads spawned in our application. It does this to prevent thread explosion
 
 Task can be created with one of three priorities;
 .userInitiated - default
 .utility
 .background
 */



/*
 Task {
 do {
 let fetchedMovies = try await fetchPage(currentPage)
 await MainActor.run {
 // update ui
 }
 } catch {
 // handle the error in some way
 }
 }
 */

/*
 An async function will always run on a background thread unless it was explicitly tied to the main actor
 Awaiting an async function creates a suspension point, this allows the thread that was running your task to make progress on other tasks while you’re suspended
 In SwiftConcurrency, an async function does not run on the thread it was called from. The function itself decides whether it’s run on the main actor or on a background thread
 When an awaited function completes, all of the work that is awaited within that function must also have completed (structured concurrency)
 
 While a task that’s created with the plain Task initializer inherits the actor and task local values from the context it was created in, Task.detached inherits neither of those attributes from its context
 
 Task.detached {
 let userInfo = try await fetchUserInfo()
 }
 
 Tasks have an implicit self capture which means that you can freely use and access members of self inside of a task
 For long tasks, not executed from UI context, one should weakly capture self-reference and define some kind of terminating condition
 
 Task { [weak self] in
 var hasMorePages = true
 var currentPage = 0
 while hasMorePages {
 guard let self = self else {
 return
 }
 let page = await self.networking.fetchPage(currentPage)
 if page.hasMorePages {
 currentPage += 1
 self.items.append(page) } else {
 hasMorePages = false
 }
 }
 }
 
 Task will catch errors automatically without any complaining from the compiler. This can lead to unclear code, so in many cases, it is worth adding a catch block
 
 Task {
 do {
 let userInfo = try await fetchUserInfo() }
 catch {
 // ignore errors...
 }
 }
 
 When you create a task, you can assign the task itself to a property. Your task can then eventually produce a value which we can extract through the task’s value property. Note that even when our task returns nothing, we can access the value property to know when our task completed
 
 let taskOne = Task {
 return try await fetchUserInfo()
 }
 // Compiler error: Property access can throw, but it is not marked 􏰀→ with 'try' and the error is not handled
 let userInfoOne = await taskOne.value
 let taskTwo = Task {
 do {
 return try await fetchUserInfo() }
 catch {
 return nil
 
 }
 }
 let userInfoTwo = await taskTwo.value
 */

func fetchJson(url: URL) async -> String? {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(bytes: data, encoding: .utf8)
    } catch {
        print("Error: \(error)")
        return nil
    }
}

// Runs the task asynchronous
Task {
    if let json = await fetchJson(url: url) {
        print(json)
    } else {
        print("Fetch failed")
    }
}

/*
func fetchJson(url: URL) async throws -> String? {
    let (data, _) = try await URLSession.shared.data(from: url)
    return String(bytes: data, encoding: .utf8)
}

Task {
    if let json = try? await fetchJson(url: url) {
        print(json)
    } else {
        print("Fetch failed")
    }
}
 */
 

/*
func fetchJson(url: URL) async throws -> [String?] {
    let (firstData, _) = try await URLSession.shared.data(from: url)
    let (secondData, _) = try await URLSession.shared.data(from: url)
    return [String(bytes: firstData, encoding: .utf8), String(bytes: secondData, encoding: .utf8)]
}

Task {
    if let json = try? await fetchJson(url: url) {
        print("Done \(json.count)")
    } else {
        print("Fetch failed")
    }
}
*/

/* async let will make sure that the child tasks we create complete before our function returns even if we don’t explicitly await the result of our network calls. Using an async let will also make sure that cancellationis properly propagated from the parent task to the child tasks that we create
 When you define a property as async let,you can call an async function without awaiting that function immediately. Instead, you create a child task that will run the function you’re calling asynchronously.The function you’re calling with async let will start running immediately when the async let is created. Instead of awaiting the resul to the function call, execution resumes to the next line

  
  Up until now you have worked with unstructured and detached tasks. You already know that an unstructured task is created with Task {} and that an unstructured task inherits things like actors and task local values. You also know that you can create a detached task using Task.detached and that a detached task inherits nothing from its creation context.
  
  Neither of these tasks are child tasks of their creation context. Some of the most importantant differences between child tasks and unstructured/detached tasks are the following:
  
  • A child task is cancelled when its parent task is cancelled
  • A parent task cannot complete until its child tasks have completed (either successfully
  or with an error)
  • A cancelled parent task does not stop the child task. Cancellation between parent and
  child tasks is cooperative which means the child task must check for cancellation and
  explicitly respect the cancellation by stopping its work.
  • Priority,actors,and task local values are inherited from the parent task
  The most important rules to understand are the first two on that list. Cancelling a parent task will mark its children as cancelled, and a parent task cannot complete unless its child tasks are completed. This is fully unique to child tasks, and it’s what makes child tasks structured. We’ll dig into this a bit more once we get to the section on structured concurrency.
  The key reason to use an async let is almost never “I want a child task”. Having a child task is more of a result of wanting to perform work in a specific way than a result of literally wanting a child task to exist.
  In the example you saw earlier an async let made sense because:
  • We had two async function calls we wanted to await in parallel
  • The two async functions had no dependencies on each other
  • Our function logicallyc ouldn’t complete unless both async functions completed
  
*/

func getText(value: UInt64) async -> String {
    try? await Task.sleep(nanoseconds: value * 1000 * 1000 * 1000)
    return "abc"
}

//func fetchText() async throws -> [String] {
//     let text = await getText(value: 3)
//     print("After first")
//     let text2 = await getText(value: 10)
//     print("After second")
//     return [text, text2]
//}

//func fetchText() async throws -> [String] {
//     async let text = getText(value: 3)
//     print("After first")
//     async let text2 = getText(value: 10)
//     print("After second")
//     return [await text, await text2]
//}
//
//Task {
//    if let json = try? await fetchText() {
//        print("Done \(json.count)")
//    } else {
//        print("Fetch failed")
//    }
//}


// Async sequences
/*
func fetchAndPrint(url: URL) async throws {
    for try await line in url.lines.filter({ entry in entry.count < 3 }) {
        print("-----------------------------------------------------------------------------------")
        print(line)
    }
}

Task {
    try? await fetchAndPrint(url: url)
}
*/

/*
struct IdGenerator: AsyncSequence, AsyncIteratorProtocol {
    
    typealias Element = Int
    
    private var counter = 1
    
    mutating func next() async throws -> Int? {
        counter += 1
        return counter
    }
    
    func makeAsyncIterator() -> IdGenerator {
        self
    }
    
}

Task {
    let generator = IdGenerator()
    for try await id in generator {
        print(id)
    }
}
*/

/*
func makeStream(values: Int) -> AsyncStream<String> { // AsyncThrowingStream for throwing streams
    var valueCount = 0
    return AsyncStream(unfolding: {
        let value = await produceValue(shouldTerminate: valueCount == values)
        valueCount += 1
        return value
    }/*, onCancel: {
        // called upon cancellation
    }*/)
}

func produceValue(shouldTerminate: Bool) async -> String? {
    guard !shouldTerminate else {
        return nil
    }
    return UUID().uuidString
}
*/

// A key difference between the unfolding closure and the continuation based approach is that the continuation gives us full control over how and when we produce values for our continuation.
// By default, all values that we we yield are buffered. This means that even though we immediately yield all values one after the other and then we complete the stream, anybody that chooses to iterate over our stream will receive all values that have been yielded before receiving the continuation.
/*
let stream = AsyncStream { continuation in
    print("will start yielding")
    continuation.yield(1)
    continuation.yield(2)
    continuation.yield(3)
    continuation.finish()
    print("finished the stream")
}

for await value in stream { print("received \(value)")
}
*/

// When you’re only interested in the most recent n items that were sent by your AsyncStream, you can give it a buffering policy through its initializer:
// A buffering policy like this is useful when you want to make sure that you always receive the last yielded value (if any) before receiving any new values.
// You can also provide a buffering policy of bufferingNewest(0) which would discard any values that weren’t received by a for loop immediately. This could be a useful buffering policy for an async stream that yields values for events like when the user rotates their device or taps on a button. You’re usually only interested in these kinds of events as soon as they occur but once they’ve occurred they lose all relevance; you wouldn’t want to start iterating over a stream only to be told that the user rotated their device 5 minutes ago; you’ve probably already handled that rotation event somehow.
// It’s also possible to provide numbers other than zero or one for your buffering policy. You might be interested in getting the last four of five values from your stream instead. You can simply provide a number that fits your requirements and you’re good to go.
// In addition to buffering the newest values received by your stream, you can also use a bufferingOldest policy. This will keep the first n values that were not yet received by a for loop, and discard any new values that are received until space opens up in the buffer.
// In addition to the ability to buffer values, an AsyncStream allows us to keep a reference to our continuation outside of the closure that we pass to our AsyncStream initializer. This allows us to yield values for our stream from outside of the initializer. For example, we can yield values in response to certain delegate methods being called on an object that created an AsyncStream and stored the stream’s continuation in a property.

/*
let stream = AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
    print("will start yielding")
    continuation.yield(1)
    continuation.yield(2)
    continuation.yield(3)
    continuation.finish()
    print("finished the stream")
}
*/

/*
class LocationProvider: NSObject {
  
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var continuation: AsyncStream<CLLocation>.Continuation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    deinit {
        continuation?.finish()
    }
    
    func requestPermissionIfNeeded() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation() -> AsyncStream<CLLocation> {
        requestPermissionIfNeeded()
        locationManager.startUpdatingLocation()
        return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            continuation.onTermination = { [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            }
            self.continuation = continuation }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            continuation?.yield(location)
        }
    }
}
 
// Bridging combine to AsyncSequence
 
 func startUpdatingLocation() -> AsyncPublisher<AnyPublisher<CLLocation, Never>> {
     requestPermissionIfNeeded()
     locationManager.startUpdatingLocation()
     return subject
        .compactMap({ $0 })
        .eraseToAnyPublisher()
        .values  // returns swquence that allows iteration/access for many clients
 }
 
 // async algorithms package
 
/*
func fetchJson(url: URL) async throws -> [String?] {
    let firstTask = Task { () -> String? in
        print("Start first task")
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(bytes: data, encoding: .utf8)
    }
    let secondTask = Task { () -> String? in
        print("Start second task")
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(bytes: data, encoding: .utf8)
    }
    if !firstTask.isCancelled {
        firstTask.cancel()
    }
    print("Before result")
    // firstTask.result
    return [try await firstTask.value, try await secondTask.value]
}

Task {
    do {
        let json = try await fetchJson(url: url)
        print("Done \(json.count)")
    }  catch {
        print("Fetch failed \(error)")
    }
    
}
*/
 
 // While async let is a fantastic tool to perform a handful of tasks in parallel as part of a single parent task or async function, we need a different mechanism to create (and await) any number of tasks.
 // when a child task in a Task Group throws an error, and we allow this error to be thrown from our Task Group closure, the system knows to cancel all of the child tasks, wait for all child tasks to honor their cancellation and complete their work, before the error is actually thrown from the Task Group so we can handle it. If the error would be thrown before all child tasks are completed, that would be a breach of structured concurrency since the parent (the Task Group) would throw an error (and complete) while it still has running child tasks.


/*
func printMessage() async throws {
    let text = try await withThrowingTaskGroup(of: String.self) { group -> String in
        group.addTask { "A" }
        group.addTask {
            print(Task.isCancelled )
            do {
                try Task.checkCancellation()
                return "B"
            } catch {
                print("Cleaning...")
            }
            return ""
        }
        group.addTask { "C" }
        group.addTask { "D" }
        
        group.cancelAll()
        var finalResult: [String] = []
        for try await result in group {
            finalResult.append(result)
            
        }
        
        return finalResult.joined(separator: ", ")
    }
    print(text)
}

Task {
    do {
        try await printMessage()
    } catch {
        print("Failed: \(error)")
    }
}
*/

// Callbacks and async/await integration
// Always make sure that you complete your continuations at some point
// Ensure that you don’t complete your continuations more than once, and to ensure that your continuation doesn’t get deallocated without first resuming it which would cause any code that awaits your continuation to be hanging forever, and resources that are held on to by the continuation to be retained which would be a leak
// Use checked continuations during development but switch to unsafe continuations once you’re ready to deploy


/*
func fetchJson(url: URL, callback: @escaping (String?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            callback(String(bytes: data, encoding: .utf8))
        } else {
            callback(nil)
        }
    }
    .resume()
}

func fetchJsonAsync(url: URL) async -> String? {
    // withCheckedThrowingContinuation
    // withUnsafeContinuation
    // withUnsafeThrowingContinuation
    await withCheckedContinuation { continuation in
        fetchJson(url: url) { continuation.resume(returning: $0) }
    }
}

Task {
    if let json = await fetchJsonAsync(url: url) {
        print("Done \(json.count)")
    } else {
        print("Fetch failed")
    }
}
*/

// Actors protect their mutable state by ensuring exclusive access to its members. Only one caller can access and mutate actor state at once (like locks but without blocking)
// By writing nonisolated func, we tell the compiler that our function can be called from a nonisolated context because it does not mutate the state
// let constants can freely be accessed from anywhere without an await
actor Account {
    
    var balace: Decimal
    let id = UUID().uuidString
    
    init(initialBalance: Decimal) {
        balace = initialBalance
    }
    
    func deposit(amount: Decimal) {
        balace += amount
    }
    
    func transfer(amount: Decimal, to other: Account) async {
        guard balace >= amount else {
            return
        }
        balace -= amount
        await other.deposit(amount: amount)
    }
    
    nonisolated func getId() -> String {
        id
    }
    
}

Task {
    let firstAccount = Account(initialBalance: 1000)
    let secondAccount = Account(initialBalance: 0)
    await firstAccount.deposit(amount: 200)
    await firstAccount.transfer(amount: 500, to: secondAccount)
    print("First account: \(await firstAccount.balace)")
    print("Second account: \(await secondAccount.balace)")
}

// When actor is suspended new caller can be serviced. Thats why we should always protect actors state
// The result of actor reentrancy is that any assumptions we make before an await should always be re-validated after an await

actor ImageLoader {
    
    private var imageData: [UUID: LoadingState] = [:]
    
    func loadImageData(using id: UUID) async throws -> Data {
        if let state = imageData[id] {
            switch state {
            case .loading(let task):
                return try await task.value
            case .completed(let data):
                return data
            }
        }
        
        let task = Task<Data, Error> {
            let url = URL(string: "baseUrl/\(id.uuidString)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        
        imageData[id] = .loading(task)
        
        do {
            let data = try await task.value
            imageData[id] = .completed(data)
            return data
        } catch {
            imageData[id] = nil
            throw error
        }
    }
}

extension ImageLoader {
    enum LoadingState {
        case loading(Task<Data, Error>)
        case completed(Data)
    }
}

// The main actor is an actor that synchronizes its work on the main thread. In practical terms this means that any code that executes on the main actor is run on the main thread
await MainActor.run {
    // update UI
}

@MainActor  // annotation for Functions, Objects(classes,structs), Closures, Properties
func updateUI() {
    // update UI
}

// While the main actor is currently the most useful example of a global actor we can define our own global actors by annotating an existing actor with @globalActor and conforming it to the GlobalActor protocol
// The GlobalActor protocol requires us to implement a static shared property that is used as the instance to defer executing code to whenever we annotate something with our global actor. In other words, when we annotate a function with @MyActor the instance of MyActor that we created as the shared instance is the actor instance that will receive the call to our annotated function
@globalActor
actor MyActor: GlobalActor {
    static let shared = MyActor()
}

/*
 Objects like actors can safely be passed around across concurrency contexts; they were made for that. Other objects like structs, classes, closures, and others are not always safe to pass around. They might hold some non-thread-safe (non-Sendable) state that would make it unsafe to pass an instance of a particular class from one place to the next. However these objects aren’t always unsafe to pass around.
 For example, a struct that doesn’t hold on to any reference types can safely be passed around in our app; after all structs are value types so we’re passing around copies of structs instead of references to a single instance of our struct. A class that only holds immutable state where each property defined on that class is a struct can be safely passed around because there’s no way to get into a data race when it’s impossible to mutate the data that we’re passing around.
 Objects that can be passed across concurrency contexts safely are referred to as Sendable in Swift. Sendable is defined as a protocol in Swift and it has no required properties or methods. It’s a so-called marker protocol that will mark our object as Sendable so that the compiler can check whether our object actually meets all of the requirements for being sendable
 
 To enable strict concurrency checking in your project, navigate to your project’s build settings tab and search for “strict concurrency”. By default, you will find this build setting to have a value of Minimal. As you can imagine, that will perform a very minimal set of constrains like explicit Sendable annotations for example (you will learn about Sendable annotations shortly).
 You could bump the concurrency checks to be Targeted which will enable sendability and actor isolation checks for your project using the same constraints that will be used in Swift 6.0. I would recommend you set this setting to be at least Targeted for existing projects where you want to ensure that your code is as thread safe as possible.
 The third setting is Complete. This will enable the full set of concurrency checks that exists in Swift 6.0. This includes sendability checking, actor isolation checks, and more. For new projects I would recommend you jump straight to setting your checking settings to Complete which will make sure that your code is compatible with Swift 6.0 right away
 
 Let’s take a closer look at all rules that make a value type implicitly conform to Sendable:
 - All members of the struct or enum must be sendable and
 – The struct or enum is marked as frozen or
 – The struct or enum is not public or
 – The struct or enum is not marked as @useableFromInline
 If your struct or enum does not meet all of the above requirements, you can manually add Sendable conformance to tell the compiler to check the sendability for your object.
 
 Classes can be manually marked to conform to the Sendable protocol but there are a few requirements that I’ll dig a bit deeper into in just a moment. Let’s list out the requirements first:
 - A sendable class mustbe final
 - All properties on the class must be sendable and immutable(declared as let)
 - The class cannot have any super classes other than NSObject
 - Classes annotated with @MainActor are implicitly sendable due to their synchronization through the main actor. This is true regardless of the class’ stored properties being mutable or sendable
 
 When you’re certain that you’ve taken the needed steps to ensure that your class is thread safe and fully free of data races you can force the compiler to accept your Sendable confor- mance without actually verifying your conformance by marking your class as @unchecked Sendable
 
 When a closure or function is sendable, the closure or function in question does not capture any non-sendable objects. And because functions and closures do not conform to protocols we declare sendability for these types using the @Sendable annotation
 Annotating a function or closure with @Sendable carries a heavy semantic meaning. It means you intend to use that closure or function in code that is concurrent, and it means that you want to make sure that calling your closure or function is completely thread-safe.

 @Sendable func sampleFunc() {
    // ...
 }
 
 var sample: @Sendable () -> Void = {
 }
 */

PlaygroundPage.current.needsIndefiniteExecution = true


// https://www.avanderlee.com/swift/thread-sanitizer-data-races

