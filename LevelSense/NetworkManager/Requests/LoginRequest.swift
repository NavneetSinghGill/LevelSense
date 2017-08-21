//
//  LoginRequest.swift
//  LevelSense
//
//  Created by BestPeers on 11/08/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class LoginRequest: Request {

    func createLoginRequestWith(email:String, password:String) -> LoginRequest {
        
        parameters[kEmail] = email
        parameters[kPassword] = password
        
        self.urlPath = kLoginApiUrl
        return self
    }
    
}
