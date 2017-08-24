//
//  UserRequest.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class UserRequest: Request {
    
    func createGetUserRequestWith() -> UserRequest {
        
        self.urlPath = kGetUser
        return self
    }
    
    func createEditUserRequestWith(user: User) -> UserRequest {
        
        self.parameters = user.toDictionary()
            
        self.urlPath = kEditUser
        return self
    }
    
    func createGetDevicesRequestWith() -> UserRequest {
        
        self.urlPath = kGetDevices
        return self
    }
    
}
