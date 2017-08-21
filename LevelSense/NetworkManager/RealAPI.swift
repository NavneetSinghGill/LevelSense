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
        
        let requestUrl = request.urlPath!
        NetworkHttpClient.performGetAPICallWith(url: requestUrl, withParams: request.getParams(), block: completionBlock)
    }
    
    
    public func performPostAPICallWith(request:Request, completionBlock:@escaping requestCompletionBlock) {
        
        let requestUrl = request.urlPath!
        let params = request.getParams()
        
        NetworkHttpClient.performPostAPICallWith(url: requestUrl, params: params, block: completionBlock)
    }
    
}
