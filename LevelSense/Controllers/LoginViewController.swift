//
//  LoginViewController.swift
//  LevelSense
//
//  Created by BestPeers on 11/08/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class LoginViewController: LSViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBAction methods
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        self.performLogin()
    }
    
    //MARK: Private methods

    func areEntriesValid() -> Bool {
        var message: String! = ""
        if emailTextField?.text?.trim().characters.count == 0 {
            message = "Please enter email"
        } else if (emailTextField?.text?.trim().isValidEmail())! {
            message = "Please enter a valid email"
        } else if passwordTextField?.text?.characters.count == 0 {
            message = "Please enter password"
        }
        
        //Show Banner
        print("message: \(message)")
        return message.characters.count == 0
    }
    
    func performLogin() -> Void {
        if areEntriesValid() {
            //showLoader()
            //perform api call
            LoginRequestManager.postLoginAPICallWith(email: (emailTextField?.text)!, password: (passwordTextField?.text)!, block: { (success, response, error) in
                if success {
                    let sessionKey = (response as! Dictionary<String, AnyObject>)["sessionKey"]!
                    if sessionKey.boolValue! {
                        UserDefaults.standard.setValue(sessionKey, forKey: kSessionKey)
                        UserDefaults.standard.synchronize()
                    }
                }
                //self.removeLoader()
            })
        }
    }
    
    //MARK:- TextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField?.becomeFirstResponder()
        } else {
            passwordTextField?.resignFirstResponder()
            performLogin()
        }
        return true
    }

}

