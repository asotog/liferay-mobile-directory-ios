//
//  PeopleDirectoryHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/18/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData

class PeopleDirectoryHelper {

    func removeAllData(managedObjectContext: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: "Person")
        var usersData = managedObjectContext.executeFetchRequest(request, error: nil) as [NSManagedObject]
        for user in usersData {
            managedObjectContext.deleteObject(user)
            managedObjectContext.save(nil)
        }
    }
    
    func fetchFromServer(managedObjectContext: NSManagedObjectContext) {
        // TODO: remove this, right now is resetting the table data
        self.removeAllData(managedObjectContext)
        
        // request data from server and stores it
        // TODO: refactor the following lines to cache server data properly
        let peopleDirectoryService = LRPeopledirectoryService_v62(session: SessionContext.createSessionFromCurrentSession())
        var error: NSError?
        var users = peopleDirectoryService.fetchAll(&error)
        var usersList = users["users"] as NSArray
        
        for user in usersList {
            let entityDescripition = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
            let person = Person(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
            person.fullName = user["fullName"] as NSString
            managedObjectContext.save(nil)
        }
    }
}
