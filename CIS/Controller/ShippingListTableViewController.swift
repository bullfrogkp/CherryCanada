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
    
    var shippingMOs: [ShippingMO] = []
    var shippings: [Shipping] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch data from data store
        /*
        let fetchRequest: NSFetchRequest<ShippingMO> = ShippingMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    shippingMOs = fetchedObjects
                    
                    shippings = convertShipping(shippingMOs)
                }
            } catch {
                print(error)
            }
        }
        */
        
        let items1: [Item] = [
            Item(comment: "Item1", image: "test", name: "货物1", priceBought: 1.00, priceSold: 2.00, quantity: 3),
            Item(comment: "Item2", image: "test2", name: "货物2", priceBought: 2.00, priceSold: 3.00, quantity: 5),
        ]
        
        let items2: [Item] = [
            Item(comment: "Item1", image: "test2", name: "大货物1", priceBought: 10.00, priceSold: 22.00, quantity: 1)
        ]
        
        let customers1 = [
            Customer(name: "Kevin", phone: "416-666-6666", wechat: "nice", comment: "A good guy", items: items1),
            Customer(name: "Evita", phone: "416-666-8888", wechat: "cool", comment: "Haha", items: items2)
        ]
        
        let customers2 = [
            Customer(name: "Kevin2", phone: "416-666-6666", wechat: "nice", comment: "A good guy", items: items1)
        ]
        
        shippings = [
            Shipping(comment: "", city: "哈尔滨", deposit: 100, priceInternational: 200, priceNational: 120, shippingDate: Date(), shippingStatus: "完成", customers: customers1),
            Shipping(comment: "hahaha", city: "Toronto", deposit: 110, priceInternational: 210, priceNational: 130, shippingDate: Date(), shippingStatus: "待定", customers: customers2)
        ]
        
        tableView.backgroundView = emptyShippingView
        tableView.backgroundView?.isHidden = true
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
        
        cell.shippingCityLabel.text = shippingDetail.city
        cell.shippingDateLabel.text = "\(shippingDetail.shippingDate)"
        cell.shippingStatusLabel.text = shippingDetail.shippingStatus
        cell.shippingDepositLabel.text = "\(shippingDetail.deposit)"

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
                let tabBarC : ShippingDetailViewController = segue.destination as! ShippingDetailViewController
                let naviView: CustomerListTableViewController = tabBarC.viewControllers?[1] as! CustomerListTableViewController
                
                naviView.shipping = shippings[indexPath.row]
            }
        }
    }
    
//    func convertShipping(_ shippingMOs: [ShippingMO]) -> [Shipping] {
//        var sps: [Shipping] = []
//        
//        return sps
//    }
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//        switch type {
//        case .insert:
//            if let newIndexPath = newIndexPath {
//                tableView.insertRows(at: [newIndexPath], with: .fade)
//            }
//        case .delete:
//            if let indexPath = indexPath {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        case .update:
//            if let indexPath = indexPath {
//                tableView.reloadRows(at: [indexPath], with: .fade)
//            }
//        default:
//            tableView.reloadData()
//        }
//        
//        if let fetchedObjects = controller.fetchedObjects {
//            shippingMOs = fetchedObjects as! [ShippingMO]
//            shippings = convertShipping(shippingMOs)
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
}
