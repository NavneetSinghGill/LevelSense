//
//  MenuViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/18/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class MenuViewController: LSViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var optionNames: NSArray!
    var optionImageNames: NSArray!
    
    var screenToShow: UIViewController!
    var indexOfSelectedScreen: NSInteger = 0
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuTableViewCell")
        
        optionNames = ["My Devices","Claim Device","Notifications","Personal Information","Logout"]
        optionImageNames = ["myDevices","claimDevice","notifications","personalInfo","logout"]
        
        refreshUser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: LNRefreshUser), object: nil)
    }
    
    func refreshUser() {
        let firstName = User.user.firstName
        let lastName = User.user.lastName
        
        if lastName?.characters.count != 0 {
            userNameLabel.text = "\(firstName!) \(lastName!)"
        } else {
            userNameLabel.text = "\(firstName!)"
        }
    }
    
    //MARK:- Tableview datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionNames.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell: MenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        menuCell.optionImageView.image = UIImage(named: optionImageNames.object(at: indexPath.row) as! String)
        menuCell.optionNameLabel.text = optionNames.object(at: indexPath.row) as? String
        
        return menuCell
    }
    
    //MARK:- Tableview delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let halfViewHeight = self.view.frame.size.height/2
        return (halfViewHeight/CGFloat(optionNames.count))
        //This will make tableview fit all cell to half of tableview height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Shouldnt open screen which is already open
        if indexOfSelectedScreen == indexPath.row {
            return
        }
        
        switch indexPath.row {
        case 0:
            screenToShow = storyboard?.instantiateViewController(withIdentifier: "MyDevicesViewController")
        case 1:
            screenToShow = storyboard?.instantiateViewController(withIdentifier: "ClaimDeviceViewController")
        case 2:
            screenToShow = storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController")
        case 3:
            screenToShow = storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController")
        case 4:
            screenToShow = nil
            performLogout()
        default:
            break
        }
        
        if screenToShow != nil {
            indexOfSelectedScreen = indexPath.row
            revealViewController().pushFrontViewController(UINavigationController.init(rootViewController: screenToShow!), animated: true)
        }
    }
    
    //MARK: Private methods
    
    private func performLogout() {
        
        startAnimating()
        LoginRequestManager.postLogoutAPICallWith { (success, response, error) in
            if success {
                appDelegate.logout()
            }
            self.stopAnimating()
        }
    }

}
