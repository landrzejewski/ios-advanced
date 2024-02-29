//
//  ProfileViewModel.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import Foundation

@Observable
final class ProfileViewModel {
    
    var firstName = ""
    var lastName = ""
    var dateOfBirth = Date()
    var email = ""
    var password = ""
    var isSubscriber = false
    var cardNumber = ""
    var cardCvv = ""
    var cardExpirationDate = Date()
    var errors: [String] = []

}
