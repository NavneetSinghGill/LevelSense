//
//  NotificationsTableViewCell.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/26/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var extensionOuterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var extensionInnerView: UIView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var arrowButtonHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: IBAction methods
    
    @IBAction func openOrCollapse(sender: UIButton) {
        openOrCollapse()
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func deleteButtonTapped(sender: UIButton) {
        
    }
    
    //MARK: Public methods
    
    func openOrCollapse() {
        if extensionOuterViewHeightConstraint.constant == 0 {
            extensionOuterViewHeightConstraint.constant = extensionInnerView.frame.size.height
            updateArrowButton(forOpen: true)
            showHighlightEffect()
        } else {
            extensionOuterViewHeightConstraint.constant = 0
            updateArrowButton(forOpen: false)
        }
        
        let tableView: UITableView = (self.superview?.superview) as! UITableView
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //MARK: Private methods
    
    private func updateArrowButton(forOpen: Bool) {
        if forOpen {
            UIView.animate(withDuration: 0.3, animations: { 
                self.arrowButton.transform = CGAffineTransform.init(rotationAngle: 3.14)
                self.arrowButton.transform = CGAffineTransform.init(rotationAngle: 3.15)
                //Here two angle are set to control the rotation direction for open and close
            })
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.arrowButton.transform = CGAffineTransform.init(rotationAngle: 0)
            })
        }
    }
    
    func showHighlightEffect() {
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.layer.backgroundColor = veryLightblueColor.cgColor
        UIView.animate(withDuration: 0.3, animations: { 
            self.contentView.layer.backgroundColor = UIColor.white.cgColor
        }) { (isCompleted) in
            self.contentView.backgroundColor = UIColor.white
        }
    }
    
}
