//
//  WeatherProviderLoggerProxy.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class WeatherProviderLoggerProxy: WeatherProvider {
   
    private let provider: WeatherProvider
    
    init(provider: WeatherProvider) {
        self.provider = provider
    }
    
    func getWeather(for city: String) async -> Weather? {
        print("Fetching weather for city \(city)")
        return await provider.getWeather(for: city)
    }
    
    func getWeather(for location: (Double, Double)) async -> Weather? {
        print("Fetching weather for location \(location)")
        return await provider.getWeather(for: location)
    }
    
}
