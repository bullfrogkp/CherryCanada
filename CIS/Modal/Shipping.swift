//
//  Shipping.swift
//  CherryGo
//
//  Created by Kevin Pan on 2019-06-14.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

class Shipping {
    var comment: String
    var deposit: Decimal
    var priceInternational: Decimal
    var priceNational: Decimal
    var shippingDate: Date
    var shippingStatus: String
    
    init(comment: String, deposit: Decimal, priceInternational: Decimal, priceNational: Decimal, shippingDate: Date, shippingStatus: String) {
        self.comment = comment
        self.deposit = deposit
        self.priceInternational = priceInternational
        self.priceNational = priceNational
        self.shippingDate = shippingDate
        self.shippingStatus = shippingStatus
    }
    
    convenience init() {
        self.init(comment: "", deposit: 0, priceInternational: 0, priceNational: 0, shippingDate: Date(), shippingStatus: "")
    }
}
