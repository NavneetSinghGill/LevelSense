//
//  LoginViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 11/08/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class LoginViewController: LSViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

//        emailTextField?.text = "patildipakr@gmail.com"
//        passwordTextField?.text = "Welcome123"
        emailTextField?.text = "nishuk0007@gmail.com"
        passwordTextField?.text = "123456"
        emailTextField?.becomeFirstResponder()
    }
    
    //MARK: IBAction methods
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        self.performLogin()
    }
    
    //MARK: Private methods

    private func areEntriesValid() -> Bool {
        var message: String! = ""
        if emailTextField?.text?.trim().characters.count == 0 {
            message = "Please enter email"
        } else if !(emailTextField?.text?.trim().isValidEmail())! {
            message = "Please enter a valid email"
        } else if passwordTextField?.text?.characters.count == 0 {
            message = "Please enter password"
        }
        
        //Show Banner
        if message.characters.count != 0 {
            Banner.showFailureWithTitle(title:message)
        }
        return message.characters.count == 0
    }
    
    private func performLogin() -> Void {
        if areEntriesValid() {
            
            startAnimating()
            //perform api call
            LoginRequestManager.postLoginAPICallWith(email: (emailTextField?.text)!, password: (passwordTextField?.text)!, block: { (success, response, error) in
                if success {
                    let sessionKey = (response as! Dictionary<String, AnyObject>)["sessionKey"]
                    if sessionKey != nil {
                        UserDefaults.standard.setValue(sessionKey, forKey: kSessionKey)
                        UserDefaults.standard.synchronize()
                        
                        self.openMenuWithChilds()
                    }
                }
                self.stopAnimating()
            })
        }
    }
    
    private func openMenuWithChilds() {
        let rearController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController")
        let frontController = UINavigationController.init(rootViewController: (storyboard?.instantiateViewController(withIdentifier: "MyDevicesViewController"))!)
        
        let swController = SWRevealViewController.init(rearViewController: rearController, frontViewController: frontController)
        
        DispatchQueue.main.async {
            appDelegate.window?.rootViewController = swController
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

