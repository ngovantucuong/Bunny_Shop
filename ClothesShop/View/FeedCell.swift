//
//  FeedCell.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/27/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var productArray: [Product]?
    var productFilterArray: [Product]?
    var categoryController: CategoryProductController?
    var navigationController: UINavigationController?
    var searchActive : Bool = false
    
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.backgroundColor = UIColor.white
        cl.dataSource = self
        cl.delegate = self
        return cl
    }()
    
    var stringJsonData: String? {
        didSet {
           fetchProduct(url: stringJsonData!)
        }
    }
    
    override func setupViews() {
        addSubview(collectionview)
        
        collectionview.alwaysBounceVertical = true
        collectionview.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        collectionview.register(ProductCell.self, forCellWithReuseIdentifier: cellID)
        
        addConstrantWithFormat(format: "H:|[v0]|", views: collectionview)
        addConstrantWithFormat(format: "V:|[v0]|", views: collectionview)
    }
    
    func fetchProduct(url: String) {
        ApiService.shareInstance.fetchProductForUrl(url: url, complete: {(products: [Product]) in
            DispatchQueue.main.async {
                self.productArray = products
                self.collectionview.reloadData()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = productFilterArray?.count {
            return count != 0 ? count : productArray!.count
        } else {
            return productArray?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProductCell
        if searchActive {
            let product = productFilterArray?[indexPath.item]
            cell.product = product
        } else {
            let product = productArray![indexPath.item]
            cell.product = product
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pading: CGFloat = 10
        let collectionviewSize = self.collectionview.frame.width - pading
        return CGSize(width: collectionviewSize / 2, height: 256)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let detailProductController = storyBoard.instantiateViewController(withIdentifier: "DetailCategoryProductController") as! DetailCategoryProductController
            detailProductController.product = productArray?[indexPath.item]
            detailProductController.titleCategory = categoryController?.titleCategory
        
            self.navigationController?.navigationItem.backBarButtonItem?.title = categoryController?.titleCategory
            self.navigationController?.pushViewController(detailProductController, animated: true)
    }
}
