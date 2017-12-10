//
//  CartController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class CartController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var menuBar: MenuBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let yourCartID = "yourCartID"
    let shippingID = "shippingID"
    let paymentID = "paymentID"
    
    var productCart: [ProductCart]?
    let categoriesCart = ["Your Cart", "Shipping Info", "Payment"]
    var countCategory: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.register(YourCartCell.self, forCellWithReuseIdentifier: yourCartID)
        
        menuBar.cartController = self
        setupBarItem()
    }
    
    func setupBarItem() {
        
        menuBar.category = categoriesCart
        countCategory = CGFloat(categoriesCart.count)
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = "Your Cart"
        label.font = UIFont.systemFont(ofSize: 16)
        self.navigationItem.titleView = label
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // transfer item correcponding of collection when pick menuBar
    func scrollToMenuIndex(menuIndex: Int) {
        let indexpath = NSIndexPath(item: menuIndex, section: 0) as  IndexPath
        collectionView?.scrollToItem(at: indexpath, at: .left, animated: true)
    }
    
    // change menu bar correspond with item of collectionview
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        
        self.menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paddingLeft: CGFloat = 60
        menuBar.horizontalBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x / countCategory!) + paddingLeft
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesCart.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var  cell: UICollectionViewCell?
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: yourCartID, for: indexPath) as! YourCartCell
            
            
        } else if indexPath.item == 1 {
            
        } else {
            
        }
        
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }



}
