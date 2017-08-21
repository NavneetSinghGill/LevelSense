//
//  extensions.swift
//  LevelSense
//
//  Created by Navneet on 8/21/17.
//  Copyright © 2017 Navneet Singh. All rights reserved.
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
