//
//  ImageMO+CoreDataProperties.swift
//  
//
//  Created by Kevin Pan on 2019-11-06.
//
//

import Foundation
import CoreData


extension ImageMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ImageMO> {
        return NSFetchRequest<ImageMO>(entityName: "Image")
    }

    @NSManaged public var imageFile: NSData
    
    @NSManaged public var name: String?
    @NSManaged public var shipping: ShippingMO?
    @NSManaged public var items: [ItemMO]?
    @NSManaged public var customers: [CustomerMO]?
    @NSManaged public var newImage: ImageMO?

}

// MARK: Generated accessors for items
extension ImageMO {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemMO)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemMO)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
