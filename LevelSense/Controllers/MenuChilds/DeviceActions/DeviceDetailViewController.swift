//
//  DeviceDetailViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/15/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class DeviceDetailViewController: LSViewController, SelectedOptionProtocol {
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var reportTextField: UITextField!
    @IBOutlet weak var firmwareTextField: UITextField!
    @IBOutlet weak var subscriptionTextField: UITextField!
    @IBOutlet weak var macAddressTextField: UITextField!
    @IBOutlet weak var lastCheckinTextField: UITextField!
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var stateOfSirenLabel: UILabel!
    
    var deviceDetail: Dictionary<String,Any>!
    var checkinIntervals: Array<Dictionary<String,Any>>!
    var updateIntervals: Array<Dictionary<String,Any>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "Device Detail")
        
        updateUIWithDetails()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func statusButtonTapped(sender: UIButton) {
        
//        self.getOptionVCWith(content: <#T##NSArray#>, startIndex: <#T##Int?#>, sender: <#T##Any?#>)
    }
    
    @IBAction func reportButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
    }
    
    //MARK:- Private methods
    
    func updateUIWithDetails() {
        if deviceDetail != nil {
            self.deviceNameTextField.text = deviceDetail["displayName"] as? String
            
            checkinIntervals = (deviceDetail["deviceConfigMeta"] as? Dictionary<String,Array<Dictionary<String,Any>>>)!["checkin_interval"]!
            updateIntervals = (deviceDetail["deviceConfigMeta"] as? Dictionary<String,Array<Dictionary<String,Any>>>)!["update_interval"]!
            
            let deviceConfig: Array<Dictionary<String, Any>> = deviceDetail["deviceConfig"] as! Array<Dictionary<String, Any>>
            for dict in deviceConfig {
                if dict["configKey"] as? String == "update_interval" {
                    for updateIntervalDict in updateIntervals {
                        if updateIntervalDict["value"] as? Int == Int(dict["configVal"] as! String) {
                            self.statusTextField.text = updateIntervalDict["label"] as? String
                        }
                    }
                } else if dict["configKey"] as? String == "checkin_interval" {
                    for checkIntervalDict in checkinIntervals {
                        if checkIntervalDict["value"] as? Int == Int(dict["configVal"] as! String) {
                            self.reportTextField.text = checkIntervalDict["label"] as? String
                        }
                    }
                }
            }
            
            self.firmwareTextField.text = deviceDetail["deviceFirmware"] as? String
            self.subscriptionTextField.text = deviceDetail[""] as? String
            self.macAddressTextField.text = deviceDetail["mac"] as? String
            
            if let lastCheckinTime = deviceDetail["lastCheckinTime"] as? Dictionary<String,Any> {
                self.lastCheckinTextField.text = lastCheckinTime["date"] as? String
            }
            
            if let sirenState = deviceDetail["sirenState"] as? Bool {
                self.stateOfSirenLabel.text = sirenState ? "On" : "Off"
            }
        }
    }
    
    //MARK:- Notification methods
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.scrollViewBottomConstraint.constant = keyboardSize.size.height + 10
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollViewBottomConstraint.constant = 0
        }
    }
    
    //MARK:- Textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = view.viewWithTag(textField.tag + 1)
        if nextField != nil {
            nextField?.becomeFirstResponder()
            scrollView.scrollRectToVisible((nextField?.frame)!, animated: true)
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }

}
