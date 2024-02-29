//
//  Persistence.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 17/01/2024.
//

import CoreData

final class Persistence {

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Weather")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func context() -> NSManagedObjectContext {
        container.viewContext
    }
    
}
