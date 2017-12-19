//
//  HomeController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/21/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UITableViewController {

    let categories: [Categories] = [Categories(label: "", subLabel: "", picture: #imageLiteral(resourceName: "saleBackground")), Categories(label: "WOMEN", subLabel: "Ready For Anything", picture: #imageLiteral(resourceName: "categoryWomen")), Categories(label: "MEN", subLabel: "Christmas gifting wrapped up fast", picture: #imageLiteral(resourceName: "Men"))]
    var isTouchSlideMenu: Bool = true
    var menuController: MenuController?
    var titleCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "slidemenu")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        let menuButton = UIBarButtonItem(image: image, style: .plain, target: self
            , action: #selector(handleSlideMenu))
        
        self.navigationItem.leftBarButtonItem = menuButton
        
        // add action swipe screen
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(recognizerSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(recognizerSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func recognizerSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            showSlideMenu()
        case UISwipeGestureRecognizerDirection.left:
            hideSlideMenu()
        default:
            break
        }
    }
    
    @objc func handleSlideMenu() {
        if isTouchSlideMenu {
            showSlideMenu()
        } else {
            hideSlideMenu()
        }
    }
    
    private func showSlideMenu() {
        menuController = self.storyboard?.instantiateViewController(withIdentifier: "MenuController") as? MenuController
        menuController?.view.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.width / 3) + (self.view.bounds.height / 5), height: 218 + (70 * 5))
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.addChildViewController(self.menuController!)
            self.view.addSubview(self.menuController!.view)
        }, completion: nil)
        isTouchSlideMenu = false
    }
    
    private func hideSlideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuController!.view.removeFromSuperview()
        }, completion: nil)
        isTouchSlideMenu = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("HomeCell", owner: self, options: nil)?.first as? HomeCell
            cell?.picture.image = categories[indexPath.row].picture
            return cell!
        }
        else {
            let cell = Bundle.main.loadNibNamed("HomeCategory", owner: self, options: nil)?.first as? HomeCategoryCell
            cell?.Label.text = categories[indexPath.row].label
            
            cell?.subLabel.text = categories[indexPath.row].subLabel
            cell?.picture.image = categories[indexPath.row].picture
            return cell!
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 180
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleCategory = categories[indexPath.row].label
        performSegue(withIdentifier: "sendCategory", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendCategory" {
            let categoryController = segue.destination as! CategoryProductController
            categoryController.titleCategory = titleCategory
        }
    }

}
