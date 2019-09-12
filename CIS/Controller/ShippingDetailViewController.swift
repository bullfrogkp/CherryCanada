//
//  ShippingDetailViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-10.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ShippingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shippingDateLabel: UILabel!
    @IBOutlet weak var shippingStatusLabel: UILabel!
    @IBOutlet weak var shippingCityLabel: UILabel!
    @IBOutlet weak var shippingPriceNationalLabel: UILabel!
    @IBOutlet weak var shippingPriceInternationalLabel: UILabel!
    @IBOutlet weak var shippingDepositLabel: UILabel!
    @IBOutlet weak var shippingCommentLabel: UILabel!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBOutlet var scrollView: UIScrollView!
    var shipping: Shipping!
    var shippings: [Shipping]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        shippingDateLabel.text = dateFormatterPrint.string(from: shipping!.shippingDate)
        shippingStatusLabel.text = shipping.shippingStatus
        shippingCityLabel.text = shipping.city
        shippingPriceNationalLabel.text = "\(shipping.priceNational)"
        shippingPriceInternationalLabel.text = "\(shipping.priceInternational)"
        shippingDepositLabel.text = "\(shipping.deposit)"
        shippingCommentLabel.text = "\(shipping.comment)"
        
        customerItemTableView.dataSource = self
        customerItemTableView.delegate = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        var pageData = [Customer]
        var customers = [Customer]
        var images = [ItemImage]
        var itemFoundInCustomer = false
        var itemFoundInImage = false
        
        for item in shipping.items {
            itemFoundInCustomer = false
            for customer in customers {
                if(customer === item.customer) {
                    customer.items.append(item)
                    itemFoundInCustomer = true
                    break
                }
            }
            
            if(itemFoundInCustomer == false) {
                customers.append(item.customer)
            }
            
            itemFoundInImage = false
            for image in images {
                if(image === item.image) {
                    images.items.append(item)
                    itemFoundInImage = true
                    break
                }
            }
            
            if(itemFoundInImage == false) {
                images.append(item.image)
            }
        }
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
            let shippingView: ShippingInfoViewController = naviView.viewControllers[0] as! ShippingInfoViewController
            shippingView.shipping = shipping
            shippingView.shippings = shippings
        } else if segue.identifier == "showCustomerDetail" {
            
            let items1: [Item] = [
                Item(comment: "Item1", image: "test", name: "货物1", priceBought: 1.00, priceSold: 2.00, quantity: 3),
                Item(comment: "Item2", image: "test2", name: "货物2", priceBought: 2.00, priceSold: 3.00, quantity: 5),
            ]
            
            let items2: [Item] = [
                Item(comment: "Item1", image: "test2", name: "大货物1", priceBought: 10.00, priceSold: 22.00, quantity: 1)
            ]
            
            let images1 = [
                ItemImage(name: "test", items: items1),
                ItemImage(name: "test2", items: items2)
            ]
            
            if let indexPath = customerItemTableView.indexPathForSelectedRow {
                let customer = shipping.customers[indexPath.row]
                var pageData = CustomerItemData()
                
                pageData.customerName = customer.name
                pageData.images = images1
                
                let destinationController = segue.destination as! CustomerItemViewController
                destinationController.pageData = pageData
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shipping.customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerId", for: indexPath as IndexPath) as! CustomerListTableViewCell
        
        let customerDetail = shipping.customers[indexPath.row]
        var itemsTextArrar = [String]()
        
        cell.customerNameLabel.text = customerDetail.name
        
        for item in customerDetail.items {
            itemsTextArrar.append("\(item.name) [\(item.quantity)]")
        }
        
        cell.customerItemsLabel.numberOfLines = 0
        cell.customerItemsLabel.attributedText = bulletPointList(strings: itemsTextArrar)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]
        
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")
        
        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }
}
