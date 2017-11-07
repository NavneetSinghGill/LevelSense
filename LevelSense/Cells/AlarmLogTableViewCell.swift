//
//  AlarmLogTableViewCell.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class AlarmLogTableViewCell: UITableViewCell {
    
    let defaultValue = "----"
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var logTypeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUIFor(deviceLog: DeviceLog) {
        if deviceLog.event != nil && deviceLog.event?.characters.count != 0 {
            eventLabel.text = deviceLog.event
        } else {
            eventLabel.text = defaultValue
        }
        
        if deviceLog.eventTime != nil && deviceLog.eventTime?.characters.count != 0 {
            eventTimeLabel.text = deviceLog.eventTime
        } else {
            eventTimeLabel.text = defaultValue
        }
        
        if deviceLog.logType != nil && deviceLog.logType?.characters.count != 0{
            logTypeLabel.text = deviceLog.logType
        } else {
            logTypeLabel.text = defaultValue
        }
        
        if deviceLog.message != nil && deviceLog.message?.characters.count != 0 {
            messageLabel.text = deviceLog.message
        } else {
            messageLabel.text = defaultValue
        }
        
        if deviceLog.to != nil && deviceLog.to?.characters.count != 0 {
            toLabel.text = deviceLog.to
        } else {
            toLabel.text = defaultValue
        }
    }
    
}
