//
//  CartViewController.swift
//  Level Sense
//
//  Created by Zoeb Sheikh on 11/24/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit
import PassKit

class CartViewController: LSViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView!

    var products : Array<Product>?
    
    let cartTableViewCellTableViewCellIdentifier = "CartTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        addPayButton()
        setNavigationTitle(title: "CHECKOUT")
        itemsTableView.registerNib(withIdentifierAndNibName: cartTableViewCellTableViewCellIdentifier)
        
        itemsTableView.reloadData()
    }
    
    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cartTableViewCellTableViewCellIdentifier, for: indexPath) as! CartTableViewCell
        
        cell.updateUIfor(product: products![indexPath.row])
        
        return cell
    }
    
    //MARK:- Private methods
    
    func addPayButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = .clear
        button.setTitle("Pay", for: .normal)
        
        button.setTitleColor(blueColor, for: .normal)
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func payButtonTapped() {
        var total = NSDecimalNumber(string: "0")
        var items = Array<PKPaymentSummaryItem>()
        
        for product in products! {
            let item = PKPaymentSummaryItem(label: "\(NumberFormatter().number(from: product.count!)!)" + " x " + product.name!, amount: NSDecimalNumber(string: product.price!))
           total = total.adding( NSDecimalNumber(string: product.price!).multiplying(by: NSDecimalNumber(string: product.count!)))
            items.append(item)
        }
        let totalItem = PKPaymentSummaryItem(label: "Total", amount: total)
        items.append(totalItem)
        
        openApplePayScreen(with: items)
    }

}
