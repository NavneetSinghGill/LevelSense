//
//  Contact.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/28/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class Contact: NSObject {

    var firstName: String!
    var contactID: String!
    var email: String!
    var emailActive: Bool!
    var mobile: String!
    var cellProvider: String!
    var smsActive: Bool!
    var defaultStatus: Bool!
    var lastName: String!
    
    override init() {
        super.init()
        
    }
    
    init(firstName: String, contactID: String, email: String, emailActive: Bool, mobile: String, cellProvider: String, smsActive: Bool, defaultStatus: Bool, lastName: String) {
        self.firstName = firstName
        self.contactID = contactID
        self.email = email
        self.emailActive = emailActive
        self.mobile = mobile
        self.cellProvider = cellProvider
        self.smsActive = smsActive
        self.defaultStatus = defaultStatus
        self.lastName = lastName
    }
    
    func copy(with zone: NSZone? = nil) -> Contact {
        let copy: Contact = Contact.init(firstName: firstName,
                                contactID: contactID,
                                email: email,
                                emailActive: emailActive,
                                mobile: mobile,
                                cellProvider: cellProvider,
                                smsActive: smsActive,
                                defaultStatus: defaultStatus,
                                lastName: lastName)
        return copy
    }
    
    init(contactJson: Dictionary<String, Any>) {
        let contact = Contact()
        contact.initWithDictionary(dictionary: contactJson)
    }
    
    //MARK: Private methods
    
    private func initWithDictionary(dictionary : Dictionary<String, Any>) {
        let contact = dictionary as? Dictionary<String, Any>
        
        contactID = contact?["id"] as? String
        firstName = contact?["firstName"] as? String
        lastName = contact?["lastName"] as? String
        email = contact?["email"] as? String
        emailActive = contact?["emailActive"] as? Bool
        mobile = contact?["mobile"] as? String
        cellProvider = contact?["cellProvider"] as? String
        smsActive = contact?["smsActive"] as? Bool
        defaultStatus = contact?["defaultStatus"] as? Bool
        
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["id"] = contactID
        dict["firstName"] = firstName
        dict["lastName"] = lastName
        dict["email"] = email
        dict["emailActive"] = emailActive
        dict["mobile"] = mobile
        dict["cellProvider"] = cellProvider
        dict["smsActive"] = smsActive
        dict["defaultStatus"] = defaultStatus
        
        return dict
    }
    
    class func getContactFromDictionaryArray(contactDictionaries:NSArray) -> [Contact] {
        var contacts = [Contact]()
        for contactDict in contactDictionaries {
            let contact = Contact.initWithDictionary(dictionary: contactDict as! Dictionary<String, Any>)
            contacts.append(contact)
        }
        
        return contacts
    }
    
    class func initWithDictionary(dictionary: Dictionary<String, Any>!) -> Contact {
        let contact = Contact()
        
        if dictionary!["id"] != nil {
            contact.contactID = dictionary!["id"] as! String
        }
        if dictionary!["firstName"] != nil {
            contact.firstName = dictionary!["firstName"]! as! String
        }
        if dictionary!["lastName"] != nil {
            contact.lastName = dictionary!["lastName"]! as! String
        }
        if dictionary!["email"] != nil {
            contact.email = dictionary!["email"]! as! String
        }
        if dictionary!["emailActive"] != nil {
            contact.emailActive = dictionary!["emailActive"] as? Bool
        }
        if dictionary!["mobile"] != nil {
            contact.mobile = dictionary!["mobile"]! as! String
        }
        if dictionary!["cellProvider"] != nil {
            contact.cellProvider = dictionary!["cellProvider"]! as! String
        }
        if dictionary!["smsActive"] != nil {
            contact.smsActive = dictionary!["smsActive"] as? Bool
        }
        if dictionary!["defaultStatus"] != nil {
            contact.defaultStatus = dictionary!["defaultStatus"] as? Bool
        }
        
        return contact
        
    }
    
}
