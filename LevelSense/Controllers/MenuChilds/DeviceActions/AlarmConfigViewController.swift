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
    
    @IBOutlet weak var waterNameLabel: UILabel!
    @IBOutlet weak var temperatureNameLabel: UILabel!
    @IBOutlet weak var humidityNameLabel: UILabel!
    @IBOutlet weak var powerNameLabel: UILabel!
    @IBOutlet weak var leakSensorNameButton: UIButton!
    @IBOutlet weak var floatSwitchNameButton: UIButton!
    
    @IBOutlet weak var temperatureMinTextField: UITextField!
    @IBOutlet weak var temperatureMaxTextField: UITextField!
    @IBOutlet weak var humidityMinTextField: UITextField!
    @IBOutlet weak var humidityMaxTextField: UITextField!
    
    @IBOutlet weak var leakSensorOptionsLabel: UILabel!
    @IBOutlet weak var floatSwitchOptionsLabel: UILabel!
    @IBOutlet weak var waterLevelLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var incomingPowerLabel: UILabel!
    @IBOutlet weak var leakSensorLabel: UILabel!
    @IBOutlet weak var floatSwitchLabel: UILabel!
    @IBOutlet weak var calibratedLabel: UILabel!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var temperatureSegmentControl: UISegmentedControl!
    
    var tempDict: Dictionary<String,Any>!
    var humidityDict: Dictionary<String,Any>!
    var powerDict: Dictionary<String,Any>!
    var leakSensorDict: Dictionary<String,Any>!
    var floatSwitchDict: Dictionary<String,Any>!
    
    var alarmConfigAllData: Dictionary<String,Any>!
    var alarmConfigOnly: Array<Dictionary<String,Any>>!
    
    var didEditAnything: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "Alarm Configuration")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        alarmConfigOnly = alarmConfigAllData?["sensorLimit"] as! Array<Dictionary<String,Any>>
        self.calibratedLabel.text = (alarmConfigAllData["sensorLimitMeta"] as! Dictionary<String, AnyObject>)["cap_sense"]! as? String
        updateUIWithConfig()
    }
    
    override func backButtonTapped() {
        if didEditAnything {
            let alertVC = UIAlertController.init(title: "Do you want to save your changes?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default) { (alertAction) in
                self.editDevice(shouldCloseScreenOnSuccess: true)
            }
            let noAction = UIAlertAction.init(title: "No", style: UIAlertActionStyle.default) { (alertAction) in
                super.backButtonTapped()
            }
            alertVC.addAction(yesAction)
            alertVC.addAction(noAction)
            
            self.present(alertVC, animated: true, completion: nil)
        } else {
            super.backButtonTapped()
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func leakSensorOptionButtonTapped(button: UIButton) {
        var statusList: NSArray = []
        if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
            
            statusList = (input as NSArray)
        }
        
        let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
        
        let startIndex = allLabels.index(of: leakSensorOptionsLabel.text!)
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: allLabels, startIndex: startIndex, sender: button)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func floatSwitchOptionButtonTapped(button: UIButton) {
        var statusList: NSArray = []
        if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
            
            statusList = (input as NSArray)
        }
        let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
        
        let startIndex = allLabels.index(of: floatSwitchOptionsLabel.text!)
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: allLabels, startIndex: startIndex, sender: button)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(button: UIButton) {
        editDevice(shouldCloseScreenOnSuccess: false)
    }
    
    @IBAction func floatSwitchButtonTapped() {
        openPopup(with: "Change \'\( (self.floatSwitchNameButton.title(for: .normal))! )\' name to:", filledText: (floatSwitchNameButton.title(for: .normal))!) { (newText) in
            self.floatSwitchNameButton.setTitle(newText, for: .normal)
        }
    }
    
    @IBAction func leakSensorButtonTapped() {
        openPopup(with: "Change \'\( (self.leakSensorNameButton.title(for: .normal))! )\' name to:", filledText: (leakSensorNameButton.title(for: .normal))!) { (newText) in
            self.leakSensorNameButton.setTitle(newText, for: .normal)
        }
    }
    
    @IBAction func temperatureUnitValueDidChange() {
        if temperatureSegmentControl.selectedSegmentIndex == 0 {
            self.tempDict["sensorDisplayUnits"] = "C"
        } else {
            self.tempDict["sensorDisplayUnits"] = "F"
        }
    }
    
    func openPopup(with text:String, filledText: String, completionHandler: @escaping (_ newText: String) -> Void) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (alertAction) in
            self.didEditAnything = true
            completionHandler((alertController.textFields?.first?.text)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField) in
            textField.text = filledText
            textField.placeholder = text
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Checkbox handling actions
    
    @IBAction func temperatureCheckBoxTapped(checkBoxButton: UIButton) {
        didEditAnything = true
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func humidityCheckBoxTapped(checkBoxButton: UIButton) {
        didEditAnything = true
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func incomingPowerCheckBoxTapped(checkBoxButton: UIButton) {
        didEditAnything = true
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func leakSensorCheckBoxTapped(checkBoxButton: UIButton) {
        didEditAnything = true
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    @IBAction func floatSwitchCheckBoxTapped(checkBoxButton: UIButton) {
//        if checkBoxButton.isSelected {
//            unCheckAllButtonsWith(baseTag: floatSwitchCheckBoxesBaseTag)
//        } else {
//            unCheckAllButtonsWith(baseTag: floatSwitchCheckBoxesBaseTag)
//            checkBoxButton.isSelected = true
//        }
        didEditAnything = true
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    //MARK: Popup action
    
    @IBAction func tempMinTapped(sender: UIButton) {
        let tempMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["tempc"] as! Dictionary<String, Any>
        let tempMin = tempMetaData["min"]
        
        let minValuesDict = tempMin as? NSArray
        let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: minValues, startIndex: minValues.index(of: Int(self.temperatureMinTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func tempMaxTapped(sender: UIButton) {
        let tempMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["tempc"] as! Dictionary<String, Any>
        let tempMax = tempMetaData["max"]
        
        let maxValuesDict = tempMax as? NSArray
        let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: maxValues, startIndex: maxValues.index(of: Int(self.temperatureMaxTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func humidityMinTapped(sender: UIButton) {
        let humidityMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["rh"] as! Dictionary<String, Any>
        let humidityMin = humidityMetaData["min"]
        
        let minValuesDict = humidityMin as? NSArray
        let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: minValues, startIndex: minValues.index(of: Int(self.humidityMinTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func humidityMaxTapped(sender: UIButton) {
        let humidityMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["rh"] as! Dictionary<String, Any>
        let humidityMin = humidityMetaData["max"]
        
        let maxValuesDict = humidityMin as? NSArray
        let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
        
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: maxValues, startIndex: maxValues.index(of: Int(self.humidityMaxTextField.text!) ?? ""), sender: sender)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    //MARK: - Selection option protocol
    
    func selectedOption(index:NSInteger, sender: Any?) {
        didEditAnything = true
        if sender as? UIButton == leakSensorButton {
            var statusList: NSArray = []
            if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
                
                statusList = (input as NSArray)
            }
            
            let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
            
            leakSensorOptionsLabel.text = allLabels[index] as? String
        } else if sender as? UIButton == floatSwitchButton {
            var statusList: NSArray = []
            if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
                
                statusList = (input as NSArray)
            }
            let allLabels: NSArray = statusList.value(forKey: "label") as! NSArray
            
            floatSwitchOptionsLabel.text = allLabels[index] as? String
        } else if sender as? UIButton == temperatureMinButton {
            let tempMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["tempc"] as! Dictionary<String, Any>
            let tempMin = tempMetaData["min"]
            
            let minValuesDict = tempMin as? NSArray
            let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
            temperatureMinTextField.text = "\(minValues.object(at: index))"
        } else if sender as? UIButton == temperatureMaxButton {
            let tempMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["tempc"] as! Dictionary<String, Any>
            let tempMax = tempMetaData["max"]
            
            let maxValuesDict = tempMax as? NSArray
            let maxValues: NSArray = maxValuesDict?.value(forKey: "value") as! NSArray
            temperatureMaxTextField.text = "\(maxValues.object(at: index))"
        } else if sender as? UIButton == humidityMinButton {
            let humidityMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["rh"] as! Dictionary<String, Any>
            let humidityMin = humidityMetaData["min"]
            
            let minValuesDict = humidityMin as? NSArray
            let minValues: NSArray = minValuesDict?.value(forKey: "value") as! NSArray
            humidityMinTextField.text = "\(minValues.object(at: index))"
        } else if sender as? UIButton == humidityMaxButton {
            let humidityMetaData: Dictionary<String, Any> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String, Any>)!["rh"] as! Dictionary<String, Any>
            let humidityMin = humidityMetaData["max"]
            
            let maxValuesDict = humidityMin as? NSArray
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
    
    private func getDeviceIfEntriesValid() -> Dictionary<String, Any>? {
        var message: String! = ""
        var deviceDict : Dictionary<String,Any> = [:]
        var alarmConfigs: Array<Dictionary<String,Any>> = []
        
        if tempDict != nil {
            var newTempDict: Dictionary<String,Any> = [:]
            newTempDict["sensorId"] = tempDict["sensorId"]
            newTempDict["lcl"] = temperatureMinTextField.text
            newTempDict["ucl"] = temperatureMaxTextField.text
            newTempDict["sensorSlug"] = tempDict["sensorSlug"]
            
            newTempDict["relay"] = getCheckBox(withTag: 1, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 2 : 0
            newTempDict["siren"] = getCheckBox(withTag: 2, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 1 : 0
            newTempDict["email"] = getCheckBox(withTag: 3, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 1 : 0
            newTempDict["voice"] = getCheckBox(withTag: 4, andBaseTag: tempCheckBoxesBaseTag).isSelected ? 1 : 0
            newTempDict["sensorDisplayUnits"] = temperatureSegmentControl.selectedSegmentIndex == 0 ? "C" : "F"
            
            alarmConfigs.append(newTempDict)
        }
        if humidityDict != nil {
            var newHumidityDict: Dictionary<String,Any> = [:]
            newHumidityDict["sensorId"] = humidityDict["sensorId"]
            newHumidityDict["lcl"] = humidityMinTextField.text
            newHumidityDict["ucl"] = humidityMaxTextField.text
            newHumidityDict["sensorSlug"] = humidityDict["sensorSlug"]
            
            newHumidityDict["relay"] = getCheckBox(withTag: 1, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 2 : 0
            newHumidityDict["siren"] = getCheckBox(withTag: 2, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 1 : 0
            newHumidityDict["email"] = getCheckBox(withTag: 3, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 1 : 0
            newHumidityDict["voice"] = getCheckBox(withTag: 4, andBaseTag: humidityCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newHumidityDict)
        }
        if powerDict != nil {
            var newPowerDict: Dictionary<String,Any> = [:]
            newPowerDict["sensorId"] = powerDict["sensorId"]
            newPowerDict["currentValue"] = incomingPowerLabel.text
            newPowerDict["sensorSlug"] = powerDict["sensorSlug"]
            
            newPowerDict["relay"] = getCheckBox(withTag: 1, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 2 : 0
            newPowerDict["siren"] = getCheckBox(withTag: 2, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 1 : 0
            newPowerDict["email"] = getCheckBox(withTag: 3, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 1 : 0
            newPowerDict["voice"] = getCheckBox(withTag: 4, andBaseTag: incomingPowerCheckBoxesBaseTag).isSelected ? 1 : 0
            
            alarmConfigs.append(newPowerDict)
        }
        if leakSensorDict != nil {
            var newLeakSensorDict: Dictionary<String,Any> = [:]
            newLeakSensorDict["sensorId"] = leakSensorDict["sensorId"]
            newLeakSensorDict["currentValue"] = leakSensorLabel.text
            newLeakSensorDict["status"] = leakSensorOptionsLabel.text
            newLeakSensorDict["sensorSlug"] = leakSensorDict["sensorSlug"]
            
            newLeakSensorDict["relay"] = getCheckBox(withTag: 1, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 2 : 0
            newLeakSensorDict["siren"] = getCheckBox(withTag: 2, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newLeakSensorDict["email"] = getCheckBox(withTag: 3, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newLeakSensorDict["voice"] = getCheckBox(withTag: 4, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newLeakSensorDict["sensorDisplayName"] = (self.leakSensorNameButton.title(for: .normal))!
            
            if ((leakSensorOptionsLabel.text?.range(of: "open")) != nil) {
                newLeakSensorDict["ucl"] = 700
                newLeakSensorDict["lcl"] = 65535
            } else {
                newLeakSensorDict["ucl"] = 65535
                newLeakSensorDict["lcl"] = 700
            }
            
            alarmConfigs.append(newLeakSensorDict)
        }
        if floatSwitchDict != nil {
            var newFloatSwitchDict: Dictionary<String,Any> = [:]
            newFloatSwitchDict["sensorId"] = floatSwitchDict["sensorId"]
            newFloatSwitchDict["currentValue"] = leakSensorLabel.text
            newFloatSwitchDict["status"] = leakSensorOptionsLabel.text
            newFloatSwitchDict["sensorSlug"] = floatSwitchDict["sensorSlug"]
            
            newFloatSwitchDict["relay"] = getCheckBox(withTag: 1, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 2 : 0
            newFloatSwitchDict["siren"] = getCheckBox(withTag: 2, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newFloatSwitchDict["email"] = getCheckBox(withTag: 3, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newFloatSwitchDict["voice"] = getCheckBox(withTag: 4, andBaseTag: leakSensorCheckBoxesBaseTag).isSelected ? 1 : 0
            newFloatSwitchDict["sensorDisplayName"] = (self.floatSwitchNameButton.title(for: .normal))!
            
            if ((floatSwitchOptionsLabel.text?.range(of: "open")) != nil) {
                newFloatSwitchDict["ucl"] = 700
                newFloatSwitchDict["lcl"] = 65535
            } else {
                newFloatSwitchDict["ucl"] = 65535
                newFloatSwitchDict["lcl"] = 700
            }
            
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
    
    private func editDevice(shouldCloseScreenOnSuccess: Bool) {
        let finalRequestDict = getDeviceIfEntriesValid()
        if finalRequestDict != nil {
            startAnimating()
            UserRequestManager.postEditDeviceAPICallWith(deviceDict: finalRequestDict!) { (success, response, error) in
                if success {
                    self.didEditAnything = false
                    Banner.showSuccessWithTitle(title: "Alarm configuration updated successfully")
                    if shouldCloseScreenOnSuccess {
                        super.backButtonTapped()
                    }
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
            case 1:
                updateWaterLevelWith(dict: alarmConfigOnly[i])
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
    
    func updateWaterLevelWith(dict: Dictionary<String,Any>) {
        let unit: String = dict["sensorDisplayUnits"] as! String
        let value = dict["currentValue"] as? String ?? ""
        self.waterLevelLabel.text = "\((value.characters.count) > 0 ? value : "--")\(unit.characters.count > 0 ? unit : "℉")"
        waterNameLabel.text = (dict["sensorDisplayName"] as? String ?? "Water Level")
    }
    
    func updateTemperatureWith(dict: Dictionary<String,Any>) {
        tempDict = dict
        
        let unit: String = dict["sensorDisplayUnits"] as! String
        let value = dict["currentValue"] as? String ?? ""
        let valueCGFloat: Float = Float(value) ?? 0
        self.tempLabel.text = "\((value.characters.count) > 0 ? valueCGFloat.rounded(toPlaces: 1) : "--")\(unit.characters.count > 0 ? unit : "")"
        self.temperatureNameLabel.text = (dict["sensorDisplayName"] as? String ?? "Temperature")
        setCheckBoxesWith(dict: dict, andBaseTag: tempCheckBoxesBaseTag)
        
        temperatureSegmentControl.selectedSegmentIndex = unit == "F" ? 1 : 0
        
        self.temperatureMinTextField.text = "\(dict["lcl"] as! Int)"
        self.temperatureMaxTextField.text = "\(dict["ucl"] as! Int)"
    }
    
    func updateHumidityWith(dict: Dictionary<String,Any>) {
        humidityDict = dict
        
        let unit: String = dict["sensorDisplayUnits"] as! String
        let value = dict["currentValue"] as? String ?? ""
        let valueCGFloat: Float = Float(value) ?? 0
        self.humidityLabel.text = "\((value.characters.count) > 0 ? valueCGFloat.rounded(toPlaces: 1) : "--")\(unit.characters.count > 0 ? unit : "%")"
        self.humidityNameLabel.text = (dict["sensorDisplayName"] as? String ?? "Humidity")
        setCheckBoxesWith(dict: dict, andBaseTag: humidityCheckBoxesBaseTag)
        
        self.humidityMinTextField.text = "\(dict["lcl"] as! Int)"
        self.humidityMaxTextField.text = "\(dict["ucl"] as! Int)"
    }
    
    func updateIncomingPowerWith(dict: Dictionary<String,Any>) {
        powerDict = dict
        
        self.incomingPowerLabel.text = dict["currentValue"] as? String
        self.powerNameLabel.text = (dict["sensorDisplayName"] as? String ?? "Incoming Power")
        setCheckBoxesWith(dict: dict, andBaseTag: incomingPowerCheckBoxesBaseTag)
    }
    
    func updateLeakSensorWith(dict: Dictionary<String,Any>) {
        leakSensorDict = dict
        
        self.leakSensorLabel.text = dict["currentValue"] as? String
        self.leakSensorNameButton.setTitle((dict["sensorDisplayName"] as? String ?? "Leak Sensor"), for: .normal)
        setCheckBoxesWith(dict: dict, andBaseTag: leakSensorCheckBoxesBaseTag)
        
        if dict["lcl"] as? Int == 65535 && dict["ucl"] as? Int == 700 {
            
            if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
                
                for statusListDict in input {
                    if (statusListDict["value"] as? String)?.lowercased() == "open" {
                        leakSensorOptionsLabel.text = statusListDict["label"] as? String
                        break
                    }
                }
            }
        } else {
            if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
                
                for statusListDict in input {
                    if (statusListDict["value"] as? String)?.lowercased() == "closed" {
                        leakSensorOptionsLabel.text = statusListDict["label"] as? String
                        break
                    }
                }
            }
        }
    }
    
    func updateFloatSwitchWith(dict: Dictionary<String,Any>) {
        floatSwitchDict = dict
        
        self.floatSwitchLabel.text = dict["currentValue"] as? String
        self.floatSwitchNameButton.setTitle((dict["sensorDisplayName"] as? String ?? "Float Switch"), for: .normal)
        setCheckBoxesWith(dict: dict, andBaseTag: floatSwitchCheckBoxesBaseTag)

        if dict["lcl"] as? Int == 65535 && dict["ucl"] as? Int == 700 {
            
            if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
                
                for statusListDict in input {
                    if (statusListDict["value"] as? String)?.lowercased() == "open" {
                        floatSwitchOptionsLabel.text = statusListDict["label"] as? String
                        break
                    }
                }
            }
        } else {
            if let input: Array<Dictionary<String, Any>> = (alarmConfigAllData["sensorLimitMeta"] as? Dictionary<String,Any>)?["input1"] as? Array<Dictionary<String, Any>> {
                
                for statusListDict in input {
                    if (statusListDict["value"] as? String)?.lowercased() == "closed" {
                        floatSwitchOptionsLabel.text = statusListDict["label"] as? String
                        break
                    }
                }
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
        if (dict["voice"] as? Int) == 1 {
            checkBox(select: true, withTag: 4, andBaseTag: baseTag)
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
