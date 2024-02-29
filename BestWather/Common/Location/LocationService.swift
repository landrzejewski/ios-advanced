//
//  LocationService.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation
import Combine

protocol LocationService {
    
    var location: AnyPublisher<(Double, Double), Never> { get }
    
    func refreshLocation()
    
}
