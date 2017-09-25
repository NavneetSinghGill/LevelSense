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
    var deviceID: String!
    var currentPage: Int!
    var limit: Int!
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        setNavigationTitle(title: "ALARM LOGS")
        
        //Normal notification cell
        tableView.registerNib(withIdentifierAndNibName: alarmLogTableViewCellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh logs")
        refreshControl.addTarget(self, action: #selector(AlarmLogViewController.getLogsList), for: UIControlEvents.valueChanged)
        tableView.bottomRefreshControl = refreshControl
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
    
    //MARK:- Private methods
    
    func getLogsList() {
        
        let deviceDict: Dictionary<String,Any> = ["id": deviceID ?? "", "currentPage": currentPage + 1, "limit": limit]
        
        UserRequestManager.getAlarmLogsAPICallWith(deviceDict: deviceDict) { (success, response, error) in
            if success {
                let devicesLogs = ((response as! Dictionary<String, Any>)["deviceLogList"] as? Dictionary<String,Any>)
                let deviceLogList = devicesLogs?["LIST"] as? NSArray
                
                if deviceLogList?.count != 0 {
                    self.deviceLogs.append(contentsOf: DeviceLog.getDeviceLogFromDictionaryArray(deviceLogDictionaries: deviceLogList!))
                    self.tableView.reloadData()
                    self.currentPage = self.currentPage + 1
                } else {
                    Banner.showFailureWithTitle(title: "No more logs found")
                }
            }
            self.refreshControl.endRefreshing()
        }
        
    }
}
