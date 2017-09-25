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
    
    func postEditDeviceRequestWith(deviceDict: Dictionary<String,Any>) -> UserRequest {
        
        parameters = deviceDict
        
        self.urlPath = kPostEditApiUrlSuffix
        return self
    }
    
    func getAlarmConfigRequestWith(deviceDict: Dictionary<String,Any>) -> UserRequest {
        
        parameters = deviceDict
        
        self.urlPath = getAlarmConfigApiUrlSuffix
        return self
    }
    
    func deleteDeviceRequestWith(deviceID: String) -> UserRequest {
        
        parameters["id"] = deviceID
        
        self.urlPath = deleteDeviceApiUrlSuffix
        return self
    }
    
    func getAlarmLogsRequestWith(deviceDict: Dictionary<String,Any>) -> UserRequest {
        
        parameters = deviceDict
        
        self.urlPath = getDeviceLogListApiUrlSuffix
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
