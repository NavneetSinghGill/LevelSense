//
//  AlarmConfigViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/31/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class AlarmConfigViewController: LSViewController, SelectedOptionProtocol,UITextFieldDelegate {
    
    let tempCheckBoxesBaseTag = 800
    let humidityCheckBoxesBaseTag = 810
    let incomingPowerCheckBoxesBaseTag = 820
    let leakSensorCheckBoxesBaseTag = 830
    let floatSwitchCheckBoxesBaseTag = 840
    
    let textFieldBaseTag = 900
    
    @IBOutlet weak var leakSensorButton: UIButton!
    @IBOutlet weak var floatSwitchButton: UIButton!
    
    @IBOutlet weak var leakSensorLabel: UILabel!
    @IBOutlet weak var floatSwitchLabel: UILabel!

    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "Alarm Configuration")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
    }
    
    //MARK: IBAction methods
    
    @IBAction func temperatureCheckBoxTapped(checkBoxButton: UIButton) {
        if checkBoxButton.isSelected {
            unCheckAllButtonsWith(baseTag: tempCheckBoxesBaseTag)
        } else {
            unCheckAllButtonsWith(baseTag: tempCheckBoxesBaseTag)
            checkBoxButton.isSelected = true
        }
    }
    
    @IBAction func humidityCheckBoxTapped(checkBoxButton: UIButton) {
        if checkBoxButton.isSelected {
            unCheckAllButtonsWith(baseTag: humidityCheckBoxesBaseTag)
        } else {
            unCheckAllButtonsWith(baseTag: humidityCheckBoxesBaseTag)
            checkBoxButton.isSelected = true
        }
    }
    
    @IBAction func incomingPowerCheckBoxTapped(checkBoxButton: UIButton) {
        if checkBoxButton.isSelected {
            unCheckAllButtonsWith(baseTag: incomingPowerCheckBoxesBaseTag)
        } else {
            unCheckAllButtonsWith(baseTag: incomingPowerCheckBoxesBaseTag)
            checkBoxButton.isSelected = true
        }
    }
    
    @IBAction func leakSensorCheckBoxTapped(checkBoxButton: UIButton) {
        if checkBoxButton.isSelected {
            unCheckAllButtonsWith(baseTag: leakSensorCheckBoxesBaseTag)
        } else {
            unCheckAllButtonsWith(baseTag: leakSensorCheckBoxesBaseTag)
            checkBoxButton.isSelected = true
        }
    }
    
    @IBAction func floatSwitchCheckBoxTapped(checkBoxButton: UIButton) {
        if checkBoxButton.isSelected {
            unCheckAllButtonsWith(baseTag: floatSwitchCheckBoxesBaseTag)
        } else {
            unCheckAllButtonsWith(baseTag: floatSwitchCheckBoxesBaseTag)
            checkBoxButton.isSelected = true
        }
    }
    
    @IBAction func leakSensorOptionButtonTapped(button: UIButton) {
        let startIndex = alarmWhenCloseOpen.index(of: leakSensorLabel.text!)
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: alarmWhenCloseOpen, startIndex: startIndex, sender: button)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func floatSwitchOptionButtonTapped(button: UIButton) {
        let startIndex = alarmWhenCloseOpen.index(of: floatSwitchLabel.text!)
        let optionVC: OptionSelectionViewController = getOptionVCWith(content: alarmWhenCloseOpen, startIndex: startIndex, sender: button)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(button: UIButton) {
        
    }
    
    //MARK: Selection option protocol
    
    func selectedOption(index:NSInteger, sender: Any?) {
        if sender as? UIButton == leakSensorButton {
            leakSensorLabel.text = alarmWhenCloseOpen[index] as? String
        } else if sender as? UIButton == floatSwitchButton {
            floatSwitchLabel.text = alarmWhenCloseOpen[index] as? String
        }
    }
    
    //MARK: Private methods
    
    private func unCheckAllButtonsWith(baseTag: Int) {
        buttonWith(tag: baseTag+1)?.isSelected = false
        buttonWith(tag: baseTag+2)?.isSelected = false
        buttonWith(tag: baseTag+3)?.isSelected = false
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
    
    //MARK: Public methods
    
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
