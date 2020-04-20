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
    func login(user: String, password: String, completion: @escaping (Result<UserResponse?, TechnicalError>) -> Void){
        
        if keyChainManager.save(user, forKey: "user") != true {
            fatalError("We need save a key")
        }
        if keyChainManager.save(password, forKey: "password") != true{
            fatalError("We need save a key")
        }
        let userName: String = keyChainManager.load(forKey: "user")
        let passwordUser: String = keyChainManager.load(forKey: "password")
        
        DispatchQueue.main.async {
            NetworkLayer.shared.request(.getUserInfo(user: userName, password: passwordUser), httpMode: .get, model: UserResponse(), onCompletion: completion)
        }
      
        
    }
    func loadUser() -> [String : String]{
        var result = [String: String]()
        
        let user = keyChainManager.load(forKey: "user")
        let password = keyChainManager.load(forKey: "password")
        
        result["user"] = user
        result["password"] = password
        
        return result
    }
}

extension Endpoint {
    static func getUserInfo(user: String, password: String) -> Endpoint {
        return Endpoint(path: Endpoint.getValue(for: "getUserInfo"), queryItems: [], pathParams: nil, baseURL: Endpoint.getValue(for: "basicUrl"), headers: ["Authorization" : "\(user):\(password)"])
    }
}
