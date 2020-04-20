//
//  FirebaseUtils.swift
//  IOSPortifolio
//
//  Created by Jefferson Barbosa Puchalski on 29/07/19.
//  Copyright © 2019 Jefferson Puchalski. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/// Class to manage and use all firebase additional features
class FirebaseUtils {
    /// Singleton of FirebaseUtils class instance
    static let sharedRemoteInstance = FirebaseUtils()
    
    /**
     Initialize the class with some default values from System-Messsage.plist
    */
    public init() {
        loadDefaultValues()
    }
    
    /**
     Set given value for a message with a given key.
     
     This method have some important rules to be care about, and must be followed:
        1. You must input the correct key, if you provide a incorrect, the method will send you a empty string.
        2. Firebase can't recoginized all variable types in swift, regarding this, we just return 3 types and they are listed below
         * Bool
         * String
         * NSNumber
     And we have a code exemple, to how you can enable this in code, the exemple is showed below:
     ```
     FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "error_login_unauthorized", typeOfValue: &response)
     ```
     Finaly, the cloud message are fetched in 43200 seconds when application is in production, about 12 hours.
     - Parameters:
        - key: A indentifier key to retrive the value from firebase cloud or for his default value.
        - typeOfValue: This is a arg passed by reference, used to insert the correct message type in given parameter.
    */
    public func SetValueByRemote<T>(key: String, typeOfValue: inout T?) {
        if(type(of: typeOfValue) == Bool.self){
            typeOfValue = RemoteConfig.remoteConfig().configValue(forKey: key).boolValue as? T
        } else if(type(of: typeOfValue) == String.self){
            typeOfValue = RemoteConfig.remoteConfig().configValue(forKey: key).stringValue as? T
        } else if(type(of: typeOfValue) == NSNumber.self){
            typeOfValue = RemoteConfig.remoteConfig().configValue(forKey: key).numberValue as? T
        }
    }
    
    func loadDefaultValues() {
        RemoteConfig.remoteConfig().setDefaults(fromPlist: "System-Messages")
    }
    
    /**
     Fetch all firebase remote message values from cloud.
     
     Get all remote message values into the application, if we can't retrive they, default value from `System-Message.plist` will be used.
     - Important:
        If you are going to put application in production, the `fetchDuration` variable is set to 43200 seconds about 12 hours to prevent high polling and generate costs, and if you are in developing this value is set to 0.
    */
    func fetchCloudValues() {
        // 1
        // WARNING: Don't actually do this in production!
        // SEE: Before you launch this app for real, make sure you disable developer mode and set your fetchDuration to something a little more reasonable, like 43200> — that’s 12 hours to you and me.
        #if DEBUG
            let fetchDuration: TimeInterval = 0
        #else
            let fetchDuration: TimeInterval = 43200
        #endif
        // Fetch config
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
            
            if let error = error {
                print("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            // 2
            RemoteConfig.remoteConfig().activate(completionHandler: { (error) in
                print("Error in activate RemoteConfig")
            })
            print("Retrieved values from the cloud!")
        }
    }
}
