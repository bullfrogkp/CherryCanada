//
//  ShippingDetailTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-06.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ShippingDetailTableViewController: UITableViewController {
    @IBOutlet weak var shippingDateLabel: UILabel!
    @IBOutlet weak var shippingStatusLabel: UILabel!
    @IBOutlet weak var shippingCityLabel: UILabel!
    @IBOutlet weak var shippingPriceNationalLabel: UILabel!
    @IBOutlet weak var shippingPriceInternationalLabel: UILabel!
    @IBOutlet weak var shippingDepositLabel: UILabel!
    @IBOutlet weak var shippingCommentLabel: UILabel!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    var shipping: Shipping!
    var shippings: [Shipping]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shippingDateLabel.text = "\(shipping.shippingDate)"
        shippingStatusLabel.text = shipping.shippingStatus
        shippingCityLabel.text = shipping.city
        shippingPriceNationalLabel.text = "\(shipping.priceNational)"
        shippingPriceInternationalLabel.text = "\(shipping.priceInternational)"
        shippingDepositLabel.text = "\(shipping.deposit)"
        shippingCommentLabel.text = "\(shipping.comment)"
        
        var customerListController = CustomerListTableViewController()
        customerListController.shipping = shipping
        
        customerItemTableView.dataSource = customerListController
        customerItemTableView.delegate = customerListController
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomer" {
            var pageData = CustomerItemData()
            
            pageData.customerName = ""
            pageData.images = []
            
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let customerView: CustomerItemEditViewController = naviView.viewControllers[0] as! CustomerItemEditViewController
            
            customerView.pageData = pageData
        } else if segue.identifier == "editShippingDetail" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let shippingView: ShippingDetailViewController = naviView.viewControllers[0] as! ShippingDetailViewController
            shippingView.shipping = shipping
            shippingView.shippings = shippings
        }
    }
}
