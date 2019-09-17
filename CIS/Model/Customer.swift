//
//  Customer.swift
//  CIS
//
//  Created by Kevin Pan on 2019-07-21.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

class Customer {
    var comment: String
    var name: String
    var phone: String
    var wechat: String
    var items: [Item]
    var images: [Image]
    
    init(name: String, phone: String, wechat: String, comment: String, items: [Item], images: [Image]) {
        self.comment = comment
        self.name = name
        self.phone = phone
        self.wechat = wechat
        self.items = items
        self.images = images
    }
    
    convenience init(name: String) {
        self.init(name: name, phone: "", wechat: "", comment: "", items: [], images: [])
    }
    
    convenience init() {
        self.init(name: "", phone: "", wechat: "", comment: "", items: [], images: [])
    }
}
