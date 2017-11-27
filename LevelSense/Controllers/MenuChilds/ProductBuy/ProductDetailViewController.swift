//
//  ProductDetailViewController.swift
//  Level Sense
//
//  Created by Zoeb Sheikh on 11/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ProductDetailViewController: PaymentViewController {

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
        product.count = "1"
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
        
//        var cartItems: Array<Product>?
//        if let data = UserDefaults.standard.object(forKey: "savedCartItems") as? NSData {
//            let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
//            cartItems = unarc.decodeObject(forKey: "savedCartItems") as! Array<Product>
//        }
//
//        if cartItems == nil {
//            //No saved items, so just save the new items
//
//        } else {
//            //Add the new items to existing items
//        }
        
    }
    
    @IBAction func proceedToCheckoutButtonTapped() {
        
    }

}
