//
//  OrderViewModel.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import Foundation
import Observation

final class OrderViewModel {
    
    var orderEntries = [
        OrderEntryViewModel(id: 1, name: "Mega burger", price: "40 zł"),
    ]
    var totalPrice = "60 zł"
    
}
