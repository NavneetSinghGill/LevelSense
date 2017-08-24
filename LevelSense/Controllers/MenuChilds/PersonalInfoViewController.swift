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
    var states : NSArray = []
    
    var optionSelectionInProgress: OptionSelectionInProgress!
    
    

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
        
        optionVC.options = ["c1","c2","c3","c4","c5"]
        countries = optionVC.options
        optionSelectionInProgress = .country
        
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func stateButtonTapped(button: UIButton) {
        let optionVC : OptionSelectionViewController = getOptionVC()
        optionVC.options = ["s1","s2","s3","s4","s5"]
        states = optionVC.options
        optionSelectionInProgress = .state
        
        self.present(optionVC, animated: true, completion: nil)
    }
    
    //MARK:- selectedOption protocol method
    
    func selectedOption(index: NSInteger) {
        if optionSelectionInProgress == .country {
            countryTextField.text = countries[index] as? String
        } else {
            stateTextField.text = states[index] as? String
        }
    }
    
    //MARK:- Private methods
    
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
    
    func getUserDetails() {
        
        startAnimating()
        UserRequestManager.getUserAPICallWith { (success, response, error) in
            if success {
                let user = User.user
                self.setDetailsOf(user: user!)
                
                self.postUserRefresh()
            }
            self.stopAnimating()
        }
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
    
    func postUserDetails() {
        if areEntriesValid() {
            let user = User()
            user.firstName = firstNameTextField.text?.trim()
            user.lastName = lastNameTextField.text?.trim()
            user.email = emailTextField.text?.trim()
            user.address = addressTextField.text?.trim()
            user.city = cityTextField.text?.trim()
            user.zipcode = postalCodeTextField.text?.trim()
            user.country = countryTextField.text?.trim()
            user.state = stateTextField.text?.trim()
            
            postUserDetailsOf(newUser: user)
        }
    }
    
    func postUserDetailsOf(newUser: User) {
        
        startAnimating()
        UserRequestManager.postEditUserAPICallWith(user: newUser) { (success, response, error) in
            if success {
                self.setDetailsOf(user: newUser)
                newUser.saveUser()
                
                Banner.showSuccessWithTitle(title: "User details updated successfully")
                
                self.postUserRefresh()
            }
            self.stopAnimating()
        }
    }
    
    func postUserRefresh() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LNRefreshUser), object: nil)
    }
    
    func getOptionVC() -> OptionSelectionViewController {
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
