import PlaygroundSupport
import Foundation
import Combine
import Observation

var subscriptionSet = Set<AnyCancellable>()
//let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9].publisher
//
////let subscriber = Subscribers.Sink<Int, Never>(receiveCompletion: { _ in print("Completed") }) { value in
////    print("New value: \(value)")
////}
////numbers.subscribe(subscriber)
//
//func isEvent(value: Int) -> Bool {
//    value % 2 == 0
//}
//
//func min(_ minValue: Int) -> (Int) -> Bool {
//    { value in value > minValue }
//}
//
//numbers
//    // .filter { $0 % 2 == 0 }
//    .filter(isEvent)
//    .filter(min(3))
//    //.map(isEvent)
//    //.reduce(0) { sum, value in sum + value }
//    .scan(0) { sum, value in sum + value }
//    .sink {
//        print("New value: \($0)")
//    }
//
//let otherNumbers = [0, -1, -2].publisher
//let manyNumbers = numbers.merge(with: otherNumbers)
//    .sink {
//        print("New value: \($0)")
//    }
//
//let messages = ["Hi", "Hello", "How are you?"].publisher
//
//class Chat {
//    
//    var message: String = "" {
//        didSet {
//            print("Message: \(message)")
//        }
//    }
//    
//}
//
//let chat = Chat()
//
////let subscriber = Subscribers.Assign<Chat, String>(object: chat, keyPath: \.message)
////let subscription = messages.subscribe(subscriber)
//
//let subscription = messages.assign(to: \.message, on: chat)
//
////class MyTimer {
////    
////    var subscription: AnyCancellable!
////    
////    init() {
////        subscription = Timer.publish(every: 1, on: RunLoop.main, in: .common)
////            .autoconnect()
////            .sink { _ in
////                print("Tick \(Thread.current)")
////            }
////    }
////    
////}
////
////var timer: MyTimer? = MyTimer()
////DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
////    print("Cancelling")
////    // timer = nil
////    timer?.subscription.cancel()
////}
//
//// let subject = PassthroughSubject<String, Never>()
//let subject = CurrentValueSubject<String, Never>("Start")
//subject.send("123")
//
//subject.sink {
//    print($0)
//}
//.store(in: &subscriptionSet)
//
//subject.send("Hello")
//subject.send(completion: .finished)
//subject.send("Hi")
//subject.send("Abc")
//
//Just([1, 2, 3]).sink {
//    print($0)
//}
//
//
//print("Start current thread: \(Thread.current)")
//Just([1, 2, 3])
//    .subscribe(on: DispatchQueue.global())
//    .map {
//        Thread.sleep(forTimeInterval: 4) // bad, only for purpose of example
//        print("Map current thread: \(Thread.current)")
//        return $0
//    }
//    .receive(on: DispatchQueue.global())
//    .sink {
//        print("Sink current thread: \(Thread.current)")
//        print("New value: \($0)")
//    }
//    .store(in: &subscriptionSet)
//print("End current thread: \(Thread.current)")

struct MyError: Error {
}

let subject = PassthroughSubject<String, MyError>()
subject
//    .tryMap {
//        if $0.count < 400 {
//            throw MyError()
//        }
//        return $0
//    }
//    .catch { error in
//        Just("123")
//    }
//    .mapError { error in
//          MyError()
//    }
//   .replaceError(with: "123")
     .sink(receiveCompletion: { print($0) }) { print($0) }
subject.send("Hello")
subject.send(completion: .failure(MyError()))
subject.send("Hello2")


let newPublisher = ["1", "2"].publisher
    .setFailureType(to: MyError.self)

subject
    .merge(with: newPublisher)

let noErrorPublisher = newPublisher
    .assertNoFailure()

[1, 2].publisher
    .flatMap {
        Just($0 * 2)
    }
    .sink {
        print($0)
    }


// Mixing combine and async/await

class Search: ObservableObject {
    
    @Published var searchText = ""
    @Published var results: [String] = []
    
    init() {
        //        $searchText
        //            .debounce(for: 0.3, scheduler: DispatchQueue.main)
        //            .flatMap { query in
        //                let url = URL(string: "https://raw.githubusercontent.com/landrzejewski/bestweather-ios/main/data.txt?q=\(query)")!
        //                return URLSession.shared.dataTaskPublisher(for: url)
        //                    .map(\.data)
        //                    .decode(type: [String].self, decoder: JSONDecoder())
        //                    .replaceError(with: [])
        //            }
        //            .receive(on: DispatchQueue.main)
        //            .assign(to: &$results)
        
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

let result = Search().$results
result.sink {
    print($0)
}
.store(in: &subscriptionSet)

Task {
    let results = try? await Search().search(for: "abc")
    results?.forEach {
        print($0)
    }
}

func emailIsValid(_ email: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
    email
        .map { $0.contains("@") && $0.contains(".") }
        .map { $0 ? "" : "Invalid email" }
        .eraseToAnyPublisher()
}

func passwordIsValid(_ password: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
    password
        .map { $0.count > 6 }
        .map { $0 ? "" : "Password is too short" }
        .eraseToAnyPublisher()
}

Publishers.CombineLatest(emailIsValid(Just("abc@training.pl").eraseToAnyPublisher()), passwordIsValid(Just("123").eraseToAnyPublisher()))
    .dropFirst()
    .map { [$0, $1] }
    .map { errors in errors.filter { !$0.isEmpty } }
    .sink {
        print($0)
    }

PlaygroundPage.current.needsIndefiniteExecution = true
