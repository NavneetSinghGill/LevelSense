//
//  Banner.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/21/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class Banner {
    
    class func showSuccessWithTitle(title:String) {
        let banner = NotificationBanner(title: title, subtitle: "", style: .success)
        banner.show()
    }
    
    class func showFailureWithTitle(title:String) {
        let banner = NotificationBanner(title: title, subtitle: "", style: .danger)
        banner.show()
    }
    
}
