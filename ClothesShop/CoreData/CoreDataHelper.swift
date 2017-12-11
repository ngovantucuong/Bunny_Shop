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
    let context = AppDelegate.managerObjectContext!
    
    func saveProduct(dictionaryProduct: [String: Any]) {
        let isCheckExitsNameProduct: Bool?
        let productCartResult: [ProductCart]?
        let countProduct: Int16?
        
        productCartResult = getProductWithName(nameProduct: dictionaryProduct["nameProduct"] as! String, fetchLimit: 0)
        countProduct = Int16(productCartResult!.count)
        isCheckExitsNameProduct = countProduct! > 1 ? true : false
        
        if isCheckExitsNameProduct! {
            for product in productCartResult! {
                product.setValue(countProduct! + 1, forKey: "qualtity")
            }
        } else {
            let productCart = NSEntityDescription.insertNewObject(forEntityName: "ProductCart", into: context) as! ProductCart
            productCart.imageProduct = dictionaryProduct["imageProduct"] as? String
            productCart.nameProduct = dictionaryProduct["nameProduct"] as? String
            productCart.price = dictionaryProduct["price"] as? String
            productCart.size = dictionaryProduct["size"] as? String
            productCart.colour = dictionaryProduct["colour"] as? String
            productCart.ref = dictionaryProduct["ref"] as? String
            productCart.quantity = 1
        }
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getProductWithName(nameProduct: String, fetchLimit: Int) -> [ProductCart]? {
        let context = AppDelegate.managerObjectContext!
        
        let fetchRequestProduct = NSFetchRequest<ProductCart>(entityName: "ProductCart")
        fetchRequestProduct.predicate = NSPredicate(format: "nameProduct = %@", nameProduct)
        fetchRequestProduct.fetchLimit = fetchLimit
        
        do {
            return  try context.fetch(fetchRequestProduct) as [ProductCart]
        } catch let error {
            print(error.localizedDescription)
    }
        
        return []
    }
    
    func fetchProducts() -> [ProductCart]? {
        do {
            return try context.fetch(ProductCart.fetchRequest()) as? [ProductCart]
        } catch let err {
            print(err)
        }
        return nil
    }
    
    func deleteProductWithName(nameProduct: String) {
        let products = getProductWithName(nameProduct: nameProduct, fetchLimit: 0)
        for product in products! {
            context.delete(product)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func deleteAllData() {
        do {
            let products = fetchProducts()
            for product in products! {
                context.delete(product)
            }
            
            try context.save()
            
        } catch let err {
            print(err)
        }
    }
}
