import PlaygroundSupport
import Foundation

/*
 Operation type represents a task to execute.
 
 Operation possible states (lifecycle):
 isReady - task is created and ready to run
 isExecuting - start method was called
 isCancelled - cancel method was called
 isFinished - task ended (normally or as a result of cancellation)
 */

// BlockOperation run tasks concurrently, acts similar to a dispatch group in that it marks itself as being finished when all of the closures have finished

let operation = BlockOperation {
    print("1 + 1 = 2")
}

operation.addExecutionBlock {
    print("1 + 2 = 3")
}

operation.addExecutionBlock {
    Thread.sleep(forTimeInterval: 4)
    print("1 + 3 = 4")
}

operation.completionBlock = {
    print("Operation completed")
}

operation.start() // runs operations synchronous
print("After operation")

// OperationQueue accepts an Operation instance, an array of Operation instances, or a closure
// Operation instance can be used/run only once

let operationQueue = OperationQueue()

class DownloadImage: Operation {
    
    override func main() {
        print("Downloading image")
    }
    
}

let downloadingImage = DownloadImage()
downloadingImage.qualityOfService = .userInitiated // Can change OperationQueue quality of service
downloadingImage.completionBlock = {
    print("Image downloaded")
}

operationQueue.addOperation(downloadingImage)

// downloadingImage.addDependency(someOperation) // specifies operation dependency, all dependencies are available through the dependencies property
// downloadingImage.cancel() // only sets the isCancelled property to true, task/operation is not automatically interrupted. Cancelled operation will not start

// operationQueue.underlyingQueue = DispatchQueue(label: "pl.training.concurrent", attributes: .concurrent)
// operationQueue.addOperations([Operation], waitUntilFinished: true)
// operationQueue.waitUntilAllOperationsAreFinished()
// operationQueue.isSuspended = true // newly added operations will not be scheduled until you change isSuspended back to false
// operationQueue.maxConcurrentOperationCount = 2 // limits the number of operations which are running at a single time
// operationQueue.cancelAllOperations()

class AsyncOperation: Operation {
    
    private let lockQueue = DispatchQueue(label: "pl.training.async", attributes: .concurrent)
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _isExecuting: Bool = false
    
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished: Bool = false
    
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        print("Starting")
        guard !isCancelled else {
            finish()
            return
        }
        
        isFinished = false // good practice
        isExecuting = true
        main()
    }
    
    override func main() {
        // Use a dispatch after to mimic the scenario of a long-running task
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            print("Executing")
            self.finish()
        })
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}

let asyncOperation = AsyncOperation()
operationQueue.addOperations([asyncOperation], waitUntilFinished: true)


PlaygroundPage.current.needsIndefiniteExecution = true
