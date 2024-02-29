//
//  SqlWeatherRepository.swift
//  BestWeather
//
//  Created by Łukasz Andrzejewski on 31/05/2023.
//

import Foundation
import SQLite

final class SqlWeatherRepository: WeatherRepository {
    
    private let db: Connection
    private let table = Table("forecast")
    private let id = Expression<String>("id")
    private let city = Expression<String>("city")
    private let icon = Expression<String>("icon")
    private let description = Expression<String>("description")
    private let temperature = Expression<Double>("temperature")
    private let pressure = Expression<Double>("pressure")
    private let date = Expression<Date>("date")

    init(dbName: String = "forecast.db") throws {
        let dbPath = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
            .path
        db = try Connection(dbPath)
        try db.run(table.create(ifNotExists: true) { table in
            table.column(id, primaryKey: true)
            table.column(city)
            table.column(icon)
            table.column(description)
            table.column(temperature)
            table.column(pressure)
            table.column(date)
        })
    }
   
    func save(weather: Weather) throws {
        let city = weather.city
        try weather.forecast.forEach { dayForecast in
            let insert = table.insert(
                id <- UUID().uuidString,
                self.city <- city,
                icon <- dayForecast.icon,
                description <- dayForecast.description,
                temperature <- dayForecast.temperature,
                pressure <- dayForecast.pressure,
                date <- dayForecast.date
            )
            try db.run(insert)
        }
    }
    
    func deleteAll() throws {
       try db.run(table.delete())
    }
    
    func get(by city: String, callback: @escaping (Swift.Result<Weather, WeatherRepositoryError>) -> ()) {
        let filter = table.filter(city == self.city)
        guard let rows = try? db.prepare(filter) else {
            callback(.failure(.operationFailed))
            return
        }
        callback(.success(Weather(city: city, forecast: rows.map(toDomain))))
    }
    
    private func toDomain(row: Row) -> DayForecast {
        DayForecast(id: UUID(uuidString: row[id])!, date: row[date], description: row[description], temperature: row[temperature], pressure: row[pressure], icon: row[icon])
    }
    
}
