//
//  Request.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class Request: NSObject {
    var parameters = [String:Any]()
    var urlPath : String!
    
    func getParams() -> Dictionary<String, Any> {
        return self.parameters
    }
    
    func urlPathWithVersion() -> String {
        if v2APIUrls.index(of: urlPath) == Int.max {
            return v1+urlPath
        } else {
            return v2+urlPath
        }
    }
    
}
