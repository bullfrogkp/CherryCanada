//
//  ShippingInfoViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-08.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ShippingInfoViewController: UIViewController {

    @IBOutlet weak var shippingDateTextField: UITextField!
    @IBOutlet weak var shippingStatusTextField: UITextField!
    @IBOutlet weak var shippingCityTextField: UITextField!
    @IBOutlet weak var shippingFeeNationalTextField: UITextField!
    @IBOutlet weak var shippingFeeInternationalTextField: UITextField!
    @IBOutlet weak var shippingDepositTextField: UITextField!
    @IBOutlet weak var shippingCommentTextField: UITextField!
    
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveData(_ sender: Any) {
        
        if shippingDateTextField.text == "" {
            let alertController = UIAlertController(title: "必填项目", message: "请填写日期", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if shipping == nil {
            shipping = Shipping()
            shippings.append(shipping!)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        shipping!.shippingDate = dateFormatter.date(from: shippingDateTextField.text!)!
        
        shipping!.shippingStatus = shippingStatusTextField.text!
        shipping!.city = shippingCityTextField.text!
        shipping!.comment = shippingCommentTextField.text!
        
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        if let formattedNumber = formatter.number(from: shippingFeeNationalTextField.text!) as? NSDecimalNumber  {
            shipping!.priceNational = formattedNumber as Decimal
        }
        
        if let formattedNumber = formatter.number(from: shippingFeeInternationalTextField.text!) as? NSDecimalNumber  {
            shipping!.priceInternational = formattedNumber as Decimal
        }
        
        if let formattedNumber = formatter.number(from: shippingDepositTextField.text!) as? NSDecimalNumber  {
            shipping!.deposit = formattedNumber as Decimal
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    var shipping: Shipping?
    var shippings: [Shipping]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if shipping != nil {
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            
            shippingDateTextField.text = dateFormatterPrint.string(from: shipping!.shippingDate)
            shippingStatusTextField.text = "\(shipping!.shippingStatus)"
            shippingCityTextField.text = "\(shipping!.city)"
            shippingFeeNationalTextField.text = "\(shipping!.priceNational)"
            shippingFeeInternationalTextField.text = "\(shipping!.priceInternational)"
            shippingDepositTextField.text = "\(shipping!.deposit)"
            shippingCommentTextField.text = "\(shipping!.comment)"
        }   else {
            shippingDateTextField.text = ""
            shippingStatusTextField.text = ""
            shippingCityTextField.text = ""
            shippingFeeNationalTextField.text = ""
            shippingFeeInternationalTextField.text = ""
            shippingDepositTextField.text = ""
            shippingCommentTextField.text = ""
        }
    }
}