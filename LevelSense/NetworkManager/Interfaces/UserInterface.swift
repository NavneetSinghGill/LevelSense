//
//  UserInterface.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class UserInterface: Interface {

    //MARK:- Perfrom API methods
    //MARK: User
    func getUserWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get User response: \(String(describing: response))")
            if success {
                self.parseGetUserReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postEditUserWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Edit User response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func getCountryListWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get CountryList response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func getStateListWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get StateList response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    //MARK: Device
    
    func getDevicesWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get devices response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postClaimDeviceWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Claim device response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postRegisterDeviceWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Register device response: \(String(describing: response))")
            if success {
                self.parseRegisterDeviceReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postGetDeviceDeviceWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get device response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postEditDeviceDeviceWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Edit device response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func getAlarmConfigWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get Alarm config response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    //MARK: Graph
    
    func postGetDeviceDataListWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get device data response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    //MARK:- Parsing methods
    
    func parseGetUserReponse(response : Dictionary<String, Any>) {
        if response.keys.count != 0 || response["success"] != nil{
            let success = response["success"] as! Bool
            if success {
                let user = User.init(userJson: response)
                self.interfaceBlock!(success, user, nil)
            } else {
                let message = response["message"] ?? kErrorOccured
                self.interfaceBlock!(success, message, nil)
                Banner.showFailureWithTitle(title: message as! String)
            }
        } else {
            self.interfaceBlock!(false, kErrorOccured, nil)
            Banner.showFailureWithTitle(title: kErrorOccured)
        }
    }
    
    func parseGeneralReponse(response : Dictionary<String, Any>) {
        if response.keys.count != 0 || response["success"] != nil{
            let success = response["success"] as! Bool
            if success {
                self.interfaceBlock!(success, response, nil)
            } else {
                let message = response["message"] ?? kErrorOccured
                self.interfaceBlock!(success, message, nil)
                Banner.showFailureWithTitle(title: message as! String)
            }
        } else {
            self.interfaceBlock!(false, kErrorOccured, nil)
            Banner.showFailureWithTitle(title: kErrorOccured)
        }
    }
    
    func parseRegisterDeviceReponse(response : Dictionary<String, Any>) {
//        if response.keys.count != 0 || response["success"] != nil{
//            let success = response["success"] as! Bool
//            if success {
                self.interfaceBlock!(true, response, nil)
//            } else {
//                let message = response["message"] ?? kErrorOccured
//                self.interfaceBlock!(success, message, nil)
//            }
//        } else {
//            self.interfaceBlock!(false, kErrorOccured, nil)
//        }
    }
    
}
