//
//  PaymentCell.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let uiNib = UINib(nibName: "ProductCartView", bundle: nil)
        collectionView.register(uiNib, forCellWithReuseIdentifier: cellID)
    }
    
    var cartController: CartController? {
        didSet {
            
            totalsPrice.text = totalsPrice.text
            numberItem.text = cartController?.numberProduct.text
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
