//
//  CoreLocationService.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation
import CoreLocation
import Combine

final class CoreLocationService: NSObject, CLLocationManagerDelegate, LocationService {
    
    private let locationManager = CLLocationManager()
    private let subject = PassthroughSubject<(Double, Double), Never>()
    
    var location: AnyPublisher<(Double, Double), Never>
    
    override init() {
        location = subject.eraseToAnyPublisher()
        super.init()
        locationManager.delegate = self
    }
    
    func refreshLocation() {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            let coordinates = (Double(location.longitude), Double(location.latitude))
            subject.send(coordinates)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        refreshLocation()
    }
 
}
