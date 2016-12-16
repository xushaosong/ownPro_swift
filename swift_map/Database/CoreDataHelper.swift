//
//  CoreDataHelper.swift
//  swift_map
//
//  Created by xss@ttyhuo.cn on 2016/12/10.
//  Copyright © 2016年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit
import CoreData
class CoreDataHelper: NSObject {

    let store: CoreDataStore!
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.store = appDelegate.cdstore;
        
        super.init();
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveContext(notice:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil);
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator;

        var managerObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType);
        managerObjectContext.persistentStoreCoordinator = coordinator;
        return managerObjectContext;
    }();
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator;

        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType);
        backgroundContext.persistentStoreCoordinator = coordinator;
        return backgroundContext;
    }();
    func saveContext(context: NSManagedObjectContext) {

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    func saveContext() {
        self.saveContext(context: self.backgroundContext!);
    }
    func contextDidSaveContext(notice: Notification) {
        let sender = notice.object as! NSManagedObjectContext;
        if sender === self.managedObjectContext {
            NSLog("******** Saved main Context in this thread")
            self.backgroundContext!.perform({ 
                self.backgroundContext?.mergeChanges(fromContextDidSave: notice);
            });
        } else if sender === self.backgroundContext {
            NSLog("******** Saved background Context in this thread")
            self.managedObjectContext?.perform({ 
                self.managedObjectContext?.mergeChanges(fromContextDidSave: notice);
            });
        } else {
            NSLog("******** Saved Context in other thread")
            self.backgroundContext?.perform({ 
                self.backgroundContext?.mergeChanges(fromContextDidSave: notice);
            });
            self.managedObjectContext?.perform({ 
                self.managedObjectContext?.mergeChanges(fromContextDidSave: notice);
            });
        }
    }
}
