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
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    var shipping: Shipping!
    var customers: [Customer] = []
    var cellIndex: Int!
    var shippingListTableViewController: ShippingListTableViewController!
    
    @IBAction func deleteShipping(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "操真的删除吗?", preferredStyle: .actionSheet)
        
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let checkInAction = UIAlertAction(title: "删除　", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.shipping.active = false
            self.shippingListTableViewController.deleteCell(rowIndex: self.cellIndex)
            
            self.navigationController?.popViewController(animated: true)
        })
        optionMenu.addAction(checkInAction)
        
        // Display the menu
        present(optionMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cellIndex != -1 {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            
            shippingDateLabel.text = dateFormatterPrint.string(from: shipping.shippingDate)
            shippingStatusLabel.text = shipping.shippingStatus
            shippingCityLabel.text = shipping.city
            shippingPriceNationalLabel.text = "\(shipping.priceNational)"
            shippingPriceInternationalLabel.text = "\(shipping.priceInternational)"
            shippingDepositLabel.text = "\(shipping.deposit)"
            shippingCommentLabel.text = "\(shipping.comment)"
        } else {
            deleteButton.isHidden = true
            
            shippingDateLabel.text = ""
            shippingStatusLabel.text = ""
            shippingCityLabel.text = ""
            shippingPriceNationalLabel.text = ""
            shippingPriceInternationalLabel.text = ""
            shippingDepositLabel.text = ""
            shippingCommentLabel.text = ""
        }
        customerItemTableView.dataSource = self
        customerItemTableView.delegate = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        var foundCustomer = false
        var foundImage = false
        
        for item in shipping.items {
            foundCustomer = false
            for customer in customers {
                if(customer === item.customer) {
                    foundImage = false
                    for image in customer.images {
                        if(image === item.image) {
                            image.items.append(item)
                            foundImage = true
                            break
                        }
                    }
                    
                    if(foundImage == false) {
                        let image = Image()
                        image.name = item.image.name
                        image.items.append(item)
                        customer.images.append(image)
                    }
                    
                    foundCustomer = true
                    break
                }
            }
            
            if(foundCustomer == false) {
                let customer = Customer()
                customer.name = item.customer.name
                
                let image = Image()
                image.name = item.image.name
                image.items.append(item)
                customer.images.append(image)
                
                customers.append(customer)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomer" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let customerView: CustomerItemEditViewController = naviView.viewControllers[0] as! CustomerItemEditViewController
            
            customerView.customer = Customer()
            customerView.cellIndex = -1
            customerView.shippingDetailViewController = self
        } else if segue.identifier == "editShippingDetail" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let shippingView: ShippingInfoViewController = naviView.viewControllers[0] as! ShippingInfoViewController
            shippingView.shipping = shipping
        } else if segue.identifier == "showCustomerDetail" {
            if let indexPath = customerItemTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CustomerItemViewController
                destinationController.customer = customers[indexPath.row]
                destinationController.cellIndex = indexPath.row
                destinationController.shippingDetailViewController = self
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerId", for: indexPath as IndexPath) as! CustomerListTableViewCell
        
        let customerDetail = customers[indexPath.row]
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
    
    func deleteCell(rowIndex: Int) {
        customers.remove(at: rowIndex)
        customerItemTableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
}
