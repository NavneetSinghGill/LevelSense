//
//  NetworkHttpClient.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit
import Alamofire

class NetworkHttpClient: NSObject {

    class func performGetAPICallWith(url:String, withParams params:Dictionary<String,Any>, block:@escaping requestCompletionBlock) {
        
        let header : HTTPHeaders = NetworkHttpClient.getHeader() as! HTTPHeaders
        let apiurl = NetworkHttpClient.getBaseUrl() + url
        
        Alamofire.request(apiurl, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON  { response in
            
            guard response.result.isSuccess else {
                block(false, response.result.error!.localizedDescription, nil)
                Banner.showFailureWithTitle(title: response.result.error!.localizedDescription)
                return
            }
            
            guard  let responseValue = response.result.value else {
                block (false, "error", nil)
                return
            }
            
            performActionsFor(response: responseValue)
            block(true, responseValue, nil)
        }
    }
    
    class func performPostAPICallWith(url:String, params:Dictionary<String,Any>, block:@escaping requestCompletionBlock) {
        
        let header : HTTPHeaders = NetworkHttpClient.getHeader() as! HTTPHeaders
        let apiurl = NetworkHttpClient.getBaseUrl() + url
        
        Alamofire.request(((NSURL.init(string: apiurl))! as URL) , method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            guard response.result.isSuccess else {
                block(false, response.result.error!.localizedDescription, nil)
                Banner.showFailureWithTitle(title: response.result.error!.localizedDescription)
                return
            }
            
            guard let responseValue = response.result.value else {
                block (false, "error", nil)
                return
            }
            
            performActionsFor(response: responseValue)
            block(true, responseValue, nil)
        }
    }
    
    // MARK: - Private Methods
    class func getBaseUrl() -> String {
        return kBaseUrl;
    }
    
    class func getHeader() -> Dictionary<String, Any> {
        var header: HTTPHeaders = [String : String]()
        if UserDefaults.standard.value(forKey: kSessionKey) != nil {
            header[kSessionKey] = UserDefaults.standard.value(forKey: kSessionKey) as? String
        }
        NSLog("Header: \(header)")
        return header
    }
    
    class func performActionsFor(response: Any) {
        if (response as? Dictionary<String,Any>) != nil && (response as? Dictionary<String,Any>)?["message"] != nil {
            let message = (response as? Dictionary<String,Any>)?["message"] as! String
            if message == "Please provide session key" {
                appDelegate.logout()
            }
        }
    }
     
}
