//
//  CustomerItemEditTableViewCell.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerItemEditTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var priceBoughtTextField: UITextField!
    @IBOutlet weak var priceSoldTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var deleteItemButton: UIButton!
    
    @IBAction func deleteItem(_ sender: Any) {
        
        let row = (sender as AnyObject).tag % 1000
        let section = (sender as AnyObject).tag / 1000
        
        customerItemEditViewController.pageData.images![section].items.remove(at: row)
        
        let deletionIndexPath = NSIndexPath(row: row, section: section)
        customerItemTableView.deleteRows(at: [deletionIndexPath as IndexPath], with: .top)
    }
    
    var customerItemTableView: UITableView!
    var customerItemEditViewController: CustomerItemEditViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
