//
//  AlarmLogViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class AlarmLogViewController: LSViewController, UITableViewDataSource, UITableViewDelegate {
    
    let alarmLogTableViewCellIdentifier = "AlarmLogTableViewCell"
    
    var deviceLogs: [DeviceLog] = []
    var paging: Dictionary<String,Any>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        setNavigationTitle(title: "ALARM LOGS")
        
        //Normal notification cell
        tableView.registerNib(withIdentifierAndNibName: alarmLogTableViewCellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alarmLogTableViewCellIdentifier, for: indexPath) as! AlarmLogTableViewCell
        
        cell.setUIFor(deviceLog: deviceLogs[indexPath.row])
        
        return cell
    }
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- Public methods
    
    func read(responseDict: Dictionary<String,Any>) {
        
    }
}
