//
//  Capitalized.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 17/05/2022.
//

import Foundation

@propertyWrapper
struct Capitalized {
    
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
    
}
