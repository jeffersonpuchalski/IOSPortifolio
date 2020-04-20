//
//  UserResponse.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation

struct UserResponse : Codable {
    
    var login : String?
    var avatarUrl: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey{
          case login = "login"
          case avatarUrl = "avatar_url"
          case name = "name"
    }
  
}
/**
 
   enum CodingKeys: String, CodingKey{
       case login = "login"
       case avatarUrl = "avatar_url"
       case name = "name"
   }

   
   init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
       login = try values.decode(String.self, forKey: .login)
       avatarUrl = try values.decode(String.self, forKey: .avatarUrl)
       name = try values.decode(String.self, forKey: .name)
   }
   
   func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(login, forKey: .login)
       try container.encode(avatarUrl, forKey: .avatarUrl)
       try container.encode(name, forKey: .name)
   }
 */
