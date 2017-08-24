//
//  PersonalInfoViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class PersonalInfoViewController: LSViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuButton()
        setNavigationTitle(title: "Personal Information")
        
        self.setDetailsOf(user: User.user)
        
        getUserDetails()
    }
    
    //MARK: IBActions methods
    
    @IBAction func submitButtonTapped() {
        
    }
    
    //MARK: Private methods
    
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
            }
            self.stopAnimating()
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
    
    //MARK: Notification methods
    
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
