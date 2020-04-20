//
//  HomeViewModel.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation

class HomeViewModel : NSObject {
    var kwManager = KeychainManager()
    var modelRepo = [RepositoryResponse]()
    
    func getUserRepos(completion: @escaping (Result<[RepositoryResponse]?, TechnicalError>) -> Void){
        
        let user: String = kwManager.load(forKey: "user")
        let password: String = kwManager.load(forKey: "password")
        DispatchQueue.main.async {
            NetworkLayer.shared.request(.getRepos(user: user, password: password), httpMode: .get, model: self.modelRepo.self, onCompletion: completion)
        }
        
    }
    
}

extension Endpoint {
    static func getRepos(user: String, password: String) -> Endpoint {
        return Endpoint(path: Endpoint.getValue(for: "findUserRepos"), queryItems: [], pathParams: [], baseURL: "", headers: ["Authentication" : "Basic \(user) : \(password)"])
    }
}
