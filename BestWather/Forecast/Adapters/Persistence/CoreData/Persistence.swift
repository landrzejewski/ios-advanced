//
//  Persistence.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import CoreData

final class Persistence {
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores { (storeDescription, error) in
            if let error =  error as NSError? {
                fatalError("Fatal error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func getContext() -> NSManagedObjectContext {
        container.viewContext
    }
    
}
