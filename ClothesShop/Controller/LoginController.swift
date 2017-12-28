//
//  LoginController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/18/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit

class LoginController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var logoShop: UIImageViewX!
    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var password: UITextFieldX!
    
    @IBOutlet weak var SignIn: GIDSignInButton!
    @IBOutlet weak var SignInFace: UIButtonX!
    static var isLoginFacebook: Bool = false
    static var isLoginGmail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        password.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        
        SignIn.addTarget(self, action: #selector(handleSignInGmail), for: .touchUpInside)
        SignInFace.addTarget(self, action: #selector(handleSignInFacebook), for: .touchUpInside)
        
        // set image for tabBarItem
        setImageForTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setImageForTabBar() {
        let imageHome = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).resizeImage(targetSize: CGSize(width: 50, height: 50))
        self.tabBarController?.tabBar.items![0].image = imageHome
        
        let imageCart = UIImage(named: "shop")?.withRenderingMode(.alwaysOriginal).resizeImage(targetSize: CGSize(width: 30, height: 30))
        self.tabBarController?.tabBar.items![1].image = imageCart
        
        let imageMap = UIImage(named: "map")?.withRenderingMode(.alwaysOriginal).resizeImage(targetSize: CGSize(width: 30, height: 30))
        self.tabBarController?.tabBar.items![2].image = imageMap
        
        let imageProfile = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal).resizeImage(targetSize: CGSize(width: 30, height: 30))
        self.tabBarController?.tabBar.items![3].image = imageProfile
    }

    private func setupLayout() {
        logoShop.backgroundColor = UIColor.white
        logoShop.layer.cornerRadius = 50
        logoShop.layer.masksToBounds = true
        
        email.layer.cornerRadius = 20
        email.layer.masksToBounds = true
        
        password.layer.cornerRadius = 20
        password.layer.masksToBounds = true
        password.isSecureTextEntry = true
    }
    
    // execute enter after when input character
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") {
            self.navigationController?.pushViewController(viewController, animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please input email and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            guard let email = email.text, let password = password.text else {
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") {
                    self.navigationController?.pushViewController(viewController, animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func handleSignInFacebook() {
        LoginController.isLoginFacebook = true
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("Failed to login:  \(error!.localizedDescription)")
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Login error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                let databaseRef = Database.database().reference()
                guard let uid = user?.uid else {  return }
                databaseRef.child("user-profiles").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshot = snapshot.value as? NSDictionary
                    if snapshot == nil {
                        databaseRef.child("user-profiles").child(uid).child("name").setValue(user?.displayName)
                        if user?.email == nil {
                            let email = "\(user!.displayName ?? "keylia")@gmail.com"
                            databaseRef.child("user-profiles").child(uid).child("email").setValue(email)
                        }
                        
                        let imageName = NSUUID().uuidString
                        let storage = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                        
                        if let uploadData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "userIcon"), 0.1) {
                            storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                if error != nil {
                                    print(error!.localizedDescription)
                                }
                                
                                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                    databaseRef.child("user-profiles").child(uid).child("profileImageUrl").setValue(profileImageUrl)
                                }
                            })
                        }
                    }
                    
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") {
                        self.navigationController?.pushViewController(viewController, animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    @objc func handleSignInGmail() {
        LoginController.isLoginGmail = true
        AppDelegate.navigationController = self.navigationController
        GIDSignIn.sharedInstance().signIn()
    }

}
