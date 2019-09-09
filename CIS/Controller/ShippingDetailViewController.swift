//
//  ShippingDetailViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-08.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ShippingDetailViewController: UIViewController {

    @IBOutlet weak var shippingDateTextField: UITextField!
    @IBOutlet weak var shippingStatusTextField: UITextField!
    @IBOutlet weak var shippingCityTextField: UITextField!
    @IBOutlet weak var shippingFeeNationalTextField: UITextField!
    @IBOutlet weak var shippingFeeInternationalTextField: UITextField!
    @IBOutlet weak var shippingDepositTextField: UITextField!
    @IBOutlet weak var shippingCommentTextField: UITextField!
    
    @IBAction func saveData(_ sender: Any) {
        
        if shipping == nil {
            shipping = Shipping()
        }
        
        shipping.shippingDate = shippingDateTextField.text
        shipping.shippingStatus = shippingStatusTextField.text = shipping.shippingStatus
        shipping.shippingCity = shippingCityTextField.text = shipping.shippingCity
        shipping.shippingFeeNational = shippingFeeNationalTextField.text = shipping.shippingFeeNational
        shipping.shippingFeeInternational = shippingFeeInternationalTextField.text = shipping.shippingFeeInternational
        shipping.shippingDeposit = shippingDepositTextField.text = shipping.shippingDeposit
        shipping.shippingComment = shippingCommentTextField.text = shipping.shippingComment
    }
    
    var shipping: Shipping?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shippingDateTextField.text = shipping?.shippingDate ?? ""
        shippingStatusTextField.text = shipping?.shippingStatus ?? ""
        shippingCityTextField.text = shipping?.shippingCity ?? ""
        shippingFeeNationalTextField.text = shipping?.shippingFeeNational ?? ""
        shippingFeeInternationalTextField.text = shipping?.shippingFeeInternational ?? ""
        shippingDepositTextField.text = shipping?.shippingDeposit ?? ""
        shippingCommentTextField.text = shipping?.shippingComment ?? ""
    }
}
