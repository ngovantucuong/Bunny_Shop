//
//  YourCartView.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData

class YourCartCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    let cellID = "cellID"
    var productCart: [ProductCart]?
    var qualtityProduct: [NSFetchRequestResult]?
    var nameProduct: String?
    var cartViewCell: CartViewCell?
    var cartController: CartController?
    var numberProductDelete: Int?
    
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.backgroundColor = UIColor.white
        cl.dataSource = self
        cl.delegate = self
        return cl
    }()
    
    
    override func setupViews() {
        addSubview(collectionview)
        
        collectionview.alwaysBounceVertical = true
        
        let uiNib = UINib(nibName: "ProductCartView", bundle: nil)
        collectionview.register(uiNib, forCellWithReuseIdentifier: cellID)
        
        addConstrantWithFormat(format: "H:|[v0]|", views: collectionview)
        addConstrantWithFormat(format: "V:|[v0]|", views: collectionview)
        refreshData()
    }
    
    func refreshData() {
        do {
            try fetchedResultsController.performFetch()
            
            fetchProductCart()
            cartController?.showInforYourCart(numberProduct: (productCart?.count)!)
            cartController?.calculateProductPrice(productCart: productCart!)
            
            self.collectionview.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            refreshData()
        case .delete:
            refreshData()
        default:
            break
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<ProductCart> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<ProductCart> = ProductCart.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.managerObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // get data from core data
    func fetchProductCart() {
        productCart =  fetchedResultsController.fetchedObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCart?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CartViewCell
        let product = productCart![indexPath.item]
        cell.cartProduct = product
        cell.yourCartCell = self
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 137
        let width: CGFloat = 428
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        cartViewCell?.deleteProduct.isHidden = false
        nameProduct = productCart![indexPath.item].nameProduct
        numberProductDelete = indexPath.item
    }
    
    func handleDeleteProduct() {
        CoreData.shareCoreData.deleteProductWithName(nameProduct: nameProduct!)
    }
}
