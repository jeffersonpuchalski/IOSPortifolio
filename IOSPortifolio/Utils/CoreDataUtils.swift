//
//  CoreDataUtils.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 17/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataUtils {
    
    /**
     Create data for current DataModel.
     - Parameter: dictionary Dictionary containing the current data
     
    */
    func createData(entity: String,dictonary: NSDictionary) -> Bool{
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        //final, adding data in foreach array
        for (key, value) in dictonary{
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(value, forKeyPath: key as! String)
            user.setValue(value, forKey: key as! String)
            user.setValue(value, forKey: value as! String)
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
    
    func updateData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "username")
            objectUpdate.setValue("newmail", forKey: "email")
            objectUpdate.setValue("newpassword", forKey: "password")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
    func deleteData(predicate: [String : String], entity: String){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        for(format_in,value) in predicate {
            // Add a predicate and execute a delete stmt, after delete commit.
            fetchRequest.predicate = NSPredicate(format: format_in, value)
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
                
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
                
            }
            catch
            {
                print(error)
            }
            
        }
    }
    
    
    func retriveData(entity: String, key: String){
        // We need the delegate from appDelegate to access.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: key) as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
}
