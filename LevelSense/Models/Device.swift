//
//  Device.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class Device: NSObject {
    var alarmSent: NSInteger!
    var alarmSilence: NSInteger!
    var capSenseMax: NSInteger!
    var capSenseMinOffset: NSInteger!
    var deviceSerialNumber: String!
    var deviceState: DeviceState!
    var displayName: String!
    var id: String!
    var latitude: CGFloat!
    var longitude: CGFloat!
    var sirenState: NSInteger!
    var checkinFailCount: CheckInFailCount!
    
    enum CheckInFailCount {
        case Online
        case Offline
    }
    
    enum DeviceState {
        case Normal
        case Alarm
    }
    
    class func initWithDictionary(dictionary: Dictionary<String, Any>!) -> Device {
        let device = Device()
        if dictionary!["displayName"] != nil {
            device.displayName = dictionary!["displayName"]! as! String
        }
        if dictionary!["id"] != nil {
            device.id = dictionary!["id"] as! String
        }
        if dictionary!["checkinFailCount"] != nil {
            let count = dictionary!["checkinFailCount"] as! NSInteger
            if count == 0 {
                device.checkinFailCount = CheckInFailCount.Online
            } else {
                device.checkinFailCount = CheckInFailCount.Offline
            }
        } else {
            device.checkinFailCount = CheckInFailCount.Offline
        }
        if dictionary!["deviceState"] != nil {
            let count = dictionary!["deviceState"] as! NSInteger
            if count == 0 {
                device.deviceState = DeviceState.Normal
            } else {
                device.deviceState = DeviceState.Alarm
            }
        } else {
            device.deviceState = DeviceState.Normal
        }
        return device
        
    }
    
    class func getDevicesFromDictionaryArray(deviceDictionaries:NSArray) -> [Device] {
        var devices = [Device]()
        for var deviceDict in deviceDictionaries {
            let device = Device.initWithDictionary(dictionary: deviceDict as! Dictionary<String, Any>)
            devices.append(device)
        }
        
        return devices
    }

}
