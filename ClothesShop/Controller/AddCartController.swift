//
//  AddCartController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/5/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class AddCartController: UIViewController {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: DropMenuButton!
    @IBOutlet weak var colour: DropMenuButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var refProduct: UILabel!
    @IBOutlet weak var addToCartButton: UIButtonX!
    
    var product: Product?
    var dictionaryProduct = [String: Any]()
    var sizeProduct: String?
    var colourProduct: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        handleSelectSize()
        handleSelectColour()
        
        addToCartButton.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
    }

    func setLayout() {
        if let imageUrl = product?.image {
            imageProduct.loadImageFromCacheWithUrlString(urlString: imageUrl)
        }
        nameProduct.text = product?.nameProduct
        price.text = String(describing: product!.price)
    }
    
    func setBorderButton() {
        size.layer.borderWidth = 2
        size.layer.borderColor = UIColor(r: 229, g: 233, b: 236).cgColor
        
        colour.layer.borderWidth = 2
        colour.layer.borderColor = UIColor(r: 229, g: 233, b: 236).cgColor
    }
    
    func setDataForCart() {
        dictionaryProduct["imageProduct"] = self.product?.image
        dictionaryProduct["nameProduct"] = self.product?.nameProduct
        dictionaryProduct["price"] = self.price
        dictionaryProduct["size"] = self.sizeProduct
        dictionaryProduct["colour"] = self.colourProduct
    }
    
    func handleSelectSize() {
        size.initMenu(["XS", "S", "M", "L"], actions: [({ () -> (Void) in
           self.sizeProduct = "XS"
        }), ({ () -> (Void) in
           self.sizeProduct = "S"
        }), ({ () -> (Void) in
           self.sizeProduct = "M"
        }), ({ () -> (Void) in
            self.sizeProduct = "L"
        })])
    }
    
    func handleSelectColour() {
        colour.initMenu(["yellow", "red", "blue"], actions: [({ () -> (Void) in
            self.colourProduct = "yellow"
        }), ({ () -> (Void) in
            self.colourProduct = "red"
        }), ({ () -> (Void) in
            self.colourProduct = "blue"
        })])
    }
    
    @objc func handleAddToCart() {
        dictionaryProduct["imageProduct"] = self.product?.image
        dictionaryProduct["nameProduct"] = self.product?.nameProduct
        dictionaryProduct["price"] = self.price
        dictionaryProduct["size"] = self.sizeProduct
        dictionaryProduct["colour"] = self.colourProduct
        dictionaryProduct["ref"] = refProduct.text
        
        CoreData.shareCoreData.saveProduct(dictionaryProduct:  dictionaryProduct, context:  AppDelegate.managerObjectContext!)
    }

    @IBAction func handleDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
