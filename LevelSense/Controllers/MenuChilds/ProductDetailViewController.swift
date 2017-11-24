//
//  ProductDetailViewController.swift
//  Level Sense
//
//  Created by Zoeb Sheikh on 11/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ProductDetailViewController: LSViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var price1Label: UILabel!
    @IBOutlet weak var price2Label: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var countToBuyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var product: Product!
    var countToBuy: Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        addCartButton()
        setNavigationTitle(title: "\(product.name ?? "Product detail")")

        setUI(with: product)
    }
    
    //MARK:- Private methods
    
    func setUI(with: Product) {
        nameLabel.text = product.name ?? ""
        descriptionLabel.text = product.desc ?? ""
        price1Label.text = "\(product.price ?? "0")\(product.currency ?? "")"
        price2Label.text = "\(product.price ?? "0")\(product.currency ?? "")"
        finalPriceLabel.text = "\(product.price ?? "0")\(product.currency ?? "")"
        countToBuy = 1
        countToBuyLabel.text = "1"
    }
    
    func setCount(to: Float) {
        countToBuy = to
        countToBuyLabel.text = "\(Int(countToBuy))"
        finalPriceLabel.text = "\(countToBuy * Float(product.price ?? "0")!)\(product.currency ?? "")"
    }
    
    //MARK:- IBAction methods
    
    @IBAction func increaseCountToBuyButtonTapped() {
        setCount(to: countToBuy + 1)
    }
    
    @IBAction func decreaseCountToBuyButtonTapped() {
        if countToBuy >= 2 {
            setCount(to: countToBuy - 1)
        }
    }
    
    @IBAction func addToCartButtonTapped() {
        
    }
    
    @IBAction func proceedToCheckoutButtonTapped() {
        
    }

}
