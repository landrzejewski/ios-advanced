//
//  WeatherProvider.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

protocol WeatherProvider {
    
    func getWeather(for city: String) async -> Weather?
    
    func getWeather(for location: (Double, Double)) async -> Weather?
    
}
