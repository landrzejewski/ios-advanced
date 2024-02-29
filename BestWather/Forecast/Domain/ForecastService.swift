//
//  ForecastService.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class ForecastService {
    
    private let weatherProvider: WeatherProvider
    private let weatherRepository: WeatherRepository
    
    init(weatherProvider: WeatherProvider, weatherRepository: WeatherRepository) {
        self.weatherProvider = weatherProvider
        self.weatherRepository = weatherRepository
    }
    
    func getWeather(for city: String) async -> Weather? {
        let weather = await weatherProvider.getWeather(for: city)
        if let weather {
           saveWeather(weather: weather)
        }
        return weather
    }
    
    func getWeather(for location: (Double, Double)) async -> Weather? {
        let weather = await weatherProvider.getWeather(for: location)
        if let weather {
           saveWeather(weather: weather)
        }
        return weather
    }
    
    private func saveWeather(weather: Weather) {
        do {
            try weatherRepository.deleteAll()
            try weatherRepository.save(weather: weather)
        } catch {
            print(error)
        }
    }
    
    func getLastWeather(for city: String) async -> Weather? {
        await withCheckedContinuation { continuation in
            weatherRepository.get(by: city) { result in
                switch result {
                case .success(let weather):
                    continuation.resume(returning: weather)
                case.failure(_):
                    continuation.resume(returning: nil)
                }
            }
        }
        
    }
    
}
