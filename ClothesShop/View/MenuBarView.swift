//
//  MenuBarView.swift
//  ClothesShop
//
//  Created by ngovantucuong on 11/26/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class MenuBarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    let cellID = "cellID"
    var category = [String]()
    var categoriesController: CategoryProductController?
    var cartController: CartController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.backgroundColor = UIColor.white
        cl.dataSource = self
        cl.delegate = self
        return cl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(collectionView)
        
        addConstrantWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstrantWithFormat(format: "V:|[v0]-8-|", views: collectionView)
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.black
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.layer.cornerRadius = 4
        horizontalBarView.layer.masksToBounds = true
        addSubview(horizontalBarView)
        
        let paddingLeft = (frame.width / 3) / 2
        horizontalBarLeftAnchorConstraint = NSLayoutConstraint(item: horizontalBarView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: paddingLeft)
        addConstraint(horizontalBarLeftAnchorConstraint!)
       
        horizontalBarView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        horizontalBarView.widthAnchor.constraint(equalToConstant: 8).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MenuCell
        let textCategory = category[indexPath.item]
        cell?.nameCategory.text = textCategory
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countCategories: CGFloat = CGFloat(category.count)
        return CGSize(width: frame.width / countCategories, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoriesController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
}

class MenuCell: BaseCell {
    var nameCategory: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textAlignment = .center
        lb.numberOfLines = 1
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            nameCategory.tintColor = isHighlighted ? UIColor.black: UIColor(r: 163, g: 164, b: 167)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            nameCategory.textColor = isSelected ? UIColor.black : UIColor(r: 163, g: 164, b: 167)
        }
    }
    
    override func setupViews() {
        addSubview(nameCategory)
        
        addConstrantWithFormat(format: "H:|[v0]|", views: nameCategory)
        addConstrantWithFormat(format: "V:|-8-[v0]|", views: nameCategory)
    }
}
