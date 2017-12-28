//
//  MenuController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/23/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "cellID"
    
    
    var itemSlideMenu: [slideMenuItem] = [slideMenuItem(imageIcon: #imageLiteral(resourceName: "images"), content: "Home"), slideMenuItem(imageIcon: #imageLiteral(resourceName: "sale"), content: "Sales"), slideMenuItem(imageIcon: #imageLiteral(resourceName: "shop"), content: "In Store"), slideMenuItem(imageIcon: #imageLiteral(resourceName: "shopping-cart"), content: "My Cart"), slideMenuItem(imageIcon: #imageLiteral(resourceName: "profile"), content: "Profile"), slideMenuItem(imageIcon: #imageLiteral(resourceName: "logout"), content: "Logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        let uiNib = UINib(nibName: "SlideMenuCell", bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: cellID)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        self.navigationController?.isNavigationBarHidden = true
    }

    private func setupLayout() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let refDatabase = Database.database().reference().child("user-profiles").child(uid)
        refDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.nameProfile.text = user.name
                self.email.text = user.email
                self.profileImage.loadImageFromCacheWithUrlString(urlString: (user.profileImage))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSlideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SlideMenuCell
        let item = itemSlideMenu[indexPath.row]
        cell?.imageIcon?.image = item.imageIcon
        cell?.content?.text = item.content
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 5 {
           
            if LoginController.isLoginGmail {
               GIDSignIn.sharedInstance().signOut()
            } else if LoginController.isLoginFacebook {
               FBSDKLoginManager().logOut()
            } else {
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
            
            let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController")
            self.present(loginController!, animated: true, completion: nil)
            CoreData.shareCoreData.deleteAllData()
        }
    }
}
