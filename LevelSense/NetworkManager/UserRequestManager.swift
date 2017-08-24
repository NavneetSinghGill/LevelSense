//
//  UserRequestManager.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class UserRequestManager: NSObject {
    
    static func getUserAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().getUserWith(request: UserRequest().createGetUserRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
    static func getDevicesAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().getDevicesWith(request: UserRequest().createGetDevicesRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
}
