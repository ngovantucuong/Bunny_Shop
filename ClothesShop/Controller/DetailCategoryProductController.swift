//
//  DetailCategoryProductController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/3/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class DetailCategoryProductController: UIViewController {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var product: Product?
    var titleCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLayout()
        
        imageProduct.isUserInteractionEnabled = true
        imageProduct.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSwipeImage)))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    func showLayout() {
        imageProduct.loadImageFromCacheWithUrlString(urlString: (product?.image)!)
        nameProduct.text = product?.nameProduct
        descriptionProduct.text = product?.description
        price.text = "$\(String(describing: product!.price))"
    }
    
    lazy var imageGalleryLaucher: ImageGalleryLaucher = {
        let igr = ImageGalleryLaucher()
        igr.detailController = self
        return igr
    }()
 
    @objc func handleSwipeImage() {
        imageGalleryLaucher.showImageGalleryView()
    }

    @IBAction func handleAddCart(_ sender: UIButton) {
       
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let addCartController = self.storyboard?.instantiateViewController(withIdentifier: "AddCartController") as! AddCartController
        
        addCartController.product = self.product
        addCartController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(addCartController.view)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                addCartController.view.frame = CGRect(x: 16, y: 27, width: width - 32.0, height: height - 42.0)
            }, completion: nil)
        }
    }
}
