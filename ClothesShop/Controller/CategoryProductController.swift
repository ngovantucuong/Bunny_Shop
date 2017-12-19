//
//  CategoryProductController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/23/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class CategoryProductController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    @IBOutlet weak var menuBar: MenuBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleCategory: String?
    let feedID = "feedID"
    var products: [Product]?
    let urlJsonCategoryWomen = ["https://api.myjson.com/bins/1g51qr", "https://api.myjson.com/bins/14aisz", "https://api.myjson.com/bins/9a1wj"]
    let urlJsonCategoryMen = ["https://api.myjson.com/bins/oxboj", "https://api.myjson.com/bins/yg9cz", "https://api.myjson.com/bins/w4o3n"]
    let categoriesWomen = ["Skirts", "T-Shirts", "Pants&Leggings"]
    let categoriesMen = ["T-Shirts", "Suits", "Jeans"]
    var countCategory: CGFloat?
    var filtered:[Product] = []
    var searchActive : Bool = false
    let searchBar = UISearchBar()
    var feedCell: FeedCell?
    var isTapSearchButton: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: feedID)
        
        menuBar.categoriesController = self
        setupBarItem()
        
        searchBar.delegate = self
    }
    
    func setupBarItem() {
        if titleCategory == "MEN" {
            menuBar.category = categoriesMen
            countCategory = CGFloat(categoriesMen.count)
        } else {
            menuBar.category = categoriesWomen
            countCategory = CGFloat(categoriesWomen.count)
        }
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = titleCategory
        label.font = UIFont.systemFont(ofSize: 16)
        self.navigationItem.titleView = label
        
        let image = UIImage(named: "findIcon")?.withRenderingMode(.alwaysOriginal).resizeImage(targetSize: CGSize(width: 30, height: 30))
        let buttonSearch = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSearch))
        self.navigationItem.rightBarButtonItem = buttonSearch
        
        let leftBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @objc func handleSearch() {
        if isTapSearchButton {
           self.navigationItem.titleView = searchBar
            self.isTapSearchButton = false
        } else {
            setupBarItem()
            self.isTapSearchButton = true
        }
        
    }
    
    // transfer item correcponding of collection when pick menuBar
    func scrollToMenuIndex(menuIndex: Int) {
        let indexpath = NSIndexPath(item: menuIndex, section: 0) as  IndexPath
        collectionView?.scrollToItem(at: indexpath, at: .left, animated: true)
    }
    
    // change menu bar correspond with item of collectionview
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        
        self.menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paddingLeft: CGFloat = 60
        menuBar.horizontalBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x / countCategory!) + paddingLeft
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count: Int?
        if titleCategory == "MEN" {
            count = categoriesMen.count
        } else {
            count = categoriesWomen.count
        }
        
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedID, for: indexPath) as? FeedCell
        cell?.productArray = products
        cell?.categoryController = self
        cell?.navigationController = self.navigationController
        feedCell = cell
        
        
        if titleCategory == "MEN" {
            cell?.stringJsonData = urlJsonCategoryMen[indexPath.item]
        } else {
            cell?.stringJsonData = urlJsonCategoryWomen[indexPath.item]
        }

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = (self.feedCell?.productArray?.filter({ (item) -> Bool in
            let countryText: NSString = item.nameProduct as NSString
        
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                }))!
        
        if(filtered.count == 0){
            searchActive = false;
            self.feedCell?.searchActive = false
            self.feedCell?.productFilterArray = filtered
            self.feedCell?.collectionview.reloadData()
        } else {
            searchActive = true;
            self.feedCell?.searchActive = true
            self.feedCell?.productFilterArray = filtered
            self.feedCell?.collectionview.reloadData()
        }
    }

}
