//
//  LoginRequestManager.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class LoginRequestManager: NSObject {

    static func postLoginAPICallWith(email:String, password:String, block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            LoginInterface().performLoginWith(request: LoginRequest().createLoginRequestWith(email: email, password: password), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
}
