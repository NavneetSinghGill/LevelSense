//
//  NotificationsViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class NotificationsViewController: LSViewController, UITableViewDataSource, UITableViewDelegate {

    let notificationsTableViewCellIdentifier = "NotificationsTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactSuperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuButton()
        setNavigationTitle(title: "NOTIFICATIONS")
        
        tableView.registerNib(withIdentifierAndNibName: notificationsTableViewCellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
//        addContactSuperView.layer.cornerRadius = 5
//        addContactSuperView.layer.masksToBounds = false
//        addContactSuperView.layer.shadowOffset = CGSize.init(width: -5, height: 2)
//        addContactSuperView.layer.shadowRadius = 5
//        addContactSuperView.layer.shadowOpacity = 0.5
    }
    
    //MARK: Tableview datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationsTableViewCellIdentifier, for: indexPath)

        
        
        return cell
        
    }

    //MARK: Tableview delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell: NotificationsTableViewCell = tableView.cellForRow(at: indexPath) as! NotificationsTableViewCell

    }
}
