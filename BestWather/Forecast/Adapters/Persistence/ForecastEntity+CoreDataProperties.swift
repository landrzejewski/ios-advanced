//
//  ForecastEntity+CoreDataProperties.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 17/01/2024.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var conditions: String?
    @NSManaged public var temperature: Double
    @NSManaged public var pressure: Double
    @NSManaged public var icon: String?
    @NSManaged public var city: String?

}

extension ForecastEntity : Identifiable {

}
