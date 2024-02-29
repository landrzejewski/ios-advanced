//
//  DayForecast.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation

struct DayForecast: Identifiable {
    
    let id: UUID
    let date: Date
    let description: String
    let temperature: Double
    let pressure: Double
    let icon: String
 
}
