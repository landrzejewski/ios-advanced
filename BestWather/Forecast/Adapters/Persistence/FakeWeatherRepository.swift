//
//  FakeWeatherRepository.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 31/05/2023.
//

import Foundation

final class FakeWeatherRepository: WeatherRepository {
    
    private var data: [String: Weather] = [:]
    
    func save(weather: Weather) {
        data[weather.city] = weather
    }
    
    func deleteAll() {
        data.removeAll()
    }
    
    func get(by city: String, callback: @escaping (Result<Weather, WeatherRepositoryError>) -> ()) {
        if let weather = data[city] {
            callback(.success(weather))
        } else {
            callback(.failure(.operationFailed))
        }
    }
    
}
