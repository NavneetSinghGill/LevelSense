//
//  ProductsViewController.swift
//  Level Sense
//
//  Created by Zoeb Sheikh on 11/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ProductsViewController: LSViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var products : [Product] = []
    
    let productsTableViewCellTableViewCellIdentifier = "ProductsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuButton()
        setNavigationTitle(title: "PRODUCTS")
        tableView.registerNib(withIdentifierAndNibName: "ProductsTableViewCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Products")
        refreshControl.addTarget(self, action: #selector(ProductsViewController.getProducts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        getProducts()
        
        let pr = Product()
        pr.name = "asd"
        pr.price = "10"
        pr.currency = "$"
        pr.desc = "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum \n \n Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum"
        products.append(pr)
        tableView.reloadData()
    }
    
    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productsTableViewCellTableViewCellIdentifier, for: indexPath) as! ProductsTableViewCell
        
        cell.updateUIfor(product: products[indexPath.row])
        
        return cell
    }
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openProductDetailsWith(product: self.products[indexPath.row])
    }
    
    //MARK:- Private methods
    
    func openProductDetailsWith(product: Product) {
        let productDetailViewController : ProductDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailViewController.product = product
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    func getProducts() {
        refreshControl.endRefreshing()
    }

}
