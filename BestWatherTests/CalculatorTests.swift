//
//  CalculatorTests.swift
//  BestWatherTests
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import XCTest
@testable import BestWather

final class CalculatorTests: XCTestCase {

    private let calculator = Calculator()
    
    override class func setUp() {
        print("Before test")
    }
    
    override class func tearDown() {
        print("Teardown test")
    }
    
    func test_given_two_numbers_when_add_then_returns_their_sum() throws {
        // given/arrange
        let firstNumber = 1.0
        let secondNumber = 2.0
        // when/act
        let result = calculator.add(firstNumber: firstNumber, secondNumber: secondNumber)
        // then/assert
        XCTAssertEqual(3.0, result)
    }

    func test_given_divisor_equals_zero_when_divide_then_throws_exception() {
        XCTAssertThrowsError(try calculator.divide(firstNumber: 3.0, secondNumber: 0))
    }
    
    func test_when_get_random_prime_then_returns_prime_number() throws {
//        let expectation = expectation(description: "Prime number is returned")
//        var primeNumber: Int?
//        calculator.getRandomPrime {
//            primeNumber = $0
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 10)
        
        let primeNumber = try asyncCall(calculator.getRandomPrime)
        XCTAssertEqual(3, primeNumber)
    }

}

extension XCTestCase {
    
    func asyncCall<Result> (_ callback: (@escaping (Result) -> ()) -> ()) throws -> Result {
        let expectation = expectation(description: "Async task")
        var result: Result?
        callback() {
            result = $0
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        guard let unwrappedResult = result else {
            fatalError()
        }
        return unwrappedResult
    }
    
}
