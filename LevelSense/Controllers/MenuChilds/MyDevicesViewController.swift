//
//  MyDevicesViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/18/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class MyDevicesViewController: LSViewController, UITableViewDelegate, UITableViewDataSource {
    
    let alarmLogsLimit = 10
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomActionView: UIView!
    @IBOutlet weak var heightConstaintOfActionView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstaintOfActionView: NSLayoutConstraint!
    
    var refreshControl: UIRefreshControl!
    
    var currentSelectedIndex:IndexPath = IndexPath.init(row: -1, section: 0)
    var devices: [Device] = []
    var devicesLogs: Dictionary<String,Any>!
    
    let myDevicesTableViewCellIdentifier = "MyDevicesTableViewCell"

    var deviceData: Dictionary<String, Any>!
    
    var selectedDevice: Device?
    var selectedIndexPath: IndexPath?
    
    var alarmConfigAllData: Dictionary<String,Any>!
    var deviceDetail: Dictionary<String,Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        addMenuButton()
        setNavigationTitle(title: "MY DEVICES")
        tableView.registerNib(withIdentifierAndNibName: "MyDevicesTableViewCell")
     
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Devices")
        refreshControl.addTarget(self, action: #selector(MyDevicesViewController.getDevices), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
     
        //API
        getDevices()
        
        closeBottomViewWith(animation: false)
    }

    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myDevicesTableViewCellIdentifier, for: indexPath) as! MyDevicesTableViewCell
        
        cell.updateUIfor(device: devices[indexPath.row])
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
            selectedDevice = devices[indexPath.row]
            selectedIndexPath = indexPath
            
        } else if currentSelectedIndex.row == indexPath.row {
            
            //Deselect selected cell
            let cell = tableView.cellForRow(at: currentSelectedIndex) as! MyDevicesTableViewCell
                cell.changeViewIf(isSelected: false, withAnimation: true)
            currentSelectedIndex = IndexPath.init(row: -1, section: 0)
            closeBottomViewWith(animation: true)
            selectedDevice = nil
            selectedIndexPath = nil
            
        } else {
            
            //Deselect selected cell
            var cell = tableView.cellForRow(at: currentSelectedIndex) as? MyDevicesTableViewCell
            cell?.changeViewIf(isSelected: false, withAnimation: true)
            
            //Select new cell
            currentSelectedIndex = indexPath
            cell = tableView.cellForRow(at: currentSelectedIndex) as? MyDevicesTableViewCell
            cell?.changeViewIf(isSelected: true, withAnimation: true)
            selectedDevice = devices[indexPath.row]
            selectedIndexPath = indexPath
        }
        
    }
    
    //MARK:- Private methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graph" {
            let graphVC: GraphViewController = segue.destination as! GraphViewController
            graphVC.savedToTimeStamp = Int(Date().timeIntervalSince1970)
            let lastDay: Date! = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            graphVC.savedFromTimeStamp = Int(lastDay.timeIntervalSince1970)
            graphVC.allDeviceData = self.deviceData
            graphVC.device = (devices[currentSelectedIndex.row])
        } else if segue.identifier == "alarmConfig" {
            let alarmConfigVC: AlarmConfigViewController = segue.destination as! AlarmConfigViewController
            alarmConfigVC.alarmConfigAllData = alarmConfigAllData
        } else if segue.identifier == "deviceDetail" {
            let deviceDetailVC: DeviceDetailViewController = segue.destination as! DeviceDetailViewController
            deviceDetailVC.deviceDetail = deviceDetail
        } else if segue.identifier == "AlarmLogs" {
            let alarmLogsVC: AlarmLogViewController = segue.destination as! AlarmLogViewController
            let deviceLogList = self.devicesLogs?["LIST"] as? NSArray
            alarmLogsVC.deviceLogs = DeviceLog.getDeviceLogFromDictionaryArray(deviceLogDictionaries: deviceLogList!)
            alarmLogsVC.currentPage = 1
            alarmLogsVC.limit = alarmLogsLimit
            alarmLogsVC.deviceID = selectedDevice?.id
        }
    }
    
    func getDeviceDetails() {
        let id: String = (devices[currentSelectedIndex.row]).id
        
//        UserRequestManager.postGetDeviceAPICallWith(deviceID: id) { (success, response, error) in
//            if success {
//                self.deviceData = (((response as? Dictionary<String, Any>)!["device"]!) as? Dictionary<String,Any>)!["deviceData"] as! NSArray
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "graph", sender: self)
//                }
//            }
//        }
        
        let toTimestamp: Int! = Int(Date().timeIntervalSince1970)
        let lastDay: Date! = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let fromTimestamp: Int! = Int(lastDay.timeIntervalSince1970)
        
        startAnimating()
        UserRequestManager.postGetDeviceDataListAPICallWith(deviceID: id, limit: 100000, fromTimestamp: fromTimestamp, toTimestamp: toTimestamp) { (success, response, error) in
            if success {
                self.deviceData = (((response as? Dictionary<String, Any>)!["deviceDataList"]!) as? Dictionary<String,Any>)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "graph", sender: self)
                }
            }
            self.stopAnimating()
        }
    }
    
    func openBottomView() {
        UIView.animate(withDuration: kMyDevicesAnimationDuration) {
            self.bottomConstaintOfActionView.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBottomViewWith(animation: Bool) {
        UIView.animate(withDuration: animation ? kMyDevicesAnimationDuration : 0) {
            self.bottomConstaintOfActionView.constant = -self.heightConstaintOfActionView.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func getDevices() {
        selectedIndexPath = nil
        selectedDevice = nil
        currentSelectedIndex = IndexPath.init(row: -1, section: 0)
        closeBottomViewWith(animation: true)
        
        startAnimating()
        UserRequestManager.getDevicesAPICallWith() { (success, response, error) in
            if success {
                let deviceDicts = (response as! Dictionary<String, Any>)["deviceList"] as? NSArray
                if deviceDicts?.count != 0 {
                    self.devices = Device.getDevicesFromDictionaryArray(deviceDictionaries: deviceDicts!)
                    self.tableView.reloadData()
                }
            }
            self.stopAnimating()
            if self.devices.count == 0 {
                self.tableView.isHidden = true
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func deleteDeviceWithID(deviceID: String?) {
        if deviceID != nil && (deviceID?.characters.count)! > 0 {
            startAnimating()
            UserRequestManager.deleteDeviceAPICallWith(deviceID: deviceID!) { (success, response, error) in
                if success {
                    
                    self.devices.remove(at: (self.selectedIndexPath?.row)!)
                    self.tableView.deleteRows(at: [self.selectedIndexPath!], with: UITableViewRowAnimation.top)
                    self.tableView.reloadData()
                    
                    Banner.showSuccessWithTitle(title: "Device deleted successfully")
                }
                self.stopAnimating()
            }
        }
    }
    
    //MARK: IBAction methods
    
    @IBAction func deviceDetailButtonTapped() {
        if selectedDevice?.id != nil {
            startAnimating()
            UserRequestManager.postGetDeviceAPICallWith(deviceID: selectedDevice!.id) { (success, response, error) in
                if success {
                    let singleDeviceData = ((response as! Dictionary<String, Any>)["device"] as? Dictionary<String,Any>)
                    self.deviceDetail = singleDeviceData
                    
                    self.performSegue(withIdentifier: "deviceDetail", sender: self)
                }
                self.stopAnimating()
            }
        }
    }
    
    @IBAction func alarmConfigButtonTapped() {
        startAnimating()
        UserRequestManager.getAlarmConfigAPICallWith(deviceDict: ["id": selectedDevice?.id ?? ""]) { (success, response, error) in
            if success {
                if let responseDict = response as? Dictionary<String,Any> {
                    self.alarmConfigAllData = responseDict["device"] as? Dictionary<String,Any>
                    self.performSegue(withIdentifier: "alarmConfig", sender: self)
                }
            }
            self.stopAnimating()
        }
    }
    
    @IBAction func deleteDeviceButtonTapped() {
        
        let alertVC = UIAlertController.init(title: "Are you sure you want to delete this device?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default) { (alertAction) in
            self.deleteDeviceWithID(deviceID: self.selectedDevice?.id)
        }
        let noAction = UIAlertAction.init(title: "No", style: UIAlertActionStyle.default)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func alarmLogsButtonTapped() {
        startAnimating()
        let deviceDict: Dictionary<String,Any> = ["id": selectedDevice?.id ?? "", "currentPage": 1, "limit": alarmLogsLimit]
        
        UserRequestManager.getAlarmLogsAPICallWith(deviceDict: deviceDict) { (success, response, error) in
            if success {
                self.devicesLogs = ((response as! Dictionary<String, Any>)["deviceLogList"] as? Dictionary<String,Any>)
                let deviceLogList = self.devicesLogs?["LIST"] as? NSArray
                if deviceLogList?.count != 0 {
                    self.performSegue(withIdentifier: "AlarmLogs", sender: self)
                } else {
                    Banner.showFailureWithTitle(title: "No logs found")
                }
            }
            self.stopAnimating()
        }
    }
    
    @IBAction func graphButtonTapped() {
        getDeviceDetails()
    }
    
}
