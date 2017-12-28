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
import AFNetworking


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
        let stripCard = STPCardParams()
        
        // Split the expiration date to extract Month & Year
        if self.expireDateTextField.text?.isEmpty == false {
            let expirationDate = self.expireDateTextField.text?.components(separatedBy: "/")
            let expMonth = UInt(expirationDate![0])
            let expYear = UInt(expirationDate![1])

            // Send the card info to Strip to get the token
            stripCard.number = numberVisaTextField.text
            stripCard.cvc = cvcTextField.text
            stripCard.expMonth = expMonth!
            stripCard.expYear = expYear!
        }
        
        STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                return
            }
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.postStripeToken(token: token)
        }
        
    }
    
    func postStripeToken(token: STPToken) {
        
        let URL = "http://localhost/donate/payment.php"
        let params = ["stripeToken": token.tokenId,
                      "amount": Int(self.totalsPrice.text!) ?? 0,
                      "currency": "usd",
                      "description": "ngovantucuong@gmail.com"] as [String : Any]
        let manager = AFHTTPRequestOperationManager()
        manager.post(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                self.handleNotification(title: response["status"]!, message: response["message"]!)
            }
            
        }) { (operation, error) -> Void in
            print(error!.localizedDescription)
        }
    }
    
    func handleError(error: NSError) {
        let alertController = UIAlertController(title: "Please Try Again", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController = alertController
    }
    
    func handleNotification(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController = alertController
    }
    
    var cartController: CartController? {
        didSet {
            let price = (cartController?.totalPrice)! + 5.0
            let stringTotalPrice = String(format: "%0.2f", price)
            let total = "$\(stringTotalPrice)"
            numberItem.text = total
        }
    }
    
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
