//
//  FakeWeatherProvider.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class FakeWeatherProvider: WeatherProvider {
   
    func getWeather(for city: String) async -> Weather? {
        Weather(city: "Warsaw", forecast: [
            DayForecast(id: UUID(), date: Date(), description: "cloudy", temperature: 18.0, pressure: 1000, icon: "cloud.fill"),
            DayForecast(id: UUID(), date: Date(), description: "sunny", temperature: 17.0, pressure: 1001, icon: "sun.max.fill"),
            DayForecast(id: UUID(), date: Date(), description: "heavy rain", temperature: 15.0, pressure: 1002, icon: "cloud.rain.fill"),
            DayForecast(id: UUID(), date: Date(), description: "sunny", temperature: 16.0, pressure: 999, icon: "sun.max.fill"),
            DayForecast(id: UUID(), date: Date(), description: "sunny", temperature: 20.0, pressure: 1000, icon: "sun.max.fill")
        ])
    }
    
    func getWeather(for location: (Double, Double)) async -> Weather? {
        await getWeather(for: "")
    }
    
}
