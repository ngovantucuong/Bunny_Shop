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
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        handleSelectSize()
        handleSelectColour()
    }

    func setLayout() {
        if let imageUrl = product?.image {
            imageProduct.loadImageFromCacheWithUrlString(urlString: imageUrl)
        }
        nameProduct.text = product?.nameProduct
        price.text = String(describing: product?.price)
    }
    
    func setBorderButton() {
        size.layer.borderWidth = 2
        size.layer.borderColor = UIColor(r: 229, g: 233, b: 236).cgColor
        
        colour.layer.borderWidth = 2
        colour.layer.borderColor = UIColor(r: 229, g: 233, b: 236).cgColor
    }
    
    func handleSelectSize() {
        size.initMenu(["XS", "S", "M", "L"], actions: [({ () -> (Void) in
           
        }), ({ () -> (Void) in
           
        }), ({ () -> (Void) in
           
        }), ({ () -> (Void) in
            
        })])
    }
    
    func handleSelectColour() {
        colour.initMenu(["yellow", "red", "blue"], actions: [({ () -> (Void) in
            
        }), ({ () -> (Void) in
            
        }), ({ () -> (Void) in
            
        })])
    }

}
