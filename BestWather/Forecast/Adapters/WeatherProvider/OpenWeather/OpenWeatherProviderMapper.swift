//
//  OpenWeatherProviderMappwe.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class OpenWeatherProviderMapper {
    
    func toDomain(_ weatherDto: WeatherDto) -> Weather {
        Weather(city: weatherDto.city.name, forecast: weatherDto.forecast.map(toDomain(forecastDto:)))
    }
    
    private func toDomain(forecastDto: ForecastDto) -> DayForecast {
        let date = Date(timeIntervalSince1970: forecastDto.date)
        let description = forecastDto.description.first?.text.capitalized ?? ""
        let temperature = forecastDto.temperature.day
        let pressure = forecastDto.pressure
        let icon = map(icon: forecastDto.description.first?.icon ?? "")
        return DayForecast(id: UUID(), date: date, description: description, temperature: temperature, pressure: pressure, icon: icon)
    }
    
    private func map(icon: String) -> String {
        switch icon {
        case "01d", "01n":
            return "sun.max.fill"
        case "02d", "02n":
            return "cloud.sun.fill"
        case "03d", "03n":
            return "cloud.fill"
        case "04d", "04n":
            return "smoke.fill"
        case "09d", "09n":
            return "cloud.rain.fill"
        case "10d", "10n":
            return "cloud.sun.rain.fill"
        case "11d", "11n":
            return "cloud.sun.bolt.fill"
        case "13d", "13n":
            return "snow"
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "xmark.circle"
        }
    }
    
}
