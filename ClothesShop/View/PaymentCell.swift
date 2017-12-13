//
//  PaymentCell.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData
import Stripe
import Stripe.STPCard


class PaymentCell: UICollectionViewCell, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var numberVisaTextField: UITextFieldX!
    @IBOutlet weak var nameAccountTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var numberItem: UILabel!
    @IBOutlet weak var totalsPrice: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var productCart: [ProductCart]?
    let cellID = "cellID"
    var totalPrice: Float  = 5.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
       showProductPayment()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let uiNib = UINib(nibName: "ProductCartView", bundle: nil)
        collectionView.register(uiNib, forCellWithReuseIdentifier: cellID)
        
        payButton.addTarget(self, action: #selector(handlePayment), for: .touchUpInside)
    }
    
    // get data from core data
    func showProductPayment() {
        productCart =  CoreData.shareCoreData.fetchProducts()
        
        showInforYourCart(numberProduct: productCart!.count)
        calculateProductPrice(productCart: productCart!)
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
    
    func showInforYourCart(numberProduct: Int) {
        numberItem.text = String(describing: numberProduct)
    }
    
    @objc func handlePayment() {
        // Initiate the card
//        var stripCard = STPCard()
//
//        // Split the expiration date to extract Month & Year
//        if self.expireDateTextField.text?.isEmpty == false {
//            let expirationDate = self.expireDateTextField.text.componentsSeparatedByString("/")
//            let expMonth = UInt(expirationDate[0].toInt()!)
//            let expYear = UInt(expirationDate[1].toInt()!)
//
//            // Send the card info to Strip to get the token
//            stripCard.number = self.numberVisaTextField.text
//            stripCard.cvc = self.cvcTextField.text
//            stripCard.expMonth = expMonth
//            stripCard.expYear = expYear
    }
    
//    var cartController: CartController? {
//        didSet {
//            let price = (cartController?.totalPrice)! + 5.0
//            let stringTotalPrice = String(format: "%0.2f", price)
//            let total = "$\(stringTotalPrice)"
//            numberItem.text = total
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCart?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CartViewCell
        let product = productCart![indexPath.item]
        cell.cartProduct = product
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 384, height: 196)
    }
}
