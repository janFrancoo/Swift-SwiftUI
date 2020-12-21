//
//  PersistenContentProvider.swift
//  VipExample
//
//  Created by JanFranco on 11.12.2020.
//

import CoreData

class PersistentContainerProvider {
    
    private init() {}
    
    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public static func getInstance() -> NSPersistentContainer {
        return persistentContainer
    }
    
}
