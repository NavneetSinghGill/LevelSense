//
//  NotificationsViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class NotificationsViewController: LSViewController, UITableViewDataSource, UITableViewDelegate, NotificationCellProtocol {

    let notificationsTableViewCellIdentifier = "NotificationsTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactSuperView: UIView!
    var contacts: [Contact] = []
    var indexOfExpandedCell: Int! = -1
    
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
    
    //MARK: Notification cell delegate methods
    
    func deleteCellAt(indexPath: IndexPath) {
        indexOfExpandedCell = -1
        let cell: NotificationsTableViewCell! = tableView.cellForRow(at: indexPath) as! NotificationsTableViewCell
        cell.openOrCollapseWith(shouldExpand: false, andShouldAnimateArrow: true)
        cell.updateTableView()
        
        contacts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
        tableView.reloadData()
    }
    
    func cellExpandedWith(indexPath: IndexPath) {
        if indexOfExpandedCell != -1 && indexOfExpandedCell != indexPath.row {
            //Close previous expanded cell and ignore if same cell is called
            let previousExpandedCell = self.tableView.cellForRow(at: IndexPath.init(row: indexOfExpandedCell, section: 0))
            if previousExpandedCell != nil {
                let cell: NotificationsTableViewCell! = previousExpandedCell as! NotificationsTableViewCell
                cell.openOrCollapseWith(shouldExpand: false, andShouldAnimateArrow: true)
                cell.updateTableView()
            }
            print("Cell close with index: \(indexOfExpandedCell)")
        }
        if indexOfExpandedCell != indexPath.row {
            indexOfExpandedCell = indexPath.row
            print("New index: \(indexOfExpandedCell)")
        } else {
            indexOfExpandedCell = -1
            print("New index -1")
        }
    }
    
    func postEditOf(contact: Contact, ofIndexPath: IndexPath) {
        startAnimating()
        ContactRequestManager.postEditContactAPICallWith(contact: contact, block: { (success, response, error) in
            if success {
                Banner.showSuccessWithTitle(title: "Contact updated")
                self.contacts[ofIndexPath.row] = contact
                self.indexOfExpandedCell = -1
                
                //Update cell data and its UI
                DispatchQueue.main.async {
                    let cell: NotificationsTableViewCell = self.tableView.cellForRow(at: ofIndexPath) as! NotificationsTableViewCell
                    cell.openOrCollapseWith(shouldExpand: false, andShouldAnimateArrow: true)
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                    cell.setDetailsOf(contact: contact)
                }
            }
            self.stopAnimating()
        })
    }
    
    //MARK: Tableview datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: notificationsTableViewCellIdentifier, for: indexPath) as! NotificationsTableViewCell
        
        cell.delegate = self
        cell.indexPathOfCell = indexPath
        cell.setDetailsOf(contact: contacts[indexPath.row])
        print("\(indexPath.row)")
        
        if indexOfExpandedCell == indexPath.row {
            cell.openOrCollapseWith(shouldExpand: true, andShouldAnimateArrow: false)
        } else {
            cell.openOrCollapseWith(shouldExpand: false, andShouldAnimateArrow: false)
        }
        
        return cell
        
    }
}
