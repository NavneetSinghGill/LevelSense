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
    let addContactTableViewCellCellIdentifier = "AddContactTableViewCell"
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactSuperView: UIView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var contacts: [Contact] = []
    var serviceProviders: NSMutableArray = [ServiceProvider]() as! NSMutableArray
    var indexOfExpandedCell: Int! = -1
    var isAddContactActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuButton()
        setNavigationTitle(title: "NOTIFICATIONS")
        
        //Normal notification cell
        tableView.registerNib(withIdentifierAndNibName: notificationsTableViewCellIdentifier)
        //Add contact cell
        tableView.registerNib(withIdentifierAndNibName: addContactTableViewCellCellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh contacts")
        refreshControl.addTarget(self, action: #selector(NotificationsViewController.getContactsList), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        getContactsList()
    }
    
    //MARK: Private methods
    
    func getContactsList() {
        
        startAnimating()
        ContactRequestManager.getContactListAPICallWith { (success, response, error) in
            if success {
                
                self.getCellProviderList()
                
                let contactDicts = (response as! Dictionary<String, Any>)["contactList"] as? NSArray
                if contactDicts?.count != 0 {
                    self.contacts = Contact.getContactFromDictionaryArray(contactDictionaries: contactDicts!)
                    self.tableView.reloadData()
                }
            } else {
                self.stopAnimating()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    private func getCellProviderList() {
        ContactRequestManager.getCellProviderListAPICallWith { (success, response, error) in
            if success {
                
                let serviceProviderDicts = (response as! Dictionary<String, Any>)["cellProviderList"] as? NSArray
                if serviceProviderDicts?.count != 0 {
                    self.serviceProviders = ServiceProvider.getServiceProviderFromDictionaryArray(serviceProviderDictionaries: serviceProviderDicts!) as! NSMutableArray
                    self.tableView.reloadData()
                }
            }
            self.stopAnimating()
        }
    }
    
    //MARK: Notification cell delegate methods
    
    func openOptionScreenForCellAt(indexPath: IndexPath, currentValue: String, popupOf: Int, sender: Any?) {
        
        let optionVC : OptionSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController") as! OptionSelectionViewController
        optionVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        optionVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        optionVC.sender = sender
        
        if popupOf == 0 { //Service provider
            let cell: NotificationsTableViewCell = tableView.cellForRow(at: indexPath) as! NotificationsTableViewCell
            optionVC.delegate = cell;
            
            let names = serviceProviders.value(forKey: "name") as! NSArray
            optionVC.options = names
            optionVC.startIndex = names.index(of: currentValue)
        } else {
            let cell: NotificationsTableViewCell = tableView.cellForRow(at: indexPath) as! NotificationsTableViewCell
            optionVC.delegate = cell;
            
            optionVC.options = notificationOptionTypes
            optionVC.startIndex = notificationOptionTypes.index(of: currentValue)
        }
        
        present(optionVC, animated: true, completion: nil)

    }
    
    func getProviderNameFor(code: String) -> String {
        let providerCodes: NSArray = serviceProviders.value(forKey: "code") as! NSArray
        if providerCodes.count != 0 {
            let index: Int = providerCodes.index(of: code)
            let providerNames: NSArray = serviceProviders.value(forKey: "name") as! NSArray
            return providerNames.object(at: index) as! String
        }
        return ""
    }
    
    func getCodeFor(providerName: String) -> String {
        let providerNames: NSArray = serviceProviders.value(forKey: "name") as! NSArray
        if providerNames.count != 0 {
            let index: Int = providerNames.index(of: providerName)
            let providerCodes: NSArray = serviceProviders.value(forKey: "code") as! NSArray
            if index != Int.max {
                return providerCodes.object(at: index) as! String
            }
        }
        return ""
    }
    
    func getProviderNameFor(index: Int) -> String {
        let providerNames: NSArray = serviceProviders.value(forKey: "name") as! NSArray
        return providerNames.object(at: index) as! String
    }
    
    func getCodeFor(index: Int) -> String {
        let providerCodes: NSArray = serviceProviders.value(forKey: "code") as! NSArray
        return providerCodes.object(at: index) as! String
    }
    
    func delete(contact:Contact, atIndexPath: IndexPath) {
        
        startAnimating()
        ContactRequestManager.postDeleteContactAPICallWith(contact: contact) { (success, response, error) in
            if success {
                Banner.showSuccessWithTitle(title: "Contact deleted successfully")
                self.indexOfExpandedCell = -1
                let cell: NotificationsTableViewCell! = self.tableView.cellForRow(at: atIndexPath) as! NotificationsTableViewCell
                cell.openOrCollapseWith(shouldExpand: false, andShouldAnimateArrow: true)
                cell.updateTableView()
                
                self.contacts.remove(at: atIndexPath.row)
                self.tableView.deleteRows(at: [atIndexPath], with: UITableViewRowAnimation.top)
                self.tableView.reloadData()
            }
            self.stopAnimating()
        }
        
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
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        } else {
            indexOfExpandedCell = -1
            print("New index -1")
        }
    }
    
    func postEditOf(contact: Contact, ofIndexPath: IndexPath) {
        startAnimating()
        ContactRequestManager.postEditContactAPICallWith(contact: contact, block: { (success, response, error) in
            if success {
                Banner.showSuccessWithTitle(title: "Contact updated successfully")
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
    
    func postAddOf(contact: Contact, ofIndexPath: IndexPath) {
        
        startAnimating()
        ContactRequestManager.postAddContactAPICallWith(contact: contact, block: { (success, response, error) in
            if success {
                Banner.showSuccessWithTitle(title: "Contact added successfully")
                self.isAddContactActive = false
                self.getContactsList()
            } else {
                self.stopAnimating()
            }
        })
    }
    
    func refreshTableViewCellAt(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    func closeAddContact() {
        isAddContactActive = false
        self.tableView.reloadData()
    }
    
    func showDeletePopupFor(contact: Contact, atIndexPath: IndexPath) {
        let alertVC = UIAlertController.init(title: "Are you sure you want to delete this contact?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default) { (alertAction) in
            self.delete(contact: contact, atIndexPath: atIndexPath)
        }
        let noAction = UIAlertAction.init(title: "No", style: UIAlertActionStyle.default)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Tableview datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isAddContactActive {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contacts.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
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
        } else {
            let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: addContactTableViewCellCellIdentifier, for: indexPath) as! NotificationsTableViewCell
            cell.delegate = self
            cell.indexPathOfCell = indexPath
            cell.isAddContact = true
            cell.setupForAddContact()
            
            cell.openOrCollapseWith(shouldExpand: true, andShouldAnimateArrow: false)
            return cell
        }
        
    }
    
    //MARK: IBAction methods
    
    @IBAction func addContactButtonTapped(button: UIButton) {
        if !isAddContactActive {
            isAddContactActive = true
            tableView.reloadData()
            
            let index0Section1 = IndexPath.init(row: 0, section: 1)
            let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: addContactTableViewCellCellIdentifier, for: index0Section1) as! NotificationsTableViewCell
            cell.setupForAddContact()
            
            tableView.scrollToRow(at: index0Section1, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    //MARK:- Notification methods
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableViewBottomConstraint.constant = keyboardSize.size.height - self.addContactSuperView.frame.size.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant = 5
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
