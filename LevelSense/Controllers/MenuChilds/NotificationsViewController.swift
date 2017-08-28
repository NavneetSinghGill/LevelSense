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
    var contacts: [Contact] = []
    
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
        
        getContactsList()
    }
    
    //MARK: Private methods
    
    private func getContactsList() {
        
        startAnimating()
        ContactRequestManager.getContactListAPICallWith { (success, response, error) in
            if success {
                let contactDicts = (response as! Dictionary<String, Any>)["contactList"] as? NSArray
                if contactDicts?.count != 0 {
                    self.contacts = Contact.getContactFromDictionaryArray(contactDictionaries: contactDicts!)
                    self.tableView.reloadData()
                }
            }
            self.stopAnimating()
        }
    }
    
    //MARK: Tableview datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: notificationsTableViewCellIdentifier, for: indexPath) as! NotificationsTableViewCell

        cell.setDetailsOf(contact: contacts[indexPath.row])
        
        return cell
        
    }

    //MARK: Tableview delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell: NotificationsTableViewCell = tableView.cellForRow(at: indexPath) as! NotificationsTableViewCell

    }
}
