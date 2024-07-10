//
//  Container+ext.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Factory

extension Container {
    
    var locationService: Factory<LocationService> {
        self { CoreLocationService() }.singleton
    }
    
    var fakeWeatherProvider: Factory<WeatherProvider> {
        self { FakeWeatherProvider() }.singleton
    }
    
    var openWeatherProvider: Factory<OpenWeatherProvider> {
        self { OpenWeatherProvider(url: "https://api.openweathermap.org/data/2.5/forecast/daily?cnt=7&units=metric&APPID=b933866e6489f58987b2898c89f542b8") }.singleton
    }
    
    var openWeatherProviderAdapter: Factory<WeatherProvider> {
        self { OpenWeatherProviderAdapter(provider: self.openWeatherProvider()) }.singleton
    }
    
    var persistence: Factory<Persistence> {
        self { Persistence() }.singleton
    }
    
    var weatherRepository: Factory<WeatherRepository> {
        //self { try! SqlWeatherRepository() }.singleton
        self { CoreDataWeatherRepository(persistence: self.persistence()) }
    }
    
    var forecastService: Factory<ForecastService> {
        _ = WeatherProviderLoggerProxy(provider: self.openWeatherProviderAdapter())
        return self { ForecastService(weatherProvider: self.openWeatherProviderAdapter() , weatherRepository: self.weatherRepository()) }.singleton
    }
    
    var forecastViewModel: Factory<ForecastViewModel> {
        self { ForecastViewModel(forecastService: self.forecastService(), locationService: self.locationService()) }.singleton
    }
    
    var fakeForecastViewModel: Factory<ForecastViewModel> {
        let forecastService = ForecastService(weatherProvider: self.fakeWeatherProvider(), weatherRepository: FakeWeatherRepository())
        return self { ForecastViewModel(forecastService: forecastService, locationService: self.locationService()) }.singleton
    }
    
    var profileViewModel: Factory<ProfileViewModel> {
        self { ProfileViewModel() }.singleton
    }
    
    var foodListViewModel: Factory<FoodListViewModel> {
        self { FoodListViewModel() }.singleton
    }
    
    var orderViewModel: Factory<OrderViewModel> {
        self { OrderViewModel() }.singleton
    }
    
}
