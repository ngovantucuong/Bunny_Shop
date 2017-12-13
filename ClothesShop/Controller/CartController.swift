//
//  CartController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData

class CartController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var menuBar: MenuBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberProduct: UILabel!
    @IBOutlet weak var totalsPrice: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var viewInforPrice: UIView!
    
    @IBOutlet weak var heightConstraintViewPriceInfor: NSLayoutConstraint!
    
    let cellID = "cellID"
    let yourCartID = "yourCartID"
    let shippingID = "shippingID"
    let paymentID = "paymentID"
    
    let categoriesCart = ["Your Cart", "Shipping Info", "Payment"]
    var countCategory: CGFloat?
    var totalPrice: Float = 0.0
    var productCart: [ProductCart]?
//    weak var yourCartCell: YourCartCell?
    var item = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = UIColor(r: 245, g: 249, b: 251)
        collectionView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0)
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(YourCartCell.self, forCellWithReuseIdentifier: yourCartID)
        
        let uiNibShip = UINib(nibName: "ShippingView", bundle: nil)
        collectionView.register(uiNibShip, forCellWithReuseIdentifier: shippingID)
        
        let uiNibPayment = UINib(nibName: "PaymentView", bundle: nil)
        collectionView.register(uiNibPayment, forCellWithReuseIdentifier: paymentID)
        
        menuBar.cartController = self
        setupBarItem()
        
        nextButton.addTarget(self, action: #selector(handleTranferView), for: .touchUpInside)
        
        fetchProductCart()
        showInforYourCart(numberProduct: productCart!.count)
        calculateProductPrice(productCart: productCart!)
    }
    
    @objc func handleTranferView() {
        if item < 3 {
            item = item + 1
            let indexPath = NSIndexPath(item: item, section: 0) as IndexPath
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            self.menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .centeredVertically)
            
            if item == 2 {
                self.heightConstraintViewPriceInfor.constant = 0
            }
        }
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
    
    func stringFormatter(stringPrice: String) -> Float{
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: stringPrice)
        return number!.floatValue
    }
    
    // get data from core data
    func fetchProductCart() {
        productCart =  CoreData.shareCoreData.fetchProducts()
    }
    
    // caculation tototal price all product
    func calculateProductPrice(productCart: [ProductCart]) {
        for product in productCart {
            if let price = product.price {
                totalPrice = totalPrice + stringFormatter(stringPrice: price)
            }
        }
        let stringTotalPrice = String(format: "%0.2f", totalPrice)
        let total = "$\(stringTotalPrice)"
        totalsPrice.text = total
    }
    
    func showInforYourCart(numberProduct: Int) {
        self.numberProduct.text = String(describing: numberProduct)
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
        if indexPath.item == 0 {
            let yourCartCell = collectionView.dequeueReusableCell(withReuseIdentifier: yourCartID, for: indexPath) as! YourCartCell
//                self.yourCartCell = yourCartCell
                yourCartCell.cartController = self
            
                return yourCartCell
        } else if indexPath.item == 1 {
            let shippingCell = collectionView.dequeueReusableCell(withReuseIdentifier: shippingID, for: indexPath) as! ShipingCell
                shippingCell.cartController = self
                shippingCell.bottomConstraintView.constant = 232
            
            return shippingCell
        } else {
            let paymentCell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentID, for: indexPath) as! PaymentCell
            
            return paymentCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }



}
