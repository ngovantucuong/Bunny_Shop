//
//  ShipingCell.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import Firebase

class ShipingCell: UICollectionViewCell {
    
    @IBOutlet weak var imageUser: UIImageViewX!
    @IBOutlet weak var nameTextField: UITextFieldX!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var cartController: CartController? {
        didSet {
            let price = (cartController?.totalPrice)! + 5.0
            cartController?.totalsPrice.text = String(format: "%0.2f", price)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    private func setupLayout() {
        nameTextField.setBottomLine(borderColor: UIColor.white, textColor: UIColor.black, placeHolderColor: UIColor.gray, placeHolder: "Enter first name")
        lastNameTextField.setBottomLine(borderColor: UIColor.white, textColor: UIColor.black, placeHolderColor: UIColor.gray, placeHolder: "Enter last name")
        addressTextField.setBottomLine(borderColor: UIColor.white, textColor: UIColor.black, placeHolderColor: UIColor.gray, placeHolder: "Enter address of you")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let refDatabase = Database.database().reference().child("users").child(uid)
        refDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.imageUser.loadImageFromCacheWithUrlString(urlString: (user.profileImage))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
