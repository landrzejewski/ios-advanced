//
//  CoreDataWeatherRepository.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 17/01/2024.
//

import Foundation
import CoreData

final class CoreDataWeatherRepository: WeatherRepository {
    
    private let persistence: Persistence
    
    init(persistence: Persistence) {
        self.persistence = persistence
    }
   
    func save(weather: Weather) throws {
        let context = persistence.context()
        for forecast in weather.forecast {
            let forecastEntity = ForecastEntity(context: context)
            forecastEntity.date = forecast.date
            forecastEntity.conditions = forecast.description
            forecastEntity.temperature = forecast.temperature
            forecastEntity.pressure = forecast.pressure
            forecastEntity.icon = forecast.icon
            forecastEntity.city = weather.city
            try context.save()
        }
    }
    
    func deleteAll() throws {
        let context = persistence.context()
        let fetchRequest = ForecastEntity.fetchRequest()
        fetchRequest.includesPropertyValues = false // get only ids
        try context.fetch(fetchRequest).forEach { entity in
            context.delete(entity)
        }
        try context.save()
    }
    
    func get(by city: String, callback: @escaping (Result<Weather, WeatherRepositoryError>) -> ()) {
        let fetchRequest: NSFetchRequest<ForecastEntity> = ForecastEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(ForecastEntity.city), city)
        do {
            let entities = try persistence.context().fetch(fetchRequest)
            if entities.isEmpty {
                return callback(.failure(.operationFailed))
            }
            let weather = Weather(city: city, forecast: entities.map(map(forecastEntity:)))
            callback(.success(weather))
        } catch {
            callback(.failure(.operationFailed))
        }
    }
    
    private func map(forecastEntity: ForecastEntity) -> DayForecast {
        DayForecast(id: UUID(), date: forecastEntity.date!, description: forecastEntity.conditions!, temperature: forecastEntity.temperature, pressure: forecastEntity.pressure, icon: forecastEntity.icon!)
    }
    
}
