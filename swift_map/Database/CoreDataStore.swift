//
//  CoreDataStore.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit
import CoreData
class CoreDataStore: NSObject {

    let storeName = "db";
    let storeFileName = "MYDB.sqlit";
    
    lazy var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        
        return urls.last!
    }();
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd");
        return NSManagedObjectModel(contentsOf: modelURL!)!;
    }();
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel);
        let url = self.applicationDocumentDirectory.appendingPathComponent(self.storeFileName);
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var error: NSError? = nil;
            let dict = NSMutableDictionary();
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        return coordinator;
    }();
}
