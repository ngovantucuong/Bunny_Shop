//
//  MyTabBarController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/26/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let itemTag = item.tag
        
        switch itemTag {
        case 1:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeController") as? HomeController
            AppDelegate.navigationController?.pushViewController(viewController!, animated: true)
        case 2:
            let homeController = CartController()
            self.present(homeController, animated: true, completion: nil)
        case 3:
            let homeController = MapViewController()
            self.present(homeController, animated: true, completion: nil)
        case 4:
            let homeController = MenuController()
            self.present(homeController, animated: true, completion: nil)
        default:
            print("Error choice tag")
        }
    }

}
