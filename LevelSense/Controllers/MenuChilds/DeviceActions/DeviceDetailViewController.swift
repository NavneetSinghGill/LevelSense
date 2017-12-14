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
    @IBOutlet weak var stateOfRelayLabel: UILabel!
    @IBOutlet weak var wirelessSignalStrengthNumberLabel: UILabel!
    @IBOutlet weak var wirelessSignalStrengthRangeLabel: UILabel!
    
    var deviceDetail: Dictionary<String,Any>!
    var deviceConfig: Array<Dictionary<String, Any>>!
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
        let updateIntervalLabels: NSArray =  (self.updateIntervals as NSArray).value(forKeyPath: "label") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: updateIntervalLabels, startIndex: updateIntervalLabels.index(of: self.statusTextField.text!), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func reportButtonTapped(sender: UIButton) {
        let checkInLabels: NSArray = (self.checkinIntervals as NSArray).value(forKeyPath: "label") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: checkInLabels, startIndex: checkInLabels.index(of: self.reportTextField.text!), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        var apiDict: Dictionary<String, Any> = [:]
        apiDict["id"] = deviceDetail["id"]
        apiDict["displayName"] = deviceDetail["displayName"]
        
        var deviceConfigForApi: Array<Dictionary<String, Any>> = []
        var updateIntervalDict: Dictionary<String, Any> = [:]
        var checkInIntervalDict: Dictionary<String, Any> = [:]
        
        for dict in updateIntervals {
            if dict["label"] as? String == statusTextField.text {
                updateIntervalDict["configKey"] = "update_interval"
                updateIntervalDict["configVal"] = dict["value"]
            }
        }
        
        for dict in checkinIntervals {
            if dict["label"] as? String == reportTextField.text {
                checkInIntervalDict["configKey"] = "update_interval"
                checkInIntervalDict["configVal"] = dict["value"]
            }
        }
        
        for dictConfigDict in deviceConfig {
            if dictConfigDict["configKey"] as? String == "update_interval" {
                updateIntervalDict["id"] = dictConfigDict["id"]
            } else if dictConfigDict["configKey"] as? String == "checkin_interval" {
                checkInIntervalDict["id"] = dictConfigDict["id"]
            }
        }
        
        deviceConfigForApi.append(updateIntervalDict)
        deviceConfigForApi.append(checkInIntervalDict)
        
        apiDict["deviceConfig"] = deviceConfigForApi
        
        
        //Call update api
        startAnimating()
        UserRequestManager.postEditDeviceAPICallWith(deviceDict: apiDict) { (success, response, error) in
            if success {
                Banner.showSuccessWithTitle(title: "Device details updated successfully.")
            }
            self.stopAnimating()
        }
    }
    
    //MARK: - Selection option protocol
    
    func selectedOption(index:NSInteger, sender: Any?){
        if sender as? UIButton == statusButton {
            statusTextField.text = ((updateIntervals as NSArray).object(at: index) as! Dictionary<String,Any>)["label"] as? String
        } else if sender as? UIButton == reportButton {
            reportTextField.text = ((checkinIntervals as NSArray).object(at: index) as! Dictionary<String,Any>)["label"] as? String
        }
    }
    
    //MARK:- Private methods
    
    func updateUIWithDetails() {
        if deviceDetail != nil {
            self.deviceNameTextField.text = deviceDetail["displayName"] as? String
            
            checkinIntervals = (deviceDetail["deviceConfigMeta"] as? Dictionary<String,Array<Dictionary<String,Any>>>)!["checkin_interval"]!
            updateIntervals = (deviceDetail["deviceConfigMeta"] as? Dictionary<String,Array<Dictionary<String,Any>>>)!["update_interval"]!
            
            deviceConfig = deviceDetail["deviceConfig"] as! Array<Dictionary<String, Any>>
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
            self.subscriptionTextField.text = deviceDetail["deviceSubscriptionDate"] as? String
            self.macAddressTextField.text = deviceDetail["mac"] as? String
            
            if let lastCheckinTime = deviceDetail["lastCheckinTime"] as? String {
                self.lastCheckinTextField.text = lastCheckinTime
            }
            
            if let sirenState = deviceDetail["sirenState"] as? Bool {
                self.stateOfSirenLabel.text = sirenState ? "On" : "Off"
            }
            
            if let relayState = deviceDetail["relayState"] as? Bool {
                self.stateOfRelayLabel.text = relayState ? "On" : "Off"
            }
            
            if let deviceData = deviceDetail["deviceData"] as? Array<AnyObject> {
                for device in deviceData {
                    if let validDevice = (device as? Dictionary<String, AnyObject>) {
                        if (validDevice["sensorId"] as? String) == "11" { //RSSI id is 11
                            self.wirelessSignalStrengthNumberLabel.text = validDevice["value"] as? String
                            self.wirelessSignalStrengthRangeLabel.text = self.getSignalStrengthFor(signalValue: Float(validDevice["value"] as! String)!)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func getSignalStrengthFor(signalValue: Float) -> String {
        
        if signalValue >= Float(-50) {
            return "(Excellent)"
        } else if Float(-50) >= signalValue && signalValue > Float(-60) {
            return "(Good)"
        } else if Float(-60) >= signalValue && signalValue > Float(-70) {
            return "(Fair)"
        } else {
            return "(Poor)"
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
        if nextField != nil && (nextField as? UITextField)?.isEnabled == true {
            nextField?.becomeFirstResponder()
            scrollView.scrollRectToVisible((nextField?.frame)!, animated: true)
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }

}
