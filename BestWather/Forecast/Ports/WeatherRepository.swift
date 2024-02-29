//
//  WeatherRepository.swift
//  BestWeather
//
//  Created by Łukasz Andrzejewski on 31/05/2023.
//

import Foundation

protocol WeatherRepository {
    
    func save(weather: Weather) throws
    
    func deleteAll() throws
    
    func get(by city: String, callback: @escaping (Result<Weather, WeatherRepositoryError>) -> ())
    
}
