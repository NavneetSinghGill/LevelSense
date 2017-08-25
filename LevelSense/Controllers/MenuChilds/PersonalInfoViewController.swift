//
//  PersonalInfoViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

enum OptionSelectionInProgress {
    case country
    case state
}

class PersonalInfoViewController: LSViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, SelectedOption {
    
    let textFieldBaseTag = 901
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var postalCodeTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var stateButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    
    var countries : NSArray = []
    var fullStates : NSArray = []
    var countryStates : NSArray = []
    
    var optionSelectionInProgress: OptionSelectionInProgress!
    
    var countryID: Int! = -1
    var stateID: Int! = -1
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuButton()
        setNavigationTitle(title: "Personal Information")
        
        self.setDetailsOf(user: User.user)
        
        getUserDetails()
    }
    
    //MARK:- IBActions methods
    
    @IBAction func submitButtonTapped() {
        view.endEditing(true)
        postUserDetails()
    }
    
    @IBAction func countryButtonTapped(button: UIButton) {
        let optionVC : OptionSelectionViewController = getOptionVC()
        
        optionVC.options = self.countries.value(forKey: "name") as! NSArray
        optionSelectionInProgress = .country
        
        let startIndex: Int! = optionVC.options.index(of: self.countryTextField.text!)
        optionVC.startIndex =  (startIndex != Int.max) ? startIndex : 0
        
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func stateButtonTapped(button: UIButton) {
        let optionVC : OptionSelectionViewController = getOptionVC()
        
        optionVC.options = self.countryStates.value(forKey: "name") as! NSArray
        optionSelectionInProgress = .state
        
        let startIndex: Int! = optionVC.options.index(of: self.stateTextField.text!)
        optionVC.startIndex =  (startIndex != Int.max) ? startIndex : 0
        
        self.present(optionVC, animated: true, completion: nil)
    }
    
    //MARK:- selectedOption protocol method
    
    func selectedOption(index: NSInteger) {
        if optionSelectionInProgress == .country {
            countryTextField.text = (self.countries.value(forKey: "name") as! NSArray)[index] as? String
            
            let selectedCountryID = ((self.countries.value(forKey: "id") as! NSArray)[index] as! Int)
            if countryID != selectedCountryID {
                countryID = selectedCountryID
                stateID = -1
                stateTextField.text = ""
            }
            countryStates = ((fullStates.filter { (($0 as! Dictionary<String, Any>)["countryId"] as! Int) == countryID } as NSArray).sortedArray(using: [NSSortDescriptor.init(key: "name", ascending: true)])) as NSArray
        } else {
            stateTextField.text = (self.countryStates.value(forKey: "name") as! NSArray)[index] as? String
            stateID = ((self.countryStates.value(forKey: "id") as! NSArray)[index] as! Int)
        }
    }
    
    //MARK:- Private methods
    
    private func getUserDetails() {
        
        startAnimating()
        UserRequestManager.getUserAPICallWith { (success, response, error) in
            if success {
                let user = User.user
                self.setDetailsOf(user: user!)
                
                self.postUserRefreshNotification()
                self.getCountryList()
            }
        }
    }
    
    private func postUserDetailsOf(newUser: User) {
        
        startAnimating()
        UserRequestManager.postEditUserAPICallWith(user: newUser) { (success, response, error) in
            if success {
                self.setDetailsOf(user: newUser)
                newUser.saveUser()
                
                Banner.showSuccessWithTitle(title: "User details updated successfully")
                
                self.postUserRefreshNotification()
            }
            self.stopAnimating()
        }
    }
    
    private func getCountryList() {
        UserRequestManager.getCountryListAPICallWith { (success, response, error) in
            let countryList: NSArray = (response as! Dictionary<String, AnyObject>)["countryList"] as! NSArray
            if countryList.count != 0 {
                self.countries = countryList
                
                
                let countryNames: NSArray = (countryList.value(forKey: "name") as! NSArray)
                
                if countryNames.index(of: self.countryTextField.text!) != Int.max {
                    self.countryID = countryNames.index(of: self.countryTextField.text!)
                }
                
                if self.countryID == -1 {
                    self.stopAnimating()
                } else {
                    self.getStateListWithCountryID(countryID: self.countryID)
                }
            } else {
                Banner.showFailureWithTitle(title: "An error occured while fetching countries")
                self.stopAnimating()
            }
        }
    }
    
    private func getStateListWithCountryID(countryID: Int) {
        if countryID != -1 {
            UserRequestManager.getStateListAPICallWith(countryID: countryID) { (success, response, error) in
                let stateList: NSArray = (response as! Dictionary<String, AnyObject>)["stateList"] as! NSArray
                if stateList.count != 0 {
                    self.fullStates = stateList
                    
                    
                    let stateNames: NSArray = (stateList.value(forKey: "name") as! NSArray)
                    
                    if stateNames.index(of: self.stateTextField.text!) != Int.max {
                        self.stateID = stateNames.index(of: self.countryTextField.text!)
                    }
                    
                } else {
                    Banner.showFailureWithTitle(title: "An error occured while fetching states")
                }
                self.stopAnimating()
            }
        } else {
            Banner.showFailureWithTitle(title: "Please select country first")
        }
    }
    
    private func setDetailsOf(user: User) {
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        addressTextField.text = user.address
        cityTextField.text = user.city
        postalCodeTextField.text = user.zipcode
        countryTextField.text = user.country
        stateTextField.text = user.state
    }
    
    private func areEntriesValid() -> Bool {
        var message: String! = ""
        if firstNameTextField?.text?.trim().characters.count == 0 {
            message = "Please enter first name"
        } else if lastNameTextField?.text?.characters.count == 0 {
            message = "Please enter last name"
        } else if emailTextField?.text?.characters.count == 0 {
            message = "Please enter email"
        } else if addressTextField?.text?.characters.count == 0 {
            message = "Please enter address"
        } else if cityTextField?.text?.characters.count == 0 {
            message = "Please enter city"
        } else if postalCodeTextField?.text?.characters.count == 0 {
            message = "Please enter postalCode"
        } else if countryTextField?.text?.characters.count == 0 {
            message = "Please enter country"
        } else if stateTextField?.text?.characters.count == 0 {
            message = "Please enter state"
        }
        
        //Show Banner
        if message.characters.count != 0 {
            Banner.showFailureWithTitle(title:message)
        }
        return message.characters.count == 0
    }
    
    private func postUserDetails() {
        if areEntriesValid() {
            let user = getUpdatedPersonalDetails()
            
            postUserDetailsOf(newUser: user)
        }
    }
    
    private func getUpdatedPersonalDetails() -> User {
        let user = User()
        user.firstName = firstNameTextField.text?.trim()
        user.lastName = lastNameTextField.text?.trim()
        user.email = emailTextField.text?.trim()
        user.address = addressTextField.text?.trim()
        user.city = cityTextField.text?.trim()
        user.zipcode = postalCodeTextField.text?.trim()
        user.country = countryTextField.text?.trim()
        user.state = stateTextField.text?.trim()
        
        return user
    }
    
    private func postUserRefreshNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LNRefreshUser), object: nil)
    }
    
    private func getOptionVC() -> OptionSelectionViewController {
        let optionVC : OptionSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController") as! OptionSelectionViewController
        optionVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        optionVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        optionVC.delegate = self;
        
        return optionVC
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
}
