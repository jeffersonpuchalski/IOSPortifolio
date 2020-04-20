//
//  LoginViewModel.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit

class LoginViewModel {
    private (set) var webService: NetworkLayer!
    private var keyChainManager = KeychainManager()
    private var modelRepos = UserResponse()
    
    // Save keys for login
    func login(user: String, password: String){
        
        if keyChainManager.save(user, forKey: "user") != true {
            fatalError("We need save a key")
        }
        if keyChainManager.save(password, forKey: "password") != true{
            fatalError("We need save a key")
        }
    }
}
