//
//  Utils.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-19.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

func convertItemsToCustomers(items: [Item]) -> [Customer] {
    var customers: [Customer] = []
    var foundCustomer = false
    var foundImage = false
    
    for item in items {
        foundCustomer = false
        for customer in customers {
            if(customer === item.customer) {
                foundImage = false
                for image in customer.images {
                    if(image === item.image) {
                        image.items.append(item)
                        foundImage = true
                        break
                    }
                }
                
                if(foundImage == false) {
                    let image = Image()
                    image.name = item.image.name
                    image.items.append(item)
                    customer.images.append(image)
                }
                
                foundCustomer = true
                break
            }
        }
        
        if(foundCustomer == false) {
            let customer = Customer()
            customer.name = item.customer.name
            
            let image = Image()
            image.name = item.image.name
            image.items.append(item)
            customer.images.append(image)
            
            customers.append(customer)
        }
    }
    
    return customers
}
