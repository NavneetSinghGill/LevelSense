//
//  ContactRequest.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/28/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ContactRequest: Request {
    
    func createGetContactListRequestWith() -> ContactRequest {
        
        self.urlPath = kGetContactListApiUrlSuffix
        return self
    }
    
    func createAddContactRequestWith(contact: Contact) -> ContactRequest {
        parameters = contact.toDictionary()
        
        self.urlPath = kAddContactApiUrlSuffix
        return self
    }
    
    func createEditContactRequestWith(contact: Contact) -> ContactRequest {
        parameters = contact.toDictionary()
        
        self.urlPath = kEditContactApiUrlSuffix
        return self
    }
    
    func createDeleteContactRequestWith(contact: Contact) -> ContactRequest {
        parameters = contact.toDictionary()
        
        self.urlPath = kDeleteContactApiUrlSuffix
        return self
    }
    
    func createGetCellProviderListRequestWith() -> ContactRequest {
        
        self.urlPath = kCellProviderListApiUrlSuffix
        return self
    }
    
}
