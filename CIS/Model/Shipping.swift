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
    var city: String
    var deposit: Decimal
    var priceInternational: Decimal
    var priceNational: Decimal
    var shippingDate: Date
    var shippingStatus: String
    var items: [Item]
    var active: Bool
    
    init(comment: String, city: String, deposit: Decimal, priceInternational: Decimal, priceNational: Decimal, shippingDate: Date, shippingStatus: String, items: [Item], active: Bool) {
        self.comment = comment
        self.deposit = deposit
        self.city = city
        self.priceInternational = priceInternational
        self.priceNational = priceNational
        self.shippingDate = shippingDate
        self.shippingStatus = shippingStatus
        self.items = items
        self.active = active
    }
    
    convenience init() {
        self.init(comment: "", city: "", deposit: 0, priceInternational: 0, priceNational: 0, shippingDate: Date(), shippingStatus: "", items: [], active: true)
    }
}
