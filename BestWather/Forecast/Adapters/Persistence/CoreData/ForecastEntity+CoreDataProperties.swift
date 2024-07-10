//
//  ForecastEntity+CoreDataProperties.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var city: String
    @NSManaged public var conditions: String
    @NSManaged public var date: Date
    @NSManaged public var icon: String
    @NSManaged public var pressure: Double
    @NSManaged public var temperature: Double

}

extension ForecastEntity : Identifiable {

}
