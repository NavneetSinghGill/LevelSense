//
//  AlarmConfigViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/31/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class AlarmConfigViewController: LSViewController, SelectedOptionProtocol, UITextFieldDelegate {
    
    let tempCheckBoxesBaseTag = 800
    let humidityCheckBoxesBaseTag = 810
    let incomingPowerCheckBoxesBaseTag = 820
    let leakSensorCheckBoxesBaseTag = 830
    let floatSwitchCheckBoxesBaseTag = 840
    
    let textFieldBaseTag = 900
    
    @IBOutlet weak var leakSensorButton: UIButton!
    @IBOutlet weak var floatSwitchButton: UIButton!
    @IBOutlet weak var temperatureMinButton: UIButton!
    @IBOutlet weak var temperatureMaxButton: UIButton!
    @IBOutlet weak var humidityMinButton: UIButton!
    @IBOutlet weak var humidityMaxButton: UIButton!
    
    @IBOutlet weak var temperatureMinTextField: UITextField!
    @IBOutlet weak var temperatureMaxTextField: UITextField!
    @IBOutlet weak var humidityMinTextField: UITextField!
    @IBOutlet weak var humidityMaxTextField: UITextField!
    
    @IBOutlet weak var leakSensorOptionsLabel: UILabel!
    @IBOutlet weak var floatSwitchOptionsLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var incomingPowerLabel: UILabel!
    @IBOutlet weak var leakSensorLabel: UILabel!
    @IBOutlet weak var floatSwitchLabel: UILabel!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tempDict: Dictionary<String,Any>!
    var humidityDict: Dictionary<String,Any>!
    var powerDict: Dictionary<String,Any>!
    var leakSensorDict: Dictionary<String,Any>!
    var floatSwitchDict: Dictionary<String,Any>!
    
    var alarmConfigAllData: Dictionary<String,Any>!
    var alarmConfigOnly: Array<Dictionary<String,Any>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "Alarm Configuration")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        alarmConfigOnly = alarmConfigAllData?["alarmConfiguration"] as! Array<Dictionary<String,Any>>
        updateUIWithConfig()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func leakSensorOptionButtonTapped(button: UIButton) {
        
        let statusList: NSArray = (leakSensorDict["statusList"] as! Array<Dictionary<String,Any>> as NSArray)
        let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
        
        let startIndex = allLabels.index(of: leakSensorOptionsLabel.text!)
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: allLabels, startIndex: startIndex, sender: button)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func floatSwitchOptionButtonTapped(button: UIButton) {
        let statusList: NSArray = (floatSwitchDict["statusList"] as! Array<Dictionary<String,Any>> as NSArray)
        let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
        
        let startIndex = allLabels.index(of: floatSwitchOptionsLabel.text!)
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: allLabels, startIndex: startIndex, sender: button)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(button: UIButton) {
        editDevice()
    }
    
    //MARK: Checkbox handling actions
    
    @IBAction func temperatureCheckBoxTapped(checkBoxButton: UIButton) {
//        if checkBoxButton.isSelected {
//            unCheckAllButtonsWith(baseTag: tempCheckBoxesBaseTag)
//        } else {
//            unCheckAllButtonsWith(baseTag: tempCheckBoxesBaseTag)
//            checkBoxButton.isSelected = true
//        }
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func humidityCheckBoxTapped(checkBoxButton: UIButton) {
//        if checkBoxButton.isSelected {
//            unCheckAllButtonsWith(baseTag: humidityCheckBoxesBaseTag)
//        } else {
//            unCheckAllButtonsWith(baseTag: humidityCheckBoxesBaseTag)
//            checkBoxButton.isSelected = true
//        }
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func incomingPowerCheckBoxTapped(checkBoxButton: UIButton) {
//        if checkBoxButton.isSelected {
//            unCheckAllButtonsWith(baseTag: incomingPowerCheckBoxesBaseTag)
//        } else {
//            unCheckAllButtonsWith(baseTag: incomingPowerCheckBoxesBaseTag)
//            checkBoxButton.isSelected = true
//        }
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func leakSensorCheckBoxTapped(checkBoxButton: UIButton) {
//        if checkBoxButton.isSelected {
//            unCheckAllButtonsWith(baseTag: leakSensorCheckBoxesBaseTag)
//        } else {
//            unCheckAllButtonsWith(baseTag: leakSensorCheckBoxesBaseTag)
//            checkBoxButton.isSelected = true
//        }
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func floatSwitchCheckBoxTapped(checkBoxButton: UIButton) {
//        if checkBoxButton.isSelected {
//            unCheckAllButtonsWith(baseTag: floatSwitchCheckBoxesBaseTag)
//        } else {
//            unCheckAllButtonsWith(baseTag: floatSwitchCheckBoxesBaseTag)
//            checkBoxButton.isSelected = true
//        }
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    //MARK: Popup action
    
    @IBAction func tempMinTapped(sender: UIButton) {
        let minValuesDict = tempDict["min"] as? NSArray
        let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: minValues, startIndex: minValues.index(of: Int(self.temperatureMinTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func tempMaxTapped(sender: UIButton) {
        let maxValuesDict = tempDict["max"] as? NSArray
        let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: maxValues, startIndex: maxValues.index(of: Int(self.temperatureMaxTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func humidityMinTapped(sender: UIButton) {
        let minValuesDict = humidityDict["min"] as? NSArray
        let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: minValues, startIndex: minValues.index(of: Int(self.humidityMinTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func humidityMaxTapped(sender: UIButton) {
        let maxValuesDict = humidityDict["max"] as? NSArray
        let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: maxValues, startIndex: maxValues.index(of: Int(self.humidityMaxTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    //MARK: - Selection option protocol
    
    func selectedOption(index:NSInteger, sender: Any?) {
        if sender as? UIButton == leakSensorButton {
            let statusList: NSArray = (leakSensorDict["statusList"] as! Array<Dictionary<String,Any>> as NSArray)
            let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
            
            leakSensorOptionsLabel.text = allLabels[index] as? String
        } else if sender as? UIButton == floatSwitchButton {
            let statusList: NSArray = (floatSwitchDict["statusList"] as! Array<Dictionary<String,Any>> as NSArray)
            let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
            
            floatSwitchOptionsLabel.text = allLabels[index] as? String
        } else if sender as? UIButton == temperatureMinButton {
            let minValuesDict = tempDict["min"] as? NSArray
            let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
            temperatureMinTextField.text = "\(minValues.object(at: index))"
        } else if sender as? UIButton == temperatureMaxButton {
            let maxValuesDict = tempDict["max"] as? NSArray
            let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
            temperatureMaxTextField.text = "\(maxValues.object(at: index))"
        } else if sender as? UIButton == humidityMinButton {
            let minValuesDict = humidityDict["min"] as? NSArray
            let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
            humidityMinTextField.text = "\(minValues.object(at: index))"
        } else if sender as? UIButton == humidityMaxButton {
            let maxValuesDict = humidityDict["max"] as? NSArray
            let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
            humidityMaxTextField.text = "\(maxValues.object(at: index))"
        }
    }
    
    //MARK: - Private methods
    
    private func unCheckAllButtonsWith(baseTag: Int) {
        buttonWith(tag: baseTag+1)?.isSelected = false
        buttonWith(tag: baseTag+2)?.isSelected = false
        buttonWith(tag: baseTag+3)?.isSelected = false
    }
    
    private func checkBox(select: Bool, withTag tag: Int, andBaseTag baseTag: Int) {
        buttonWith(tag: baseTag+tag)?.isSelected = select
    }
    
    private func getCheckBox(withTag tag: Int, andBaseTag baseTag: Int) -> UIButton {
        return buttonWith(tag: baseTag+tag)!
    }
    
    private func buttonWith(tag: Int) -> UIButton? {
        let button: UIButton = (view.viewWithTag(tag) as? UIButton)!
        return button
    }
    
    private func getOptionVCWith(content: NSArray, startIndex: Int?, sender:Any?) -> OptionSelectionViewController {
        let optionVC : OptionSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController") as! OptionSelectionViewController
        optionVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        optionVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        optionVC.delegate = self
        optionVC.options = content
        optionVC.sender = sender
        optionVC.startIndex = startIndex
        
        return optionVC
    }
    
    private func getDeviceIfEntriesValid() -> Dictionary<String, Any>? {
        var message: String! = ""
        var deviceDict : Dictionary<String,Any> = [:]
        var alarmConfigs: Array<Dictionary<String,Any>> = []
        
        if tempDict != nil {
            var newTempDict: Dictionary<String,Any> = [:]
            newTempDict["sensorId"] = tempDict["sensorId"]
            newTempDict["ucl"] = temperatureMinTextField.text
            newTempDict["lcl"] = temperatureMaxTextField.text
            
            newTempDict["relay"] = getCheckBox(withTag: 1, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 2 : 0
            newTempDict["siren"] = getCheckBox(withTag: 2, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 1 : 0
            newTempDict["email"] = getCheckBox(withTag: 3, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newTempDict)
        }
        if humidityDict != nil {
            var newHumidityDict: Dictionary<String,Any> = [:]
            newHumidityDict["sensorId"] = humidityDict["sensorId"]
            newHumidityDict["ucl"] = humidityMinTextField.text
            newHumidityDict["lcl"] = humidityMaxTextField.text
            
            newHumidityDict["relay"] = getCheckBox(withTag: 1, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 2 : 0
            newHumidityDict["siren"] = getCheckBox(withTag: 2, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 1 : 0
            newHumidityDict["email"] = getCheckBox(withTag: 3, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newHumidityDict)
        }
        if powerDict != nil {
            var newPowerDict: Dictionary<String,Any> = [:]
            newPowerDict["sensorId"] = powerDict["sensorId"]
            newPowerDict["currentValue"] = incomingPowerLabel.text
            
            newPowerDict["relay"] = getCheckBox(withTag: 1, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 2 : 0
            newPowerDict["siren"] = getCheckBox(withTag: 2, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 1 : 0
            newPowerDict["email"] = getCheckBox(withTag: 3, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newPowerDict)
        }
        if leakSensorDict != nil {
            var newLeakSensorDict: Dictionary<String,Any> = [:]
            newLeakSensorDict["sensorId"] = leakSensorDict["sensorId"]
            newLeakSensorDict["currentValue"] = leakSensorLabel.text
            newLeakSensorDict["status"] = leakSensorOptionsLabel.text
            
            newLeakSensorDict["relay"] = getCheckBox(withTag: 1, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 2 : 0
            newLeakSensorDict["siren"] = getCheckBox(withTag: 2, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newLeakSensorDict["email"] = getCheckBox(withTag: 3, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newLeakSensorDict)
        }
        if floatSwitchDict != nil {
            var newFloatSwitchDict: Dictionary<String,Any> = [:]
            newFloatSwitchDict["sensorId"] = floatSwitchDict["sensorId"]
            newFloatSwitchDict["currentValue"] = leakSensorLabel.text
            newFloatSwitchDict["status"] = leakSensorOptionsLabel.text
            
            newFloatSwitchDict["relay"] = getCheckBox(withTag: 1, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 2 : 0
            newFloatSwitchDict["siren"] = getCheckBox(withTag: 2, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newFloatSwitchDict["email"] = getCheckBox(withTag: 3, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newFloatSwitchDict)
        }
        
        deviceDict["id"] = alarmConfigAllData["id"]
        deviceDict["sensorLimit"] = alarmConfigs
        
        
        //Show Banner
        if message.characters.count != 0 {
            Banner.showFailureWithTitle(title:message)
            return nil
        }
        return deviceDict
    }
    
    private func editDevice() {
        let finalRequestDict = getDeviceIfEntriesValid()
        if finalRequestDict != nil {
            startAnimating()
            UserRequestManager.postEditDeviceAPICallWith(deviceDict: finalRequestDict!) { (success, response, error) in
                if success {
                    
                }
                self.stopAnimating()
            }
        }
    }
    
    //MARK: For updation
    
    func updateUIWithConfig() {
        for i in 0..<self.alarmConfigOnly.count {
            
            let id: Int = Int((self.alarmConfigOnly[i])["sensorId"] as! String)!
        
            switch id {
            case 2:
                updateTemperatureWith(dict: alarmConfigOnly[i])
            case 3:
                updateHumidityWith(dict: alarmConfigOnly[i])
            case 5:
                updateIncomingPowerWith(dict: alarmConfigOnly[i])
            case 7:
                updateLeakSensorWith(dict: alarmConfigOnly[i])
            case 8:
                updateFloatSwitchWith(dict: alarmConfigOnly[i])
            default:
                break
            }
        }
    }
    
    func updateTemperatureWith(dict: Dictionary<String,Any>) {
        tempDict = dict
        
        self.tempLabel.text = "\(dict["currentValue"] as? String ?? "--")℉"
        setCheckBoxesWith(dict: dict, andBaseTag: tempCheckBoxesBaseTag)
        
        self.temperatureMinTextField.text = "\(dict["lcl"] as! Int)"
        self.temperatureMaxTextField.text = "\(dict["ucl"] as! Int)"
    }
    
    func updateHumidityWith(dict: Dictionary<String,Any>) {
        humidityDict = dict
        
        self.humidityLabel.text = "\(dict["currentValue"] as? String ?? "--")%"
        setCheckBoxesWith(dict: dict, andBaseTag: humidityCheckBoxesBaseTag)
        
        self.humidityMinTextField.text = "\(dict["lcl"] as! Int)"
        self.humidityMaxTextField.text = "\(dict["ucl"] as! Int)"
    }
    
    func updateIncomingPowerWith(dict: Dictionary<String,Any>) {
        powerDict = dict
        
        self.incomingPowerLabel.text = dict["currentValue"] as? String
        setCheckBoxesWith(dict: dict, andBaseTag: incomingPowerCheckBoxesBaseTag)
    }
    
    func updateLeakSensorWith(dict: Dictionary<String,Any>) {
        leakSensorDict = dict
        
        self.leakSensorLabel.text = dict["currentValue"] as? String
        setCheckBoxesWith(dict: dict, andBaseTag: leakSensorCheckBoxesBaseTag)
        
        for statusListDict in (dict["statusList"] as! Array<Dictionary<String,Any>>) {
            if statusListDict["selected"] as? Bool == true {
                leakSensorOptionsLabel.text = statusListDict["label"] as? String
                break
            }
        }
    }
    
    func updateFloatSwitchWith(dict: Dictionary<String,Any>) {
        floatSwitchDict = dict
        
        self.floatSwitchLabel.text = dict["currentValue"] as? String
        setCheckBoxesWith(dict: dict, andBaseTag: floatSwitchCheckBoxesBaseTag)
        
        for statusListDict in (dict["statusList"] as! Array<Dictionary<String,Any>>) {
            if statusListDict["selected"] as? Bool == true {
                floatSwitchOptionsLabel.text = statusListDict["label"] as? String
                break
            }
        }
    }
    
    func setCheckBoxesWith(dict: Dictionary<String,Any>, andBaseTag baseTag: Int) {
        if (dict["relay"] as? Int) == 2 {
            checkBox(select: true, withTag: 1, andBaseTag: baseTag)
        }
        if (dict["siren"] as? Int) == 1 {
            checkBox(select: true, withTag: 2, andBaseTag: baseTag)
        }
        if (dict["email"] as? Int) == 1 {
            checkBox(select: true, withTag: 3, andBaseTag: baseTag)
        }
    }
    
    //MARK:- Public methods
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    //MARK: Textfield delegate methods
    
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
