//
//  RealAPI.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class RealAPI: NSObject {

    public func performGetAPICallWith(request:Request, completionBlock:@escaping requestCompletionBlock) {
        
        let requestUrl = request.urlPathWithVersion()
        let params = request.getParams()
        printAPIDetails(url: requestUrl, params: params)
        
        NetworkHttpClient.performGetAPICallWith(url: requestUrl, withParams: params, block: completionBlock)
    }
    
    
    public func performPostAPICallWith(request:Request, completionBlock:@escaping requestCompletionBlock) {
        
        let requestUrl = request.urlPathWithVersion()
        let params = request.getParams()
        printAPIDetails(url: requestUrl, params: params)
        
        NetworkHttpClient.performPostAPICallWith(url: requestUrl, params: params, block: completionBlock)
    }
    
    func printAPIDetails(url: String, params: Dictionary<String, Any>) {
        NSLog("\n\n URL:[\(kBaseUrl)\(url)] \nParams: \n \(params)")
    }
    
}
