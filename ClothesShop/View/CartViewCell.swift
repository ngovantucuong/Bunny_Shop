//
//  CartViewCell.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData

class CartViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var colour: UILabel!
    
    var qualtityProduct: Int?
    
    var cartProduct: ProductCart? {
        didSet {
            self.imageProduct.loadImageFromCacheWithUrlString(urlString: cartProduct!.imageProduct!)
            self.nameProduct.text = cartProduct?.nameProduct
            self.size.text = cartProduct?.size
            self.colour.text = cartProduct?.colour
            self.quantity.text = String(describing: qualtityProduct!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
