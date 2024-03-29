//
//  ShippingListTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-07-26.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit
import CoreData

class ShippingListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet var emptyShippingView: UIView!
    
    var fetchResultController: NSFetchedResultsController<ShippingMO>!
    var shippings: [ShippingMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = emptyShippingView
        tableView.backgroundView?.isHidden = true
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<ShippingMO> = ShippingMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "shippingDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    shippings = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if shippings.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shippings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingId", for: indexPath as IndexPath) as! ShippingListTableViewCell

        let shippingDetail = shippings[indexPath.row]
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        cell.shippingDateLabel.text = dateFormatterPrint.string(from: shippingDetail.shippingDate!)
        cell.shippingCityLabel.text = shippingDetail.city
        cell.shippingStatusLabel.text = shippingDetail.shippingStatus
        if(shippingDetail.deposit != nil) {
            cell.shippingDepositLabel.text = "\(shippingDetail.deposit!)"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shippings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShippingDetail" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ShippingDetailViewController
                destinationController.shipping = shippings[indexPath.row]
                destinationController.cellIndex = indexPath.row
                destinationController.shippingListTableViewController = self
            }
            
        } else if segue.identifier == "addShippingDetail" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let shippingView: ShippingInfoViewController = naviView.viewControllers[0] as! ShippingInfoViewController
            shippingView.shippingListTableViewController = self
        }
    }
    
    // MARK: - Helper Functions
//    func convertToShipping(_ shippingMOs: [ShippingMO]) -> [Shipping] {
//        
//        let image1 = Image(imageFile: UIImage(named: "test")!.pngData()! as NSData)
//        let image2 = Image(imageFile: UIImage(named: "test2")!.pngData()! as NSData)
//        let image3 = Image(imageFile: UIImage(named: "test2")!.pngData()! as NSData)
//        
//        let customer1 = Customer(name: "Kevin", phone: "416-666-6666", wechat: "nice", comment: "A good guy", items: [], images: [image1, image2, image3], active: true)
//        let customer2 = Customer(name: "Test")
//        
//        image1.customers = [customer1]
//        image2.customers = [customer1]
//        image3.customers = [customer1]
//        
//        let item1 = Item(comment: "Item1", image: image1, name: "货物1", priceBought: 1.00, priceSold: 2.00, quantity: 3, customer: customer1)
//        
//        let item2 = Item(comment: "Item2", image: image1, name: "货物2", priceBought: 1.00, priceSold: 2.00, quantity: 3, customer: customer1)
//        
//        let item3 = Item(comment: "Item3", image: image2, name: "货物3", priceBought: 1.00, priceSold: 2.00, quantity: 3, customer: customer1)
//        
//        let shippings = [
//            Shipping(comment: "", city: "哈尔滨", deposit: 100, priceInternational: 200, priceNational: 120, shippingDate: Date(), shippingStatus: "完成", items: [item1, item2, item3], images: [image1, image2, image3], customers: [customer1, customer2])
//        ]
//        
//        return shippings
//    }
    
    func deleteShipping(_ rowIndex: Int) {
        shippings.remove(at: rowIndex)
        tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }

    func addShipping(_ sp: ShippingMO) {
        shippings.insert(sp, at: 0)
               
        let insertionIndexPath = NSIndexPath(row: 0, section: 0)
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .top)
    }
}
