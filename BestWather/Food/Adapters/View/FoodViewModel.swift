//
//  FoodViewModel.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import Foundation

struct FoodViewModel: Identifiable {
    
    let id: Int
    let name: String
    let description: String
    let price: String
    let imageUrl: URL

}
