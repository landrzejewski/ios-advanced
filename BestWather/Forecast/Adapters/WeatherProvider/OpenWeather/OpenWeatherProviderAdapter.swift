//
//  OpenWeatherProviderAdapter.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class OpenWeatherProviderAdapter: WeatherProvider {
    
    private let provider: OpenWeatherProvider
    private let mapper: OpenWeatherProviderMapper
    
    init(provider: OpenWeatherProvider, mapper: OpenWeatherProviderMapper = OpenWeatherProviderMapper()) {
        self.provider = provider
        self.mapper = mapper
    }

    func getWeather(for city: String) async -> Weather? {
        guard let weatherDto = await provider.getWeather(for: city) else {
            return nil
        }
        return mapper.toDomain(weatherDto)
    }
    
    func getWeather(for location: (Double, Double)) async -> Weather? {
        guard let weatherDto = await provider.getWeather(for: location) else {
            return nil
        }
        return mapper.toDomain(weatherDto)
    }
    
}
