//
//  NotificationsTableViewCell.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/26/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

@objc protocol NotificationCellProtocol {
    @objc optional func deleteCellAt(indexPath: IndexPath)
    @objc optional func cellExpandedWith(indexPath: IndexPath)
}

class NotificationsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameTextField: UITextField!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: IBAction methods
    
    @IBAction private func openOrCollapse(sender: UIButton) {
        openOrCollapseWith(shouldExpand: !isExpanded, andShouldAnimateArrow: true)
        updateTableView()
        delegate?.cellExpandedWith?(indexPath: indexPathOfCell)
    }
    
    @IBAction private func saveButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction private func deleteButtonTapped(sender: UIButton) {
        delegate?.deleteCellAt?(indexPath: IndexPath.init(row: indexPathOfCell.row, section: 0))
    }
    
    //MARK: Public methods
    
    func setDetailsOf(contact: Contact) {
        nameLabel.text = "\(contact.firstName!) \(contact.lastName!)"
        nameTextField.text = "\(contact.firstName!) \(contact.lastName!)"
        emailTextField.text = "\(contact.email!)"
        
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
