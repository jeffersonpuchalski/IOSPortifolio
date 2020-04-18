//
//  Logger.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 05/02/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation
import os.log

enum LoggerCategory : String{
    case viewCycle = "viewCycle"
    case networning = "networking"
    case application = "application"
}

class Logger {
    
    weak var osLog: OSLog?
    
    //MARK: - Class lifecycle
    init() {
        
    }
    
    //MARK: - Methods
    func logDebug(message: String, category: LoggerCategory) {
        os_log("%s", log: OSLog.applyCategory(category: category), type: .info, message)
    }
    
    //MARK: - Singleton
    private static var _logger = Logger()
    
    class var shared: Logger {
        return _logger
    }
}


extension OSLog {
    /// Get the subsystem from main indenfifier bundle.
    private static var subsystem = Bundle.main.bundleIdentifier!
    /**
     Create a new OSLog with given category.
     - Parameters:
        - category: The new category applied on OSLog.
     */
    static func applyCategory(category: LoggerCategory) -> OSLog  {
        return OSLog(subsystem: subsystem, category: category.rawValue)
    }
}
