//
//  UserInterface.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class UserInterface: Interface {

    //MARK: Perfrom API methods
    
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
                self.parsePostEditUserReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func getDevicesWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get devices response: \(String(describing: response))")
            if success {
                self.parseGetDevicesReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    //MARK: Parsing methods
    
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
    
    func parsePostEditUserReponse(response : Dictionary<String, Any>) {
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
    
    func parseGetDevicesReponse(response : Dictionary<String, Any>) {
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
    
}
