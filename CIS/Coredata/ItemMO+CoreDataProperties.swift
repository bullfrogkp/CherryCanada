//
//  ItemMO+CoreDataProperties.swift
//  
//
//  Created by Kevin Pan on 2019-11-06.
//
//

import Foundation
import CoreData


extension ItemMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ItemMO> {
        return NSFetchRequest<ItemMO>(entityName: "Item")
    }

    @NSManaged public var comment: String
    @NSManaged public var name: String
    @NSManaged public var priceBought: Decimal
    @NSManaged public var priceSold: Decimal
    @NSManaged public var quantity: Int
    @NSManaged public var customer: CustomerMO
    @NSManaged public var shipping: ShippingMO
    @NSManaged public var image: ImageMO

}
