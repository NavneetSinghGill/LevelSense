//
//  LoginInterface.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class LoginInterface: Interface {

    //MARK: Perfrom API methods
    
    func performLoginWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Login response: \(String(describing: response))")
            if success {
                self.parseLoginReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func performLogoutWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Logout response: \(String(describing: response))")
            if success {
                self.parseLogoutReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    //MARK: Parsing methods
    
    func parseLoginReponse(response : Dictionary<String, Any>) {
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
    func parseLogoutReponse(response : Dictionary<String, Any>) {
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
