//
//  CoreDataHelper.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import CoreData

class CoreData {
    
    static let shareCoreData = CoreData()
    
    func saveProduct(dictionaryProduct: [String: Any], context: NSManagedObjectContext) {
        let productCart = NSEntityDescription.insertNewObject(forEntityName: "ProductCart", into: context) as! ProductCart
        productCart.imageProduct = dictionaryProduct["imageProduct"] as? String
        productCart.nameProduct = dictionaryProduct["nameProduct"] as? String
        productCart.price = dictionaryProduct["price"] as? String
        productCart.size = dictionaryProduct["size"] as? String
        productCart.colour = dictionaryProduct["colour"] as? String
        productCart.ref = dictionaryProduct["ref"] as? String
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getProductWithName(nameProduct: String) -> [NSFetchRequestResult] {
        let context = AppDelegate.managerObjectContext!
        
        let fetchRequestProduct = NSFetchRequest<ProductCart>(entityName: "ProductCart")
        fetchRequestProduct.predicate = NSPredicate(format: "nameProduct = %@", nameProduct)
        
        do {
            return  try context.fetch(fetchRequestProduct)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchFriends() -> [ProductCart]? {
        let context = AppDelegate.managerObjectContext
        do {
            return try context?.fetch(ProductCart.fetchRequest()) as? [ProductCart]
        } catch let err {
            print(err)
        }
        return nil
    }
}
