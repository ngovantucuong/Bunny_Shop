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
    var nameProduct: String?
    var cartViewCell: CartViewCell?
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
//        fetchProductCart()
        addSubview(collectionview)
        
        collectionview.alwaysBounceVertical = true
//        collectionview.contentInset = UIEdgeInsetsMake(0, 8, 0, 8)
        
        let uiNib = UINib(nibName: "ProductCartView", bundle: nil)
        collectionview.register(uiNib, forCellWithReuseIdentifier: cellID)
//        collectionview.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
        
        addConstrantWithFormat(format: "H:|[v0]|", views: collectionview)
        addConstrantWithFormat(format: "V:|[v0]|", views: collectionview)
    }
    
//    // get data from core data
//    func fetchProductCart() {
//        productCart = CoreData.shareCoreData.fetchProducts()
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCart?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CartViewCell
        let product = productCart![indexPath.item]
        cell.cartProduct = product
        self.cartViewCell = cell
        
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
        cartViewCell?.deleteProduct.isHidden = false
        nameProduct = productCart![indexPath.item].nameProduct
        cartViewCell?.deleteProduct.addTarget(self, action: #selector(handleDeleteProduct), for: .touchUpInside)
        numberProductDelete = indexPath.item
    }
    
    @objc func handleDeleteProduct() {
        CoreData.shareCoreData.deleteProductWithName(nameProduct: nameProduct!)
        productCart?.remove(at: numberProductDelete!)
        self.collectionview.reloadData()
    }
}
