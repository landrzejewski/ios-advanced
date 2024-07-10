import Combine
import Foundation
import PlaygroundSupport

// https://heckj.github.io/swiftui-notes

/*
 Functional reactive programming, also known as data-flow programming, builds on the concepts of functional programming. Where functional programming applies to lists of elements, functional reactive programming is applied to streams of elements. The kinds of functions in functional programming, such as map, filter, and reduce have analogues that can be applied to streams. In addition to functional programming primitives, functional reactive programming includes functions to split and merge streams. Like functional programming, you may create operations to transform the data flowing through the stream.

 There are many parts of the systems we program that can be viewed as asynchronous streams of information - events, objects, or pieces of data. The observer pattern watches a single object, providing notifications of changes and updates. If you view these notifications over time, they make up a stream of objects. Functional reactive programming, Combine in this case, allows you to create code that describes what happens when getting data in a stream.

 publisher - a publisher provides data when available and upon request. A publisher that has not had any subscription requests will not provide any data. When you are describing a Combine publisher, you describe it with two associated types: one for Output and one for Failure.
 
 subscriber - a subscriber is responsible for requesting data and accepting the data (and possible failures) provided by a publisher. A subscriber is described with two associated types, one for Input and one for Failure. The subscriber initiates the request for data, and controls the amount of data it receives. It can be thought of as "driving the action" within Combine, as without a subscriber, the other components stay idle.
 
 operator - an object that acts both like a subscriber and a publisher. Operators are classes that adopt both the Subscriber protocol and Publisher protocol. They support subscribing to a publisher, and sending results to any subscribers. You can create chains of these together (pipelines), for processing, reacting, and transforming the data provided by a publisher, and requested by the subscriber.
 
 back pressure - the subscriber drives the processing within a pipeline by providing information about how much information it wants or can accept. When a subscriber is connected to a publisher, it requests data based on a specific Demand. The demand request is propagated up through the composed pipeline. Each operator in turn accepts the request for data and in turn requests information from the publishers to which it is connected. With the subscriber driving this process, it allows Combine to support cancellation. Subscribers all conform to the Cancellable protocol. This means they all have a function cancel() that can be invoked to terminate a pipeline and stop all related processing.
 
 subjects - a special case of publisher that also adhere to the Subject protocol. This protocol requires subjects to have a .send(_:) method to allow the developer to send specific values to a subscriber (or pipeline). Subjects can be used to "inject" values into a stream, by calling the subject’s .send(_:) method. This is useful for integrating existing imperative code with Combine. A subject can also broadcast values to multiple subscribers. If multiple subscribers are connected to a subject, it will fan out values to the multiple subscribers when send(_:) is invoked. A subject is also frequently used to connect or cascade multiple pipelines together, especially to fan out to multiple pipelines.
 */

let numbers = [1, 2, 3, 4, 5, 6].publisher

/*
let subscriber = Subscribers.Sink<Int, Never>(receiveCompletion: { _ in print("Completed") }) { value in
    print("New value \(value)")
}
numbers.subscribe(subscriber)
*/

/*
func isEven(value: Int) -> Bool {
    value % 2 == 0
}

func min(_ minValue: Int) -> (Int) -> Bool {
    { value in value >= minValue }
}

func double(value: Int) -> Int {
    value * 2
}

let processedNumbers = numbers
    // .filter { $0 % 2 == 0 }
    .filter(isEven)
    .filter(min(3))
    .map(double)
    // .reduce(0) { sum, value in sum + value }
    .scan(0) { sum, value in sum + value }

let negativeNumbers = [0, -1, -2].publisher

processedNumbers
    .merge(with: negativeNumbers)
    .sink {
        print("New value \($0)")
    }

*/

/*
class Counter {
    
    var value: Int = 1 {
        didSet {
            print("Counter vaie: \(value)")
        }
    }
    
}

let counter = Counter()

/*
let subscriber = Subscribers.Assign<Counter, Int>(object: counter, keyPath: \.value)
numbers.subscribe(subscriber)
*/

numbers.assign(to: \.value, on: counter)
*/

/*

class MyTimer {
    
    var subscription: AnyCancellable!
    
    init() {
        self.subscription = Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink {
                print("Timeout: \($0)")
            }
    }
    
}

var timer: MyTimer? = MyTimer()
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    print("Cancelling")
    // timer = nil
    timer?.subscription.cancel()
}

subscriptions.removeAll()
*/

var subscriptions = Set<AnyCancellable>()

enum DataErrors: Error {
    
   case invalidValue
    
}

/*
// let subject = PassthroughSubject<String, DataErrors>()
let subject = CurrentValueSubject<String, DataErrors>("")
subject.send("a")

subject.sink(receiveCompletion: { result in
    switch result {
    case .finished:
        print("Completed")
    case .failure(let error):
        print("Error: \(error)")
    }
}) {
    print("New value: \($0)")
}
.store(in: &subscriptions)

subject.send("b")
subject.send("c")
// subject.send(completion: .finished)
subject.send(completion: .failure(DataErrors.invalidValue))
subject.send("d")

print("Last emitted value: \(subject.value)")
*/

/*
print("Current thread on start: \(Thread.current)")
Just([1, 2, 3])
    .map {
        Thread.sleep(forTimeInterval: 4) // bad, only for purpose of example
        print("Map current thread: \(Thread.current)") // bad, only for purpose of example
        return $0
    }
    .subscribe(on: RunLoop.main) // assigns a scheduler to the preceding pipeline invocationI
    .receive(on: DispatchQueue.global()) // effects itself and any operators chained after it, but not previous operators
    .sink {
        print("Sink current thread: \(Thread.current)")
        print("New value: \($0)")
    }
    .store(in: &subscriptions)
print("Current thread on finish: \(Thread.current)")
*/


/*
struct CustomError: Error {
}

struct OtherCustomError: Error {
}

let subject = PassthroughSubject<Int, CustomError>()
subject
    // catch handles errors by replacing the upstream publisher with another publisher that you provide as a return in a closure.
    // Be aware that this effectively terminates the pipeline. If you’re using a one-shot publisher (one that doesn’t create more than a single event), then this is fine.
    // .catch { error in Just(3) /*[3, 4, 5].publisher*/ }

    // mapError maps error to other error
    // .mapError { error in
    //    OtherCustomError()
    // }
    
    .replaceError(with: 0)

    .sink(receiveCompletion: { print($0) }) {
        print("New value: \($0)")
    }
    .store(in: &subscriptions)

subject.send(1)
// subject.send(completion: .failure(CustomError()))
subject.send(2)

let failingNumbersPublisher = [3, 4, 5].publisher
    .setFailureType(to: CustomError.self)
    
subject.merge(with: failingNumbersPublisher)
    .sink(receiveCompletion: { _ in }) {
        print("New value: \($0)")
    }
    .store(in: &subscriptions)

let noFailurePublisher: AnyPublisher<Int, CustomError> = failingNumbersPublisher
    .eraseToAnyPublisher()

*/

// Using flatMap and catch to handle errors without cancelling the pipeline

enum RequestErrors: Error {
    
    case requestFailed
    
}

/*
let url = URL(string: "https://raw.githubusercontent.com/landrzejewski/ios-advanced/mwwain/data.txt")!
Just(url)
    .flatMap { url in
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw RequestErrors.requestFailed
                }
                return data
            }
    }
    .map { String(data: $0, encoding: .utf8)! }
    .catch { _ in
        return Just("empty")
    }
    .eraseToAnyPublisher()
    .sink(receiveCompletion: { print($0) }) {
        print("New value: \($0)")
    }
    .store(in: &subscriptions)

 */

/*
class Search: ObservableObject {
    
    @Published var searchText = ""
    @Published var results: [String] = []
    
    init() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { URL(string: "https://raw.githubusercontent.com/landrzejewski/ios-advanced/mwwain/data.txt?query=\($0)")! }
            .flatMap {
                print($0)
                return URLSession.shared.dataTaskPublisher(for: $0)
            }
            .switchToLatest()
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw RequestErrors.requestFailed
                }
                return data
            }
            .map { [String(data: $0, encoding: .utf8)!] }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$results)
 
        /*
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .flatMap { query in
                Future { [weak self] promise in
                    guard let self = self else {
                    promise(.success([]))
                    return
                }
             Task {
                 do {
                     let results = try await self.search(for: query)
                     promise(.success(results)) }
                 catch {
                     // instead of failing, complete with empty result
                     promise(.success([]))
                 }
             }
         }
         */
     }
     .receive(on: DispatchQueue.main)
     .assign(to: &$results)

    }
 
    func search(for query: String) async throws -> [String] {
        let url = URL(string: "https://raw.githubusercontent.com/landrzejewski/bestweather-ios/main/data.txt?q=\(query)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder()
          .decode([String].self, from: data)
    }
    
}

let search = Search()
search.searchText = "abc"
search.searchText = "def"
 
let result = search.$results
result.sink {
     print($0)
}
.store(in: &subscriptionSet)

/*
Task {
  let results = try? await Search().search(for: "abc")
  results?.forEach {
    print($0)
  }
}
*/
 
*/

func emailValidator(_ email: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
    email
        .map { $0.contains("@") && $0.contains(".") }
        .map { $0 ? "" : "Invalid email" }
        .eraseToAnyPublisher()
}


func passwordValidator(_ password: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
    password
        .map { $0.count > 6 }
        .map { $0 ? "" : "Password is too short" }
        .eraseToAnyPublisher()
}

let email = PassthroughSubject<String, Never>()
let password = PassthroughSubject<String, Never>()

Publishers.CombineLatest(
    emailValidator(email.eraseToAnyPublisher()),
    passwordValidator(password.eraseToAnyPublisher())
)
.map { [$0, $1] }
.map { errorMessages in errorMessages.filter { !$0.isEmpty} }
.sink(receiveCompletion: { print($0) }) {
    print($0)
}
.store(in: &subscriptions)

email.send("jan")
password.send("123")

email.send("jan@trainig.pl")

password.send("123456789")

PlaygroundPage.current.needsIndefiniteExecution = true
