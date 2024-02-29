//
//  FakeLocationService.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import Foundation
import Combine

final class FakeLocationService: LocationService {
    
    var location: AnyPublisher<(Double, Double), Never>
    
    private let fakeCoordinates: (Double, Double)
    private let subject = PassthroughSubject<(Double, Double), Never>()
    
    init(fakeCoordinates: (Double, Double) = (21.017532, 52.237049)) {
        self.fakeCoordinates = fakeCoordinates
        location = subject.eraseToAnyPublisher()
    }
    
    func refreshLocation() {
        subject.send(fakeCoordinates)
    }
    
}
