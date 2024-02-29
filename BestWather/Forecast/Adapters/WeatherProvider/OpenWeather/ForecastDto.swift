//
//  ForecastDto.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

struct ForecastDto: Codable {
    
    let pressure: Double
    let humidity: Int
    let description: [DescriptionDto]
    let temperature: TemperatureDto
    let date: Double
    
    enum CodingKeys: String, CodingKey {
        
        case pressure
        case humidity
        case description = "weather"
        case temperature = "temp"
        case date = "dt"
        
    }
    
}
