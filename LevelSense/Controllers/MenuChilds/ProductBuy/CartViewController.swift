//
//  CartViewController.swift
//  Level Sense
//
//  Created by Zoeb Sheikh on 11/24/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class CartViewController: PaymentViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView!

    var products : Array<Product>?
    
    let cartTableViewCellTableViewCellIdentifier = "CartTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "PROCEED TO CHECKOUT")
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

}
