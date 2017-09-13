//
//  MyDevicesTableViewCell.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class MyDevicesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var onlineOfflineLabel: UILabel!
    
    @IBOutlet weak var selectionView: UIView!
    
    var device: Device!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public methods
    
    func updateUIfor(device: Device) {
        self.device = device
        self.deviceNameLabel.text = device.displayName
        
        let biggerFont: Dictionary = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 13.0)! ]
        let redColor: Dictionary = [ NSForegroundColorAttributeName: offlineRed]
        let greenColor: Dictionary = [ NSForegroundColorAttributeName: onlineGreen]
        
        if device.deviceState == DeviceState.Normal {
            let str = "STATUS: NORMAL"
            let smallerFont: Dictionary = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 11.0)! ]
            let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
            
            attString.addAttributes(biggerFont, range: NSMakeRange(0, str.characters.count))
            attString.addAttributes(smallerFont, range: NSMakeRange(0, "STATUS: ".characters.count))
            
            stateLabel.attributedText = attString
        } else {
            let str = "STATUS: ALARM"
            let smallerFont: Dictionary = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 11.0)! ]
            let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
            
            attString.addAttributes(biggerFont, range: NSMakeRange(0, str.characters.count))
            attString.addAttributes(smallerFont, range: NSMakeRange(0, "STATUS: ".characters.count))
            attString.addAttributes(redColor, range: NSMakeRange("STATUS: ".characters.count, "ALARM".characters.count))
            
            stateLabel.attributedText = attString
        }
        
        if device.checkinFailCount == CheckInFailCount.Online {
            let str = "ONLINE"
            let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
            attString.addAttributes(greenColor, range: NSMakeRange(0, str.characters.count))
            attString.addAttributes(biggerFont, range: NSMakeRange(0, str.characters.count))
            
            onlineOfflineLabel.attributedText = attString
            
        } else {
            let str = "OFFLINE"
            let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
            attString.addAttributes(redColor, range: NSMakeRange(0, str.characters.count))
            attString.addAttributes(biggerFont, range: NSMakeRange(0, str.characters.count))
            
            onlineOfflineLabel.attributedText = attString
        }
    }
    
    func changeViewIf(isSelected:Bool, withAnimation:Bool) {
        if withAnimation {
            if isSelected {
                UIView.animate(withDuration: kMyDevicesAnimationDuration, animations: {
                    self.selectionView.layer.backgroundColor = myDevicesCellBackgroundSelectionColor.cgColor
                })
            } else {
                UIView.animate(withDuration: kMyDevicesAnimationDuration, animations: {
                    self.selectionView.layer.backgroundColor = UIColor.white.cgColor
                })
            }
        } else {
            if isSelected {
                self.selectionView.layer.backgroundColor = myDevicesCellBackgroundSelectionColor.cgColor
            } else {
                self.selectionView.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
}
