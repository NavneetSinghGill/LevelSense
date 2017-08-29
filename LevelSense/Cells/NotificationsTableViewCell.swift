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
}

class NotificationsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enableButton: UIButton!
    
    @IBOutlet weak var superContentView: UIView!
    
    @IBOutlet weak var extensionOuterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var extensionInnerView: UIView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var arrowButtonHeightConstraint: NSLayoutConstraint!
    
    var delegate: NotificationCellProtocol!
    
    var indexPathOfCell: IndexPath!
    var isExpanded: Bool! = false
    
    var contact: Contact!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
            delegate?.postEditOf(contact: newContact, ofIndexPath: indexPathOfCell)
        }
    }
    
    @IBAction private func deleteButtonTapped(sender: UIButton) {
        delegate?.delete?(contact: contact, atIndexPath: indexPathOfCell)
    }
    
    //MARK: Public methods
    
    func setDetailsOf(contact: Contact) {
        nameLabel.text = "\(contact.firstName!) \(contact.lastName!)"
        firstNameTextField.text = "\(contact.firstName!)"
        lastNameTextField.text = "\(contact.lastName!)"
        emailTextField.text = "\(contact.email!)"
        
        self.contact = contact.copy()
    }
    
    func areEntriesValid() -> Bool {
        var message: String = ""
        if firstNameTextField.text?.characters.count == 0 {
            message = "Pleaes enter first name"
        } else if lastNameTextField.text?.characters.count == 0 {
            message = "Pleaes enter last name"
        } else if emailTextField?.text?.trim().characters.count == 0 {
            message = "Please enter email"
        } else if !(emailTextField?.text?.trim().isValidEmail())! {
            message = "Please enter a valid email"
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
