//
//  FoodListViewModel.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import Foundation
import Observation

@Observable
final class FoodListViewModel {
    
    
    var isLoading = false
    var food = [
        FoodViewModel(id: 1, name: "Asparagus steak", description: "Nice and healthy steak", price: "20 zł", imageUrl: URL(string: "https://github.com/landrzejewski/bestweather-ios/blob/main/extras/images/asparagus-steak.png?raw=true")!),
        FoodViewModel(id: 2, name: "Healthy pizza", description: "Mega pizza", price: "90 zł", imageUrl: URL(string: "https://github.com/landrzejewski/bestweather-ios/blob/main/extras/images/healthy-pizza.png?raw=true")!),
        FoodViewModel(id: 3, name: "Mega burger", description: "Double cheeseburger", price: "40 zł", imageUrl: URL(string: "https://github.com/landrzejewski/bestweather-ios/blob/main/extras/images/big-burger.png?raw=true")!),
        FoodViewModel(id: 4, name: "Super fish", description: "Super good fish", price: "43 zł", imageUrl: URL(string: "https://github.com/landrzejewski/bestweather-ios/blob/main/extras/images/salmon-teriyaki-fish.png?raw=true")!)
    ]
    var showDetails = false
    var selectedFood: FoodViewModel?
    
}
