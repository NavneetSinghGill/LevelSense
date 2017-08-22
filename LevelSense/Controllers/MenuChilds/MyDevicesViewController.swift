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
    
    var currentSelectedIndex:NSInteger = -1
    var devices: NSMutableArray!
    
    let myDevicesTableViewCellIdentifier = "MyDevicesTableViewCell"

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addMenuButton()
        setNavigationTitle(title: "MY DEVICES")
        tableView.registerNib(withIdentifierAndNibName: "MyDevicesTableViewCell")
        
    }

    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myDevicesTableViewCellIdentifier, for: indexPath) as! MyDevicesTableViewCell
        cell.deviceNameLabel.text = "assssssssas"+"\(indexPath.row)"
        
        return cell
    }
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if currentSelectedIndex == -1 {
            
            //Select new cell
            currentSelectedIndex = indexPath.row
            let cell = tableView.cellForRow(at: NSIndexPath.init(row: currentSelectedIndex, section: 0) as IndexPath) as! MyDevicesTableViewCell
            cell.changeViewIf(isSelected: true)
            openBottomView()
            
        } else if currentSelectedIndex == indexPath.row {
            
            //Deselect selected cell
            let cell = tableView.cellForRow(at: NSIndexPath.init(row: currentSelectedIndex, section: 0) as IndexPath) as! MyDevicesTableViewCell
                cell.changeViewIf(isSelected: false)
            currentSelectedIndex = -1
            closeBottomView()
            
        } else {
            
            //Deselect selected cell
            var cell = tableView.cellForRow(at: NSIndexPath.init(row: currentSelectedIndex, section: 0) as IndexPath) as! MyDevicesTableViewCell
            cell.changeViewIf(isSelected: false)
            
            //Select new cell
            currentSelectedIndex = indexPath.row
            cell = tableView.cellForRow(at: NSIndexPath.init(row: currentSelectedIndex, section: 0) as IndexPath) as! MyDevicesTableViewCell
            cell.changeViewIf(isSelected: true)
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
    
}
