//
//  ContactInterface.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/28/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ContactInterface: Interface {
    
    
    func getContactListWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performGetAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Get contacts response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postAddContactWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Add contact response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postEditContactWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Edit contact response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    func postDeleteContactWith(request:Request, withCompletionBlock block:@escaping requestCompletionBlock)
    {
        self.interfaceBlock = block
        RealAPI().performPostAPICallWith(request: request, completionBlock: { success, response, error in
            NSLog("\n \n Delete contact response: \(String(describing: response))")
            if success {
                self.parseGeneralReponse(response: response as! Dictionary<String, Any>)
            } else {
                block(success, response, error)
            }
        })
    }
    
    //MARK:- Parsing methods
    
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
    
}
