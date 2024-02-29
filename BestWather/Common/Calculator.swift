//
//  Calculator.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 19/05/2022.
//

import Foundation

final class Calculator {

    let queue = DispatchQueue.global(qos: .userInitiated)
    
    func add(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber + secondNumber
    }
    
    func divide(firstNumber: Double, secondNumber: Double) throws -> Double {
        if secondNumber == 0 {
            throw CalculatorError.illegalArgument
        }
        return firstNumber + secondNumber
    }
    
    func getRandomPrime(callback: @escaping (Int) -> ()) {
        print("1")
        queue.asyncAfter(deadline: .now() + 5) {
            print("3")
            callback(3)
        }
        print("2")
    }
    
}

enum CalculatorError: Error {
    
    case illegalArgument
    
}
