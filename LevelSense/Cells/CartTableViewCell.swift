//
//  CartTableViewCell.swift
//  Level Sense
//
//  Created by Navneet on 11/27/17.
//  Copyright © 2017 Navneet Singh. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUIfor(product: Product) {
        productNameLabel.text = product.name
        countLabel.text = "\(NumberFormatter().number(from: product.count!)!)"
        priceLabel.text = "\(NumberFormatter().number(from: product.price!)!.floatValue * NumberFormatter().number(from: product.count!)!.floatValue)"
    }
    
}
