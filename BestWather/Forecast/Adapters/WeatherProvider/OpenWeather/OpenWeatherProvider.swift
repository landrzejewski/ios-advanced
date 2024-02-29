//
//  OpenWeatherProvider.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class OpenWeatherProvider {
    
    private let url: String
    private let decoder: JSONDecoder
    
    init(url: String, decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        self.url = url
    }
    
    func getWeather(for city: String) async -> WeatherDto? {
        guard let url = URL(string: "\(url)&q=\(city)") else {
            return nil
        }
        return await getWeather(url: url)
    }
    
    func getWeather(for location: (Double, Double)) async -> WeatherDto? {
        guard let url = URL(string: "\(url)&lon=\(location.0)&lat=\(location.1)") else {
            return nil
        }
        return await getWeather(url: url)
    }
    
    private func getWeather(url: URL) async -> WeatherDto? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try decoder.decode(WeatherDto.self, from: data)
        } catch {
            return nil
        }
    }
    
}
