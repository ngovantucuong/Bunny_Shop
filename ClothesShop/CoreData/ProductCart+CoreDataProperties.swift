//
//  ProductCart+CoreDataProperties.swift
//  
//
//  Created by ngovantucuong on 12/10/17.
//
//

import Foundation
import CoreData


extension ProductCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCart> {
        return NSFetchRequest<ProductCart>(entityName: "ProductCart")
    }

    @NSManaged public var colour: String?
    @NSManaged public var imageProduct: String?
    @NSManaged public var nameProduct: String?
    @NSManaged public var price: String?
    @NSManaged public var ref: String?
    @NSManaged public var size: String?
    @NSManaged public var quantity: Int16

}
