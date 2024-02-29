//
//  ForecastViewModel.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation
import Observation
import Combine

@Observable
final class ForecastViewModel {

    private let forecastService: ForecastService
    private let locationService: LocationService
    private let mapper: DayForecastViewModelMapper
    private var subscriptions = Set<AnyCancellable>()
    
    var city = ""
    var currentForecast: DayForecastViewModel?
    var nextDaysForecast: [DayForecastViewModel] = []
    
//    @ObservationIgnored
//    @UserProperty(key: "city", defaultValue: "")
//    private var storedCity
    
    init(forecastService: ForecastService, locationService: LocationService, mapper: DayForecastViewModelMapper = DayForecastViewModelMapper()) {
        self.forecastService = forecastService
        self.locationService = locationService
        self.mapper = mapper
        locationService.location
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: onNewCoordinates(coordinates:))
            .store(in: &subscriptions)
    }
    
//    func onActive() {
//        if !storedCity.isEmpty {
//            refreshForecast(for: storedCity)
//        }
//    }
    
    func refreshForecast(for city: String) {
        Task {
            guard let weather = await forecastService.getWeather(for: city) else {
                return
            }
            await onWeatherRefreshed(weather: weather)
        }
    }
    
    func refreshForecastForCurrentLocation() {
        locationService.refreshLocation()
    }
    
    func getLastForecast(for city: String) {
        Task {
            guard let weather = await forecastService.getLastWeather(for: city) else {
                return
            }
            await onWeatherRefreshed(weather: weather)
        }
    }
    
    private func onNewCoordinates(coordinates: (Double, Double)) {
        Task {
            guard let weather = await forecastService.getWeather(for: coordinates) else {
                return
            }
            await onWeatherRefreshed(weather: weather)
        }
    }
    
    @MainActor
    private func onWeatherRefreshed(weather: Weather) {
        let forecast = mapper.map(forecast: weather.forecast)
        self.city = weather.city
        self.currentForecast = forecast.first
        self.nextDaysForecast = Array(forecast.dropFirst())
    }

}
