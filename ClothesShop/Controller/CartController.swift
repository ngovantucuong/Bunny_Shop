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
    
    let cellID = "cellID"
    let yourCartID = "yourCartID"
    let shippingID = "shippingID"
    let paymentID = "paymentID"
    
    let categoriesCart = ["Your Cart", "Shipping Info", "Payment"]
    var countCategory: CGFloat?
    var totalPrice: Float = 0.0
    var productCart: [ProductCart]?
    weak var yourCartCell: YourCartCell?
    var item = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceHorizontal = true
//        collectionView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(YourCartCell.self, forCellWithReuseIdentifier: yourCartID)
        
        let uiNibShip = UINib(nibName: "ShippingView", bundle: nil)
        collectionView.register(uiNibShip, forCellWithReuseIdentifier: shippingID)
        
        let uiNibPayment = UINib(nibName: "PaymentView", bundle: nil)
        collectionView.register(uiNibPayment, forCellWithReuseIdentifier: paymentID)
        
        menuBar.cartController = self
        setupBarItem()
        refreshData()
        
        nextButton.addTarget(self, action: #selector(handleTranferView), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    @objc func handleTranferView() {
        item = item + 1
        let indexPath = NSIndexPath(item: item, section: 0) as IndexPath
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    func refreshData() {
        do {
            try fetchedResultsController.performFetch()
            
            yourCartCell?.collectionview.reloadData()
            fetchProductCart()
            showInforYourCart()
            calculateProductPrice(productCart: productCart!)
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
    
    // get data from core data
    func fetchProductCart() {
        productCart =  fetchedResultsController.fetchedObjects
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
    
    func showInforYourCart() {
        let numberProduct = productCart?.count ?? 0
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
//        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        if indexPath.item == 0 {
            let yourCartCell = collectionView.dequeueReusableCell(withReuseIdentifier: yourCartID, for: indexPath) as! YourCartCell
                self.yourCartCell = yourCartCell
                yourCartCell.productCart = productCart
            
                return yourCartCell
        } else if indexPath.item == 1 {
            let shippingCell = collectionView.dequeueReusableCell(withReuseIdentifier: shippingID, for: indexPath) as! ShipingCell
                shippingCell.cartController = self
            
            return shippingCell
        } else {
            let paymentCell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentID, for: indexPath) as! PaymentCell
            paymentCell.productCart = productCart
            
            return paymentCell
        }
       
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.item == 1 {
//            return CGSize(width: view.frame.width, height: 453)
//        }
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }



}
