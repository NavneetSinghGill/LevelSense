//
//  extensions.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/21/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension UIView {
    @IBInspectable var borderWidth : CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor : CGColor {
        set {
            layer.borderColor = newValue
        }
        
        get {
            return layer.borderColor!
        }
    }
}
