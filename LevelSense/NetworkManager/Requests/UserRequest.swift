//
//  UserRequest.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class UserRequest: Request {
    
    //MARK: User
    
    func createGetUserRequestWith() -> UserRequest {
        
        self.urlPath = kGetUser
        return self
    }
    
    func createEditUserRequestWith(user: User) -> UserRequest {
        
        self.parameters = user.toDictionary()
            
        self.urlPath = kEditUser
        return self
    }
    
    func createGetCountryListRequestWith() -> UserRequest {
        
        self.urlPath = kGetCountryListApiUrlSuffix
        return self
    }
    
    func createGetStateListRequestWith(countryID: Int) -> UserRequest {
        parameters["countryId"] = countryID
        
        self.urlPath = kGetStateListApiUrlSuffix
        return self
    }
    
    //MARK: Device
    
    func createGetDevicesRequestWith() -> UserRequest {
        
        self.urlPath = kGetDevices
        return self
    }
    
    func createPostClaimDeviceRequestWith(codes: NSArray) -> UserRequest {
        
        parameters["codes"] = codes
        
        self.urlPath = kClaimDeviceApiUrlSuffix
        return self
    }
    
    func createPostRegisterDeviceRequestWith() -> UserRequest {
        
        self.urlPath = kRegisterDeviceApiUrlSuffix
        return self
    }
    
    func createPostGetDeviceRequestWith(deviceID: String) -> UserRequest {
        
        parameters["id"] = deviceID
        
        self.urlPath = kGetDeviceApiUrlSuffix
        return self
    }
    
    //MARK: Graph
    
    func createPostGetDeviceDataListRequestWith(deviceID: String, limit: Int, fromTimestamp: Int, toTimestamp: Int) -> UserRequest {
        
        parameters["deviceId"] = deviceID
        parameters["limit"] = limit
        parameters["fromTimestamp"] = fromTimestamp
        parameters["toTimestamp"] = toTimestamp
        
        self.urlPath = kGetDeviceDataListApiUrlSuffix
        return self
    }
    
}
