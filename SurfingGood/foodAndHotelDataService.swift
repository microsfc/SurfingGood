//
//  foodAndHotelDataService.swift
//  SurfingGood
//
//  Created by liusean on 02/07/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
import CoreData

class foodAndHotelDataService: NSObject {
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func saveRestaurantInformation(restaurantName: String, locationName: String, type: String, latitude: Float, longitude: Float) -> Bool {
        let context = foodAndHotelDataService.context
        let entity = NSEntityDescription.entity(forEntityName: "FoodInformation", in: context)
        let manageObj = NSManagedObject(entity: entity!, insertInto: context)
        manageObj.setValue(type, forKey: "type")
        manageObj.setValue(restaurantName, forKey: "restaurantName")
        manageObj.setValue(locationName, forKey: "locationName")
        manageObj.setValue(latitude, forKey: "latitude")
        manageObj.setValue(longitude, forKey: "longitude")
        manageObj.setValue(type, forKey: "type")
        do {
           try context.save()
           return true
        } catch {
            return false
        }
    }

    static func fetchRestaurantInformation() -> [FoodInformation] {
        let requestRestaurant = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodInformation")
        requestRestaurant.sortDescriptors = [NSSortDescriptor(key: "restaurantName", ascending: true)]
        
        var restaurantInformation: [FoodInformation]
        do {
            restaurantInformation = try foodAndHotelDataService.context.fetch(requestRestaurant) as! [FoodInformation]
            return restaurantInformation
        } catch {
            return []
        }
    }
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FoodAndHotelModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
