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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shippingDateLabel.text = "\(shipping.shippingDate)"
        shippingStatusLabel.text = shipping.shippingStatus
        shippingCityLabel.text = shipping.city
        shippingPriceNationalLabel.text = "\(shipping.priceNational)"
        shippingPriceInternationalLabel.text = "\(shipping.priceInternational)"
        shippingDepositLabel.text = "\(shipping.deposit)"
        shippingCommentLabel.text = "\(shipping.comment)"
        
        customerItemTableView.dataSource = CustomerListTableViewController()
        customerItemTableView.delegate = CustomerListTableViewController()
    }
}
