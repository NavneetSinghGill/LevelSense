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

extension CGFloat {
    
    func rounded(toPlaces places:Int) -> String {
        let divisor: CGFloat = pow(10.0, CGFloat(places))
        return "\((self * divisor).rounded() / divisor)"
    }
}

extension Float {
    
    func rounded(toPlaces places:Int) -> String {
        let divisor: Float = pow(10.0, Float(places))
        return "\((self * divisor).rounded() / divisor)"
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

extension UIButton {
    
    func setBadge(text: String) {
        let textLabelTag = 98765
        var badgeLabel: UILabel?
        
        if Int(text) == 0 {
            self.viewWithTag(textLabelTag)?.removeFromSuperview()
            return
        }
        
        if let label = self.viewWithTag(textLabelTag) as? UILabel {
            label.text = text
            label.sizeToFit()
            badgeLabel = label
        } else {
            badgeLabel = getBadgeLabelWith(text: text)
            badgeLabel?.tag = textLabelTag
            self.addSubview(badgeLabel!)
        }
        //Just to make text more clear
        badgeLabel?.frame.size.height = (badgeLabel?.frame.size.height)! + 3
        
        if badgeLabel!.frame.size.width < badgeLabel!.frame.size.height {
            badgeLabel?.frame.size.width = (badgeLabel?.frame.size.height)!
        }
        badgeLabel?.frame = CGRect(x: self.frame.size.width - (badgeLabel?.frame.size.width)!,
                                   y: 0,
                                   width: (badgeLabel?.frame.size.width)!,
                                   height: (badgeLabel?.frame.size.height)!)
     
        badgeLabel?.layer.cornerRadius = (badgeLabel?.frame.size.height)!/2
    }
    
    func getBadgeLabelWith(text: String) -> UILabel {
        let badgeLabel: UILabel = UILabel()
        badgeLabel.text = text
        badgeLabel.font = UIFont(name: "Helvetica-Medium", size: 9)
        badgeLabel.sizeToFit()
        badgeLabel.backgroundColor = .red
        badgeLabel.textColor = .white
        badgeLabel.layer.cornerRadius = 6
        badgeLabel.borderColor = UIColor.white.cgColor
        badgeLabel.borderWidth = 1
        badgeLabel.layer.masksToBounds = true
        badgeLabel.textAlignment = .center
        
        return badgeLabel
    }
}

extension UITableView {
    func registerNib(withIdentifierAndNibName: String) -> Void {
        let nib = UINib(nibName: withIdentifierAndNibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: withIdentifierAndNibName)
    }
}

extension CALayer {
    func removeSubLayersAndPaths() {
        for i in 0..<(self.sublayers?.count != nil ? (self.sublayers?.count)! : 0) {
            let subLayer = self.sublayers?[i]
            if let shape = subLayer as? CAShapeLayer {
                shape.path = nil
            }
            subLayer?.removeSubLayersAndPaths()
            subLayer?.sublayers?.removeAll()
        }
    }
}

//extension NSObject {
//    func printMe() {
//        let reflected = reflect(self)
//        var members = [String: String]()
//        for index in 0..<reflected.count {
//            members[reflected[index].0] = reflected[index].1.summary
//        }
//        println(members)
//    }
//}
