//
//  ItemTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-07-08.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {

    var items = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: "itemCellId")
    }
    
    @objc func insert() {
        items.append("Item \(items.count + 1)")
        
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "itemCellId", for: indexPath as IndexPath) as! ItemCell
        myCell.itemNameTextField.text = items[indexPath.row]
        myCell.itemTableViewController = self
        return myCell
    }
    
    @objc func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = self.tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            self.tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

}
