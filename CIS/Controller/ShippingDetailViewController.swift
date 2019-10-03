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
    var cellIndex: Int!
    var shippingListTableViewController: ShippingListTableViewController!
    
    @IBAction func deleteShipping(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "操真的删除吗?", preferredStyle: .actionSheet)
        
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let checkInAction = UIAlertAction(title: "删除　", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.shippingListTableViewController.deleteCell(rowIndex: self.cellIndex)
            
            self.navigationController?.popViewController(animated: true)
        })
        optionMenu.addAction(checkInAction)
        
        // Display the menu
        present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveData(){
        dismiss(animated: true, completion: nil)
    }
    
//    func setNavigationBar() {
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
//        let navItem = UINavigationItem(title: "新货单")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(done))
//        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(cancel))
//        navItem.rightBarButtonItem = doneItem
//        navItem.leftBarButtonItem = doneItem
//        navBar.setItems([navItem], animated: false)
//        self.view.addSubview(navBar)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.dataSource = self
        customerItemTableView.delegate = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        if shipping != nil {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            
            shippingDateLabel.text = dateFormatterPrint.string(from: shipping!.shippingDate)
            shippingStatusLabel.text = shipping!.shippingStatus
            shippingCityLabel.text = shipping!.city
            shippingPriceNationalLabel.text = "\(shipping!.priceNational)"
            shippingPriceInternationalLabel.text = "\(shipping!.priceInternational)"
            shippingDepositLabel.text = "\(shipping!.deposit)"
            shippingCommentLabel.text = "\(shipping!.comment)"
        } else {
            deleteButton.isHidden = true
            
            let screenSize: CGRect = UIScreen.main.bounds
            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
            let navItem = UINavigationItem(title: "新货单")
            let backButton = UIBarButtonItem(title: "返回", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            let saveButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveData))
            navItem.leftBarButtonItem = backButton
            navItem.rightBarButtonItem = saveButton
            navBar.setItems([navItem], animated: false)
            navBar.isTranslucent = false
            self.view.addSubview(navBar)
            
            shippingDateLabel.text = ""
            shippingStatusLabel.text = ""
            shippingCityLabel.text = ""
            shippingPriceNationalLabel.text = ""
            shippingPriceInternationalLabel.text = ""
            shippingDepositLabel.text = ""
            shippingCommentLabel.text = ""
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomer" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let customerView: CustomerItemEditViewController = naviView.viewControllers[0] as! CustomerItemEditViewController
            
            customerView.shippingDetailViewController = self
        } else if segue.identifier == "editShippingDetail" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let shippingView: ShippingInfoViewController = naviView.viewControllers[0] as! ShippingInfoViewController
            shippingView.shipping = shipping
            shippingView.shippingDetailViewController = self
        } else if segue.identifier == "showCustomerDetail" {
            if let indexPath = customerItemTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CustomerItemViewController
                
                let selectedCustomer = shipping.customers[indexPath.row]
                let customer = Customer()
                customer.name = selectedCustomer.name
                
                customer.images = selectedCustomer.images
                
                for item in shipping.items {
                    if(selectedCustomer === item.customer) {
                        for image in customer.images {
                            if(image === item.image) {
                                image.items.append(item)
                                break
                            }
                        }
                    }
                }
                
                destinationController.customer = customer
                destinationController.customerIndex = indexPath.row
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
    
    func deleteCell(rowIndex: Int) {
        for (idx, itm) in shipping.items.enumerated() {
            if(itm.customer === shipping.customers[rowIndex]) {
                shipping.items.remove(at: idx)
            }
        }
        
        shipping.customers.remove(at: rowIndex)
        customerItemTableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
    
    func clearItems(customer: Customer) {
        //Remove shipping items
        for (idx, itm) in shipping.items.enumerated() {
            if itm.customer === customer {
                shipping.items.remove(at: idx)
            }
        }
        
        for cimg in customer.images {
            for (idx, img) in shipping.images.enumerated() {
                if(cimg === img && img.customers.count == 1) {
                    shipping.images.remove(at: idx)
                    break
                }
            }
        }
        
        //Remove customer items
       customer.items.removeAll()
       customer.images.removeAll()
    }
    
    func addImage(_ image: Image) {
        shipping.images.append(image)
    }
    
    func addItem(_ item: Item) {
        shipping.items.append(item)
    }
    
    func addCustomer(customer: Customer) {
        shipping.customers.insert(customer, at: 0)
        customerItemTableView.reloadData()
//        let insertionIndexPath = NSIndexPath(row: 0, section: 0)
//        customerItemTableView.insertRows(at: [insertionIndexPath as IndexPath], with: .top)
    }
    
    func updateShipping(_ sp: Shipping) {
        shipping.city = sp.city
        shipping.comment = sp.comment
        shipping.deposit = sp.deposit
        shipping.priceInternational = sp.priceInternational
        shipping.priceNational = sp.priceNational
        
        updateShippingView(sp)
    }
    
    func updateShippingView(_ sp: Shipping) {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"

        shippingDateLabel.text = dateFormatterPrint.string(from: shipping.shippingDate)
        shippingStatusLabel.text = shipping.shippingStatus
        shippingCityLabel.text = shipping.city
        shippingPriceNationalLabel.text = "\(shipping.priceNational)"
        shippingPriceInternationalLabel.text = "\(shipping.priceInternational)"
        shippingDepositLabel.text = "\(shipping.deposit)"
        shippingCommentLabel.text = "\(shipping.comment)"
    }
}
