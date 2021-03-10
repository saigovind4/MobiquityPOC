//
//  CoreDataHandler.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 07/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {
    
    // MARK: - CoreDataHandler Variables

    static let coreDataHandlerObj = CoreDataHandler()
    private var context : NSManagedObjectContext?
    private var entity : NSEntityDescription?
    private var newUser : NSManagedObject?

    // MARK: - CoreDataHandler Private init
    private init(){
        context = getContext()
        entity = NSEntityDescription.entity(forEntityName: AppConstants.coreDataEntityName, in: context!)
    }
    
    // MARK: - CoreData Get NSManagedObjectContext
    private func getContext() -> NSManagedObjectContext {
        let appDelegate: AppDelegate
        if Thread.current.isMainThread {
            appDelegate = UIApplication.shared.delegate as! AppDelegate
        } else {
            appDelegate = DispatchQueue.main.sync {
                return UIApplication.shared.delegate as! AppDelegate
            }
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - CoreData SAVE AND UPDATE Operation
    internal func saveContextData(cityData: WeatherInfoModel) {
        let entity = NSEntityDescription.entity(forEntityName: AppConstants.coreDataEntityName, in: context!)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "(city = %@)", cityData.name)
        request.predicate = predicate
        do {
            let results = try context!.fetch(request)
            if(results.count == 0){
                // Insert a new record
                newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser!.setValue(cityData.name, forKey: AppConstants.coreDataCity)
                newUser!.setValue(cityData.weather.first?.main, forKey: AppConstants.coreDatamaindescription)
                newUser!.setValue("\(cityData.main.temp)" + AppConstants.degreeUnicode, forKey: AppConstants.coreDataTemp)
                newUser!.setValue("\(cityData.main.humidity)", forKey: AppConstants.coreDataHumidity)
                newUser!.setValue("\(cityData.coord.lat)", forKey: AppConstants.coreDataLat)
                newUser!.setValue("\(cityData.coord.lon)", forKey: AppConstants.coreDataLong)
                try context?.save()
            } else {
                // Update the exisitng record.
                let objectUpdate = results.first as! NSManagedObject
                objectUpdate.setValue(cityData.name, forKey: AppConstants.coreDataCity)
                objectUpdate.setValue(cityData.weather.first?.main, forKey: AppConstants.coreDatamaindescription)
                objectUpdate.setValue("\(cityData.main.temp)" + AppConstants.degreeUnicode, forKey: AppConstants.coreDataTemp)
                objectUpdate.setValue("\(cityData.main.humidity)", forKey: AppConstants.coreDataHumidity)
                objectUpdate.setValue("\(cityData.coord.lon)", forKey: AppConstants.coreDataLong)
                objectUpdate.setValue("\(cityData.coord.lat)", forKey: AppConstants.coreDataLat)
                try context?.save()
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - CoreData FETCH Operation
    internal func fetchAllData()-> [NSManagedObject]
    {
        var citiesData : [NSManagedObject]!
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: AppConstants.coreDataEntityName)
        do {
            let results = try context!.fetch(fetchRequest)
            citiesData = results
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.description)")
        }
        return citiesData
    }
    
    // MARK: - CoreData DELETE Operation
    internal func deleteRecord(object: NSManagedObject)-> Bool
    {
        var result = false
        do {
            context!.delete(object)
            try context?.save()
            result = true
        } catch let error as NSError {
            result = false
            print("Could not fetch. \(error), \(error.description)")
        }
        return result
    }
}
