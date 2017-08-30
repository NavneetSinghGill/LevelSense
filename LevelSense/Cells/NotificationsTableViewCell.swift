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
    
    //The array of service providers is in notification controller only and not in the cells so to fetch the data from that array these methods are used
    func openOptionScreenForCellAt(indexPath: IndexPath, andProviderName: String)
    func getProviderNameFor(code: String) -> String
    func getCodeFor(providerName: String) -> String
    func getProviderNameFor(index: Int) -> String
    func getCodeFor(index: Int) -> String
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
    
    @IBOutlet weak var superContentView: UIView!
    @IBOutlet weak var extensionInnerView: UIView!
    
    @IBOutlet weak var extensionOuterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellPhoneSuperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailSuperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowButtonHeightConstraint: NSLayoutConstraint!
    
    
    var delegate: NotificationCellProtocol!
    
    var indexPathOfCell: IndexPath!
    var isExpanded: Bool! = false
    
    var contact: Contact!
    
    var heightOfEmailSuperView: CGFloat!
    var heightOfCellPhoneSuperView: CGFloat!
    
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
        
        if areEntriesValid() {
            newContact.firstName = firstNameTextField.text
            newContact.lastName = lastNameTextField.text
            newContact.email = emailTextField.text
            newContact.mobile = cellPhoneNumberTextField.text
            newContact.enableStatus = enableButton.isSelected
            
            let providerName = serviceProviderLabel.text == "----" ? "" : serviceProviderLabel.text
            if providerName != "----" {
                newContact.cellProvider = delegate?.getCodeFor(providerName: providerName!)
            }
        
            delegate?.postEditOf(contact: newContact, ofIndexPath: indexPathOfCell)
        }
    }
    
    @IBAction private func deleteButtonTapped(sender: UIButton) {
        delegate?.delete?(contact: contact, atIndexPath: indexPathOfCell)
    }
    
    @IBAction private func serviceProviderButtonTapped(sender: UIButton) {
        delegate?.openOptionScreenForCellAt(indexPath: indexPathOfCell, andProviderName: serviceProviderLabel.text! == "----" ? "" : serviceProviderLabel.text!)
    }
    
    @IBAction private func enableButtonTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    //MARK: Selected option delegate methods
    
    func selectedOption(index: NSInteger, sender: Any?) {
        let providerName = delegate?.getProviderNameFor(index: index)
        serviceProviderLabel.text = providerName
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
            serviceProviderLabel.text = providerName.characters.count == 0 ? "----" : providerName
        }
        
        self.contact = contact
    }
    
    func areEntriesValid() -> Bool {
        var message: String = ""
        if firstNameTextField.text?.characters.count == 0 {
            message = "Pleaes enter first name"
        } else if lastNameTextField.text?.characters.count == 0 {
            message = "Pleaes enter last name"
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
    }
    
    func setUIForCellPhone() {
        emailSuperViewHeightConstraint.constant = 0
        cellPhoneSuperViewHeightConstraint.constant = heightOfCellPhoneSuperView
    }
    
    //MARK: Private methods
    
    private func updateArrowButton(forOpen: Bool, withAnimation: Bool) {
        let arrowAnimationBlock = {
            
            if forOpen {
                self.arrowButton.transform = CGAffineTransform.init(rotationAngle: 3.14)
                self.arrowButton.transform = CGAffineTransform.init(rotationAngle: 3.15)
                //Here two angle are set to control the rotation direction for open and close
                
            } else {
                self.arrowButton.transform = CGAffineTransform.init(rotationAngle: 0)
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
    
}
