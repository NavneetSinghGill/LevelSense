//
//  ServiceProvider.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/29/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ServiceProvider: NSObject {
    
    var name: String!
    var id: String!
    var code: String!
    var status: Bool!
    
    override init() {
        super.init()
        
    }
    
    init(name: String, id: String, code: String, status: Bool) {
        self.name = name
        self.id = id
        self.code = code
        self.status = status
    }
    
    func copy(with zone: NSZone? = nil) -> ServiceProvider {
        let copy: ServiceProvider = ServiceProvider.init(name: name,
                                         id: id,
                                         code: code,
                                         status: status)
        return copy
    }
    
//    init(serviceProviderJson: Dictionary<String, Any>) {
//        let serviceProvider = ServiceProvider()
//        serviceProvider.initWithDictionary(dictionary: serviceProviderJson)
//    }
    
    //MARK: Private methods
    
//    private func initWithDictionary(dictionary : Dictionary<String, Any>) {
//        let serviceProvider = dictionary as? Dictionary<String, Any>
//        
//        name = serviceProvider?["name"] as? String
//        id = serviceProvider?["id"] as? String
//        code = serviceProvider?["code"] as? String
//        status = serviceProvider?["status"] as? Bool
//        
//    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["name"] = name
        dict["id"] = id
        dict["code"] = code
        dict["status"] = status
        
        return dict
    }
    
    class func getServiceProviderFromDictionaryArray(serviceProviderDictionaries:NSArray) -> [ServiceProvider] {
        var serviceProviders = [ServiceProvider]()
        for serviceProviderDict in serviceProviderDictionaries {
            let serviceProvider = ServiceProvider.initWithDictionary(dictionary: serviceProviderDict as! Dictionary<String, Any>)
            serviceProviders.append(serviceProvider)
        }
        
        return serviceProviders
    }
    
    class func initWithDictionary(dictionary: Dictionary<String, Any>!) -> ServiceProvider {
        let serviceProvider = ServiceProvider()
        
        if dictionary!["id"] != nil {
            serviceProvider.id = dictionary!["id"] as! String
        } else {
            serviceProvider.id = ""
        }
        
        if dictionary!["name"] != nil {
            serviceProvider.name = dictionary!["name"]! as! String
        } else {
            serviceProvider.name = ""
        }
        
        if dictionary!["code"] != nil {
            serviceProvider.code = dictionary!["code"]! as! String
        } else {
            serviceProvider.code = ""
        }
        
        if dictionary!["status"] != nil {
            serviceProvider.status = dictionary!["status"] as? Bool
        } else {
            serviceProvider.status = false
        }
        
        return serviceProvider
        
    }
}
