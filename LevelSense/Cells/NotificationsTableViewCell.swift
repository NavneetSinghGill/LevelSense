//
//  NotificationsTableViewCell.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/26/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

@objc protocol NotificationCellProtocol {
    @objc optional func delete(contact:Contact, atIndexPath: IndexPath)
    @objc optional func cellExpandedWith(indexPath: IndexPath)
    
    func postEditOf(contact: Contact, ofIndexPath: IndexPath)
    func postAddOf(contact: Contact, ofIndexPath: IndexPath)
    
    //The array of service providers is in notification controller only and not in the cells so to fetch the data from that array these methods are used
    func openOptionScreenForCellAt(indexPath: IndexPath, currentValue: String, popupOf: Int, sender: Any?) // 0 for service provider and 1 for type
    func getProviderNameFor(code: String) -> String
    func getCodeFor(providerName: String) -> String
    func getProviderNameFor(index: Int) -> String
    func getCodeFor(index: Int) -> String
    
    func closeAddContact()
}

class NotificationsTableViewCell: UITableViewCell, SelectedOptionProtocol {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serviceProviderLabel: UILabel!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var providerArrowButton: UIButton!
    @IBOutlet weak var typeArrowButton: UIButton!
    
    @IBOutlet weak var superContentView: UIView!
    @IBOutlet weak var extensionInnerView: UIView!
    @IBOutlet weak var addContactBottomView: UIView!
    
    @IBOutlet weak var extensionOuterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellPhoneSuperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailSuperViewHeightConstraint: NSLayoutConstraint!
    
    let defaultProviderName = "----"
    
    
    var delegate: NotificationCellProtocol!
    
    var indexPathOfCell: IndexPath!
    var isExpanded: Bool! = false
    
    var contact: Contact!
    
    var heightOfEmailSuperView: CGFloat!
    var heightOfCellPhoneSuperView: CGFloat!
    
    var isAddContact: Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        heightOfEmailSuperView = emailSuperViewHeightConstraint.constant
        heightOfCellPhoneSuperView = cellPhoneSuperViewHeightConstraint.constant
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBAction methods
    
    @IBAction private func openOrCollapse(sender: UIButton) {
        openOrCollapseWith(shouldExpand: !isExpanded, andShouldAnimateArrow: true)
        updateTableView()
        delegate?.cellExpandedWith?(indexPath: indexPathOfCell)
    }
    
    @IBAction private func saveButtonTapped(sender: UIButton) {
        
        let newContact: Contact = contact.copy()
        
        if areEntriesValidForContact(contact: contact) {
            newContact.firstName = firstNameTextField.text
            newContact.lastName = lastNameTextField.text
            newContact.email = emailTextField.text
            newContact.mobile = cellPhoneNumberTextField.text
            newContact.enableStatus = enableButton.isSelected
            
            let providerName = serviceProviderLabel.text == defaultProviderName ? "" : serviceProviderLabel.text
            if providerName != defaultProviderName {
                newContact.cellProvider = delegate?.getCodeFor(providerName: providerName!)
            }
        
            delegate?.postEditOf(contact: newContact, ofIndexPath: indexPathOfCell)
        }
    }
    
    @IBAction private func deleteButtonTapped(sender: UIButton) {
        delegate?.delete?(contact: contact, atIndexPath: indexPathOfCell)
    }
    
    @IBAction private func serviceProviderButtonTapped(sender: UIButton) {
        delegate?.openOptionScreenForCellAt(indexPath: indexPathOfCell, currentValue: serviceProviderLabel.text! == defaultProviderName ? "" : serviceProviderLabel.text!, popupOf: 0, sender: sender)
    }
    
    @IBAction private func enableButtonTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    //MARK: Public methods
    
    func setDetailsOf(contact: Contact) {
        nameLabel.text = "\(contact.firstName!) \(contact.lastName!)"
        firstNameTextField.text = "\(contact.firstName!)"
        lastNameTextField.text = "\(contact.lastName!)"
        emailTextField.text = "\(contact.email!)"
        cellPhoneNumberTextField.text = "\(contact.mobile!)"
        
        if contact.smsActive {
            typeLabel.text = "Text message"
            setUIForCellPhone()
        } else {
            typeLabel.text = "Email"
            setUIForEmail()
        }
        
        enableButton.isSelected = contact.enableStatus == true
        
        if contact.smsActive {
            let providerName: String = (delegate?.getProviderNameFor(code: contact.cellProvider!))!
            serviceProviderLabel.text = providerName.characters.count == 0 ? defaultProviderName : providerName
        }
        
        self.contact = contact
    }
    
    func areEntriesValidForContact(contact: Contact) -> Bool {
        var message: String = ""
        if firstNameTextField.text?.characters.count == 0 {
            message = "Please enter first name"
        }
        if !contact.smsActive {
            if emailTextField?.text?.trim().characters.count == 0 {
                message = "Please enter email"
            } else if !(emailTextField?.text?.trim().isValidEmail())! {
                message = "Please enter a valid email"
            }
        }
        
        if message.characters.count != 0 {
            Banner.showFailureWithTitle(title: message)
            return false
        }
        return true
    }
    
    func openOrCollapseWith(shouldExpand: Bool, andShouldAnimateArrow: Bool) {
        if shouldExpand {
            extensionOuterViewHeightConstraint.constant = extensionInnerView.frame.size.height
            updateArrowButton(forOpen: true, withAnimation: andShouldAnimateArrow)
            showHighlightEffect()
        } else {
            extensionOuterViewHeightConstraint.constant = 0
            updateArrowButton(forOpen: false, withAnimation: andShouldAnimateArrow)
        }
        isExpanded = shouldExpand
    }
    
    func updateTableView() {
        if self.superview?.superview != nil {
            let tableView: UITableView = (self.superview?.superview) as! UITableView
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func setUIForEmail() {
        cellPhoneSuperViewHeightConstraint.constant = 0
        emailSuperViewHeightConstraint.constant = heightOfEmailSuperView
        cellPhoneNumberTextField.text = ""
        serviceProviderLabel.text = defaultProviderName
    }
    
    func setUIForCellPhone() {
        emailSuperViewHeightConstraint.constant = 0
        cellPhoneSuperViewHeightConstraint.constant = heightOfCellPhoneSuperView
        emailTextField.text = ""
    }
    
    //MARK: Private methods
    
    private func updateArrowButton(forOpen: Bool, withAnimation: Bool) {
        let arrowAnimationBlock = {
            
            if forOpen {
                self.arrowButton?.transform = CGAffineTransform.init(rotationAngle: 3.14)
                self.arrowButton?.transform = CGAffineTransform.init(rotationAngle: 3.15)
                //Here two angle are set to control the rotation direction for open and close
                
            } else {
                self.arrowButton?.transform = CGAffineTransform.init(rotationAngle: 0)
            }
            
        }
        
        if withAnimation {
            UIView.animate(withDuration: 0.3, animations: {
                arrowAnimationBlock()
            })
        } else {
            arrowAnimationBlock()
        }
    }
    
    func showHighlightEffect() {
        self.superContentView.backgroundColor = UIColor.clear
        self.superContentView.layer.backgroundColor = veryLightblueColor.cgColor
        UIView.animate(withDuration: 0.3, animations: { 
            self.superContentView.layer.backgroundColor = UIColor.white.cgColor
        }) { (isCompleted) in
            self.superContentView.backgroundColor = UIColor.white
        }
    }
    
    func scrollToIndexPath(indexPath: IndexPath, withAnimation: Bool) {
        if self.superview?.superview != nil {
            let tableView: UITableView = (self.superview?.superview) as! UITableView
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: withAnimation)
        }
    }
    
    //MARK: Selected option delegate methods
    
    func selectedOption(index: NSInteger, sender: Any?) {
        if sender as? UIButton == typeArrowButton {
            typeLabel.text = notificationOptionTypes.object(at: index) as? String
            if index == 0 {
                setUIForEmail()
            } else {
                setUIForCellPhone()
            }
            UIView.animate(withDuration: 0.3, animations: { 
                self.layoutIfNeeded()
            })
            extensionOuterViewHeightConstraint.constant = extensionInnerView.frame.size.height
            updateTableView()
            scrollToIndexPath(indexPath: indexPathOfCell, withAnimation: true)
        } else if sender as? UIButton == providerArrowButton {
            let providerName = delegate?.getProviderNameFor(index: index)
            serviceProviderLabel.text = providerName
        }
    }
    
    //MARK:- Add Contact
    
    func setupForAddContact() {
        typeLabel.text = notificationOptionTypes.firstObject as? String
        setUIForEmail()
    }
    
    @IBAction private func cancelButtonTapped(button: UIButton) {
        extensionOuterViewHeightConstraint.constant = 0
        updateTableView()
        delegate?.closeAddContact()
    }
    
    @IBAction private func addButtonTapped(button: UIButton) {
        let newContact: Contact = Contact()
        
        newContact.emailActive = emailTextField.text?.characters.count != 0
        newContact.smsActive = cellPhoneNumberTextField.text?.characters.count != 0
        
        if areEntriesValidForContact(contact: newContact) {
            newContact.firstName = firstNameTextField.text
            newContact.lastName = lastNameTextField.text
            newContact.email = emailTextField.text
            newContact.mobile = cellPhoneNumberTextField.text
            newContact.enableStatus = enableButton.isSelected
            
            let providerName = serviceProviderLabel.text == defaultProviderName ? "" : serviceProviderLabel.text
            if providerName != "" {
                newContact.cellProvider = delegate?.getCodeFor(providerName: providerName!)
            }
            
            delegate?.postAddOf(contact: newContact, ofIndexPath: indexPathOfCell)
        }
    }
    
    @IBAction private func typeButtonTapped(button: UIButton) {
        delegate?.openOptionScreenForCellAt(indexPath: indexPathOfCell, currentValue: typeLabel.text! == defaultProviderName ? "" : typeLabel.text!, popupOf: 1, sender: button)
    }
    
}
