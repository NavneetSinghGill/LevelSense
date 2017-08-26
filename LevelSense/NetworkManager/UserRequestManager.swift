//
//  UserRequestManager.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class UserRequestManager: NSObject {
    
    //MARK: User
    
    static func getUserAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().getUserWith(request: UserRequest().createGetUserRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    static func postEditUserAPICallWith(user: User, block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().postEditUserWith(request: UserRequest().createEditUserRequestWith(user: user), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
    static func getCountryListAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().getCountryListWith(request: UserRequest().createGetCountryListRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
    static func getStateListAPICallWith(countryID: Int,block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().getStateListWith(request: UserRequest().createGetStateListRequestWith(countryID: countryID), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
    //MARK: Device
    
    static func getDevicesAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().getDevicesWith(request: UserRequest().createGetDevicesRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
    static func postClaimDeviceAPICallWith(codes: NSArray,block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            UserInterface().postClaimDeviceWith(request: UserRequest().createPostClaimDeviceRequestWith(codes: codes), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
}
