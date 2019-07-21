//
//  Item.swift
//  CherryGo
//
//  Created by Kevin Pan on 2019-06-14.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

class Item {
    var comment: String
    var image: String
    var name: String
    var priceBought: Decimal
    var priceCharged: Decimal
    var quantity: Int
    
    init(comment: String, image: String, name: String, priceBought: Decimal, priceCharged: Decimal, quantity: Int) {
        self.comment = comment
        self.image = image
        self.name = name
        self.priceBought = priceBought
        self.priceCharged = priceCharged
        self.quantity = quantity
    }
    
    convenience init() {
        self.init(comment: "", image: "", name: "", priceBought: 0, priceCharged: 0, quantity: 0)
    }
}
