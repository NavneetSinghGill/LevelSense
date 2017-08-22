//
//  MyDevicesTableViewCell.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/22/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class MyDevicesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeViewIf(isSelected:Bool) {
        if isSelected {
            UIView.animate(withDuration: kMyDevicesAnimationDuration, animations: { 
                self.selectionView.layer.backgroundColor = myDevicesCellBackgroundSelectionColor.cgColor
            })
        } else {
            UIView.animate(withDuration: kMyDevicesAnimationDuration, animations: {
                self.selectionView.layer.backgroundColor = UIColor.white.cgColor
            })
        }
    }
    
}
