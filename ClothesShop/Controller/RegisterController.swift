//
//  RegisterController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLayoutRegister()
        
        // Execute set image for profile
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
    }

    // set layout for register
    private func setLayoutRegister() {
        profileImage.tintColor = UIColor.white
        username.setBottomLine(borderColor: UIColor.white, textColor: UIColor.white, placeHolderColor: UIColor.white, placeHolder: "Enter your name...")
        email.setBottomLine(borderColor: UIColor.white, textColor: UIColor.white, placeHolderColor: UIColor.white, placeHolder: "Enter address email...")
        password.setBottomLine(borderColor: UIColor.white, textColor: UIColor.white, placeHolderColor: UIColor.white, placeHolder: "Please enter password...")
        password.isSecureTextEntry = true
    }
    
    @objc func handleSelectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.isEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectImageFromPicker: UIImage?
        
        if let editImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectImageFromPicker = editImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectImageFromPicker = originalImage
        }
        
        if let selectImage = selectImageFromPicker {
            profileImage.image = selectImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleRegisterUser(_ sender: Any) {
        if email.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please input username and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            guard let name = username.text, let password = password.text, let email = email.text else {
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                guard let uid = user?.uid else { return }
                
                let imageName = NSUUID().uuidString
                let storage = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                
                if let image = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(image, 0.1) {
                    storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            self.registerUserToDatabase(uid: uid, values: values)
                        }
                    })
                }
            }
        }
    }
    
    private func registerUserToDatabase(uid: String, values: [String: Any]) {
        // successfully authenticated user
        let ref = Database.database().reference(fromURL: "https://clothesshop-5e895.firebaseio.com/")
        let usersReference = ref.child("user-profiles").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            print("Save user successfully into firebase db")
        })
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
