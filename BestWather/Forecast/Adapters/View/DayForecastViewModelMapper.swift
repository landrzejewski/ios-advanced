//
//  DayForecastViewModelMapper.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

final class DayForecastViewModelMapper {
    
    func map(forecast: [DayForecast]) -> [DayForecastViewModel] {
        forecast.map(map(dayForecast:))
    }
    
    private func map(dayForecast: DayForecast) -> DayForecastViewModel {
        let date = dateFormatter.string(from: dayForecast.date)
        let temperature = map(temperature: dayForecast.temperature)
        let pressure = map(pressure: dayForecast.pressure)
        return DayForecastViewModel(id: dayForecast.id, date: date, description: dayForecast.description, temperature: temperature, pressure: pressure, icon: dayForecast.icon)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    private func map(temperature: Double) -> String {
        "\(Int(temperature))°"
    }
    
    private func map(pressure: Double) -> String {
        "\(Int(pressure)) hPa"
    }
    
}
