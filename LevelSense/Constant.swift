//
//  Constant.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let appDelegate = UIApplication.shared.delegate as! AppDelegate

public typealias requestCompletionBlock = (_ success: Bool, _ response: Any?, _ error: Error?) -> Void

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let textMessage = "Text message"
let email = "Email"
let voice = "Voice"
let notificationOptionTypes: NSArray = [email, textMessage, voice]

//MARK: Colors
let drakBlueColor = UIColor.init(colorLiteralRed: 0, green: 74/255.0, blue: 128/255, alpha: 1.0)
let blueColor = UIColor.init(colorLiteralRed: 0, green: 110/255.0, blue: 190/255, alpha: 1.0)
let veryLightblueColor = UIColor.init(colorLiteralRed: 230/255.0, green: 240/255.0, blue: 1, alpha: 1.0)
let myDevicesCellBackgroundSelectionColor = UIColor.init(colorLiteralRed: 230/255.0, green: 240/255.0, blue: 1.0, alpha: 1.0)
let onlineGreen = UIColor.init(colorLiteralRed: 0, green: 200/255.0, blue: 0, alpha: 1.0)
let offlineRed = UIColor.init(colorLiteralRed: 200/255.0, green: 0, blue: 0, alpha: 1.0)

//MARK: Animation durations

let kMyDevicesAnimationDuration = 0.3

//MARK: Parameters

let kEmail = "email"
let kPassword = "password"
let kAccessToken = "access_token"
let kAuthorization = "Authorization"

let kSessionKey = "sessionKey"

//MARK: Api URLs
let kSuperBaseUrl = "https://dash.level-sense.com"
//let kBaseUrl = "\(kSuperBaseUrl)/Level-Sense-API/web/app_dev.php/api/" //Staging
let kBaseUrl = "\(kSuperBaseUrl)/Level-Sense-API/web/api/" //Production
let v1 = "v1/"
let v2 = "v2/"

let v2APIUrls: NSArray = [kGetDeviceDataListApiUrlSuffix, kGetDeviceApiUrlSuffix, getAlarmConfigApiUrlSuffix]

let kLoginApiUrl = "login"
let kLogoutApiUrl = "logout"
let kGetDevices = "getDeviceList"
let kGetUser = "getUser"
let kEditUser = "editUser"
let kGetCountryListApiUrlSuffix = "getCountryList"
let kGetStateListApiUrlSuffix = "getStateList"
let kClaimDeviceApiUrlSuffix = "claimDevice"
let kRegisterDeviceApiUrlSuffix = "registerDevice"
let kGetDeviceApiUrlSuffix = "getDevice"
let kGetDeviceDataListApiUrlSuffix = "getDeviceDataList"
let kPostEditApiUrlSuffix = "editDevice"
let getAlarmConfigApiUrlSuffix = "getAlarmConfig"
let deleteDeviceApiUrlSuffix = "deleteDevice"
let getAddSampleDeviceLogs = "addSampleDeviceLogs"
let getDeviceLogListApiUrlSuffix = "getDeviceLogList"

let kGetContactListApiUrlSuffix = "getContactList"
let kAddContactApiUrlSuffix = "addContact"
let kEditContactApiUrlSuffix = "editContact"
let kDeleteContactApiUrlSuffix = "deleteContact"
let kCellProviderListApiUrlSuffix = "getCellProviderList"
let kTestMailApiUrlSuffix = "testMail"
let kTestSmsApiUrlSuffix = "testSms"


//MARK: Segue identifiers

let kMyDeviceSegueIdentifier = "kMyDeviceSegueIdentifier"
let kClaimDeviceSegueIdentifier = "kClaimDeviceSegueIdentifier"
let kNotificationsSegueIdentifier = "kNotificationsSegueIdentifier"
let kPersonalInfoSegueIdentifier = "kPersonalInfoSegueIdentifier"

//MARK: Constant sentences
let kErrorOccured = "An error occured while processing your request."
let kNoNetwork = "No network available"

//MARK: Local notifications key
let LNRefreshUser = "LNRefreshUser"

//MARK: Enums

enum CheckInFailCount {
    case Online
    case Offline
}

enum DeviceState {
    case Normal
    case Alarm
}

