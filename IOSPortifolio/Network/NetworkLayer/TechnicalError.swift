//
//  TechnicalError.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 18/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation

/// Techinal error for response
class TechnicalError: Error {
    var userMessage: String?
    var tecnincalMessage: String?
    var netError: NetworkError?
    
    // Full init
    init(userMessage: String, message: String, netError: NetworkError) {
        self.userMessage = userMessage
        self.tecnincalMessage = message
    }
    
    // Init string and error.
    convenience init(userMessage: String, netError: NetworkError) {
        self.init(userMessage: userMessage, message: "", netError: netError)
        self.userMessage = userMessage
        self.netError = netError
    }
    // just error enum.
    convenience init(netError: NetworkError) {
        self.init(userMessage: "", message: "", netError: netError)
        self.netError = netError
    }
}

