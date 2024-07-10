//
//  CoreDataWeatherRepository.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import CoreData

final class CoreDataWeatherRepository: WeatherRepository {
    
    private let persistence: Persistence
    
    init(persistence: Persistence) {
        self.persistence = persistence
    }
    
    func save(weather: Weather) throws {
        let context = persistence.getContext()
        let createEntity = toEntity(context: context)
        try weather.forecast.forEach {
            _ = createEntity(weather.city, $0)
            try context.save()
        }
    }
    
    private func toEntity(context: NSManagedObjectContext) -> (String, DayForecast) -> ForecastEntity {
        { city, forecast in
            let forecastEntity = ForecastEntity(context: context)
            forecastEntity.date = forecast.date
            forecastEntity.conditions = forecast.description
            forecastEntity.temperature = forecast.temperature
            forecastEntity.pressure = forecast.pressure
            forecastEntity.icon = forecast.icon
            forecastEntity.city = city
            return forecastEntity
        }
    }
    
    func deleteAll() throws {
        let context = persistence.getContext()
        let fetchRequest = ForecastEntity.fetchRequest()
        fetchRequest.includesPropertyValues = false // get only ids
        try context.fetch(fetchRequest).forEach { context.delete($0) }
        try context.save()
    }
    
    func get(by city: String, callback: @escaping (Result<Weather, WeatherRepositoryError>) -> ()) {
        let context = persistence.getContext()
        let fetchRequest = ForecastEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(ForecastEntity.city), city)
        do {
            let entitities = try context.fetch(fetchRequest)
            if entitities.isEmpty {
                return callback(.failure(.noData))
            }
            let weather = Weather(city: city, forecast: entitities.map(toDomain))
            callback(.success(weather))
        } catch {
            callback(.failure(.operationFailed))
        }
    }
    
    private func toDomain(forecastEntity: ForecastEntity) -> DayForecast {
        DayForecast(id: UUID(), date: forecastEntity.date, description: forecastEntity.conditions, temperature: forecastEntity.temperature, pressure: forecastEntity.pressure, icon: forecastEntity.icon)
    }
    
}
