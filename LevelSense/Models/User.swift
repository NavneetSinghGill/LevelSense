//
//  User.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 12/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import Foundation

class User : NSObject {
    static var user: User!
    
    var address: String!
    var city: String!
    var firstName: String!
    var userID: String!
    var country: String!
    var zipcode: String!
    var status: String!
    var email: String!
    var state: String!
    var lastName: String!
    var userStatus: String!
    
    
    override init() {
        super.init()
        
    }
    
    init(userJson: Dictionary<String, Any>) {
        let user = User()
        user.initWithDictionary(dictionary: userJson)
        
        //Set final user
        User.user = user
        user.saveUser()
    }
    
    //MARK: Class methods
    
    static func handleLoginResponse(loginResponse: Dictionary<String, Any>) {
        
        UserDefaults.standard.synchronize()
    }

    //MARK: Private methods
    
    private func initWithDictionary(dictionary : Dictionary<String, Any>) {
        let user = dictionary["user"] as? Dictionary<String, Any>
        
        address = user?["address"] as? String
        city = user?["city"] as? String
        firstName = user?["firstName"] as? String
        lastName = user?["lastName"] as? String
        userID = user?["id"] as? String
        country = user?["country"] as? String
        state = user?["state"] as? String
        zipcode = user?["zipcode"] as? String
        email = user?["email"] as? String
        userStatus = user?["userStatus"] as? String
        
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["address"] = address
        dict["city"] = city
        dict["firstName"] = firstName
        dict["id"] = userID
        dict["country"] = country
        dict["state"] = state
        dict["zipcode"] = zipcode
        dict["email"] = email
        dict["userStatus"] = userStatus
        
        return dict
    }
    
    func saveUser() {
        UserDefaults.standard.setValue(address, forKey: "address")
        UserDefaults.standard.setValue(city, forKey: "city")
        UserDefaults.standard.setValue(firstName, forKey: "firstName")
        UserDefaults.standard.setValue(lastName, forKey: "lastName")
        UserDefaults.standard.setValue(userID, forKey: "userID")
        UserDefaults.standard.setValue(country, forKey: "country")
        UserDefaults.standard.setValue(zipcode, forKey: "zipcode")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(state, forKey: "state")
        UserDefaults.standard.setValue(userStatus, forKey: "userStatus")
        UserDefaults.standard.synchronize()
        
        User.user = self
    }
    
    class func setUserFromDefaults() {
        let user = User()
        user.address = UserDefaults.standard.value(forKey: "address") as? String
        user.city = UserDefaults.standard.value(forKey: "city") as? String
        user.firstName = UserDefaults.standard.value(forKey: "firstName") as? String
        user.lastName = UserDefaults.standard.value(forKey: "lastName") as? String
        user.userID = UserDefaults.standard.value(forKey: "userID") as? String
        user.country = UserDefaults.standard.value(forKey: "country") as? String
        user.zipcode = UserDefaults.standard.value(forKey: "zipcode") as? String
        user.email = UserDefaults.standard.value(forKey: "email") as? String
        user.state = UserDefaults.standard.value(forKey: "state") as? String
        user.userStatus = UserDefaults.standard.value(forKey: "userStatus") as? String
        
        User.user = user
    }
    
    class func deleteUser() {
        UserDefaults.standard.removeObject(forKey: "address")
        UserDefaults.standard.removeObject(forKey: "city")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "country")
        UserDefaults.standard.removeObject(forKey: "zipcode")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "state")
        UserDefaults.standard.removeObject(forKey: "userStatus")
        UserDefaults.standard.synchronize()
        
        User.user = nil
    }
    
}
