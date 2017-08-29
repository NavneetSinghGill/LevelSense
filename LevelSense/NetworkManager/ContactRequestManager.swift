//
//  ContactRequestManager.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/28/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ContactRequestManager: NSObject {

    
    static func getContactListAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            ContactInterface().getContactListWith(request: ContactRequest().createGetContactListRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    static func postAddContactAPICallWith(contact: Contact, block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            ContactInterface().postAddContactWith(request: ContactRequest().createAddContactRequestWith(contact: contact), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    static func postEditContactAPICallWith(contact: Contact, block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            ContactInterface().postEditContactWith(request: ContactRequest().createEditContactRequestWith(contact: contact), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    static func postDeleteContactAPICallWith(contact: Contact, block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            ContactInterface().postDeleteContactWith(request: ContactRequest().createDeleteContactRequestWith(contact: contact), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    static func getCellProviderListAPICallWith(block:@escaping requestCompletionBlock)
    {
        if appDelegate.isNetworkAvailable {
            ContactInterface().getCellProviderListWith(request: ContactRequest().createGetCellProviderListRequestWith(), withCompletionBlock: block)
            
        } else{
            Banner.showSuccessWithTitle(title: kNoNetwork)
            block(false, kNoNetwork, nil)
        }
        
    }
    
}
