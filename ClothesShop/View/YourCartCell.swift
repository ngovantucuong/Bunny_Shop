//
//  YourCartView.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData

class YourCartCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var productCart: [ProductCart]?
    var qualtityProduct: [NSFetchRequestResult]?
    
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
        fetchProductCart()
        addSubview(collectionview)
        
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionview.alwaysBounceVertical = true
        collectionview.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        collectionview.register(CartViewCell.self, forCellWithReuseIdentifier: cellID)
        
        addConstrantWithFormat(format: "H:|[v0]|", views: collectionview)
        addConstrantWithFormat(format: "V:|[v0]|", views: collectionview)
    }
    
    func fetchProductCart() {
        productCart = CoreData.shareCoreData.fetchFriends()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCart?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CartViewCell
        let product = productCart![indexPath.item]
        qualtityProduct = CoreData.shareCoreData.getProductWithName(nameProduct: product.nameProduct!)
        cell.cartProduct = product
        cell.qualtityProduct = qualtityProduct?.count
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 137
        let width: CGFloat = 428
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
