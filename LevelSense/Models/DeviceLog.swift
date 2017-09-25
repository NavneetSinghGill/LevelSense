//
//  DeviceLog.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class DeviceLog: NSObject {
    
    var deviceID: String?
    var event: String?
    var eventTime: String?
    var id: String?
    var logType: String?
    var message: String?
    var to: String?
    
    override init() {
        super.init()
        
    }
    
    init(deviceID: String?, event: String?, eventTime: String?, id: String?, logType: String?, message: String?, to: String?) {
        self.deviceID = deviceID
        self.event = event
        self.eventTime = eventTime
        self.id = id
        self.logType = logType
        self.message = message
        self.to = to
    }
    
    func copy(with zone: NSZone? = nil) -> DeviceLog {
        let copy: DeviceLog = DeviceLog.init(deviceID: deviceID, event: event, eventTime: eventTime, id: id, logType: logType, message: message, to: to)
        return copy
    }
    
    //    init(serviceProviderJson: Dictionary<String, Any>) {
    //        let serviceProvider = ServiceProvider()
    //        serviceProvider.initWithDictionary(dictionary: serviceProviderJson)
    //    }
    
    //MARK: Private methods
    
    //    private func initWithDictionary(dictionary : Dictionary<String, Any>) {
    //        let serviceProvider = dictionary as? Dictionary<String, Any>
    //
    //        name = serviceProvider?["provider"] as? String
    //        id = serviceProvider?["id"] as? String
    //        code = serviceProvider?["providerCode"] as? String
    //        status = serviceProvider?["providerStatus"] as? Bool
    //
    //    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["deviceID"] = deviceID
        dict["event"] = event
        dict["eventTime"] = eventTime
        dict["id"] = id
        dict["logType"] = logType
        dict["message"] = message
        dict["to"] = to
        
        return dict
    }
    
    class func getDeviceLogFromDictionaryArray(deviceLogDictionaries:NSArray) -> [DeviceLog] {
        var deviceLogs = [DeviceLog]()
        for deviceLogDict in deviceLogDictionaries {
            let deviceLog = DeviceLog.initWithDictionary(dictionary: deviceLogDict as! Dictionary<String, Any>)
            deviceLogs.append(deviceLog)
        }
        
        return deviceLogs
    }
    
    class func initWithDictionary(dictionary: Dictionary<String, Any>!) -> DeviceLog {
        let deviceLog = DeviceLog()
        
        if dictionary!["deviceID"] != nil {
            deviceLog.deviceID = dictionary!["deviceID"] as? String
        } else {
            deviceLog.deviceID = ""
        }
        
        if dictionary!["event"] != nil {
            deviceLog.event = dictionary!["event"] as? String
        } else {
            deviceLog.event = ""
        }
        
        if dictionary!["eventTime"] != nil {
            deviceLog.eventTime = dictionary!["eventTime"] as? String
        } else {
            deviceLog.eventTime = ""
        }
        
        if dictionary!["id"] != nil {
            deviceLog.id = dictionary!["id"] as? String
        } else {
            deviceLog.id = ""
        }
        
        if dictionary!["logType"] != nil {
            deviceLog.logType = dictionary!["logType"] as? String
        } else {
            deviceLog.logType = ""
        }
        
        if dictionary!["message"] != nil {
            deviceLog.message = dictionary!["message"] as? String
        } else {
            deviceLog.message = ""
        }
        
        if dictionary!["to"] != nil {
            deviceLog.to = dictionary!["to"] as? String
        } else {
            deviceLog.to = ""
        }
        
        return deviceLog
    }
    
}
