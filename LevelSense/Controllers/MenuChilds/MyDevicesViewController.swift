//
//  MyDevicesViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/18/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class MyDevicesViewController: LSViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomActionView: UIView!
    @IBOutlet weak var heightConstaintOfActionView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstaintOfActionView: NSLayoutConstraint!
    
    var currentSelectedIndex:IndexPath = IndexPath.init(row: -1, section: 0)
    var devices: NSMutableArray!
    
    let myDevicesTableViewCellIdentifier = "MyDevicesTableViewCell"

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addMenuButton()
        setNavigationTitle(title: "MY DEVICES")
        tableView.registerNib(withIdentifierAndNibName: "MyDevicesTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
     
        //API
        getDevices()
    }

    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myDevicesTableViewCellIdentifier, for: indexPath) as! MyDevicesTableViewCell
        cell.deviceNameLabel.text = "assssssssas"+"\(indexPath.row)"
        cell.changeViewIf(isSelected: indexPath.row == currentSelectedIndex.row, withAnimation: false)
        
        return cell
    }
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if currentSelectedIndex.row == -1 {
            
            //Select new cell
            currentSelectedIndex = indexPath
            let cell = tableView.cellForRow(at: currentSelectedIndex) as! MyDevicesTableViewCell
            cell.changeViewIf(isSelected: true, withAnimation: true)
            openBottomView()
            
        } else if currentSelectedIndex.row == indexPath.row {
            
            //Deselect selected cell
            let cell = tableView.cellForRow(at: currentSelectedIndex) as! MyDevicesTableViewCell
                cell.changeViewIf(isSelected: false, withAnimation: true)
            currentSelectedIndex = IndexPath.init(row: -1, section: 0)
            closeBottomView()
            
        } else {
            
            //Deselect selected cell
            var cell = tableView.cellForRow(at: currentSelectedIndex) as? MyDevicesTableViewCell
            cell?.changeViewIf(isSelected: false, withAnimation: true)
            
            //Select new cell
            currentSelectedIndex = indexPath
            cell = tableView.cellForRow(at: currentSelectedIndex) as? MyDevicesTableViewCell
            cell?.changeViewIf(isSelected: true, withAnimation: true)
        }
        
    }
    
    //MARK:- Private methods
    
    func openBottomView() {
        UIView.animate(withDuration: kMyDevicesAnimationDuration) { 
            self.bottomConstaintOfActionView.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBottomView() {
        UIView.animate(withDuration: kMyDevicesAnimationDuration) {
            self.bottomConstaintOfActionView.constant = -self.heightConstaintOfActionView.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func getDevices() {
        startAnimating()
        UserRequestManager.getDevicesAPICallWith() { (success, response, error) in
            if success {
                
            }
            self.stopAnimating()
        }
    }
    
}
