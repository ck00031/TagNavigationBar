//
//  ViewController.swift
//  testProject
//
//  Created by Alex on 2018/2/1.
//  Copyright © 2018年 Alex. All rights reserved.
//

import UIKit

protocol TagNavigationViewControllerDelegate {
    func cellDidSelect(row:Int, value:Any)
}

class TagNavigationViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var fullScreenSize :CGSize!
    var collectionView:UICollectionView!
    var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var delegate:TagNavigationViewControllerDelegate!
    let viewHeight:CGFloat = 50
    var cellBorderColor:UIColor = UIColor.darkGray
    var cellBorderWidth:CGFloat = 1
    var cellBackgroundColor:UIColor = UIColor.clear
    var cellTitleColor:UIColor = UIColor.darkGray
    var cellDidSelectedColor:UIColor = UIColor.init(red: 255.0/255.0, green: 87/255.0, blue: 51/255.0, alpha: 1)
    var tagNavigationBackgroundColor:UIColor = UIColor.gray
    var currentSelectedCellIndex:Int = 0
    var prefixTitleFont:UIFont = UIFont.systemFont(ofSize: 16)
    var cellTitleFont:UIFont = UIFont.systemFont(ofSize: 16)
    private var collectionPrefixLabel:UILabel = UILabel()
    var prefixTitle:String = "" {
        didSet {
            self.setPrefixTitle(title: self.prefixTitle)
        }
    }
    
    var data:Array<Dictionary<String,Any>> = [] {
        didSet {
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createCollectionView()
        
        //scroll cell to current selected index
        self.collectionView.scrollToItem(at: IndexPath.init(row: self.currentSelectedCellIndex, section: 0), at: .centeredHorizontally, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCollectionView(){
        self.fullScreenSize = UIScreen.main.bounds.size
        layout = UICollectionViewFlowLayout.init()
        //Set Collection Cell Item Size
        let layoutSize = CGSize(width: 100, height: self.viewHeight-20) // CGFloat, Double, Int
        layout.itemSize = layoutSize
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.frame = CGRect.init(x: 0, y: 20, width: self.fullScreenSize.width, height: self.viewHeight)
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = self.tagNavigationBackgroundColor
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TagNavigationCollectionCell.self, forCellWithReuseIdentifier:"TagNavigationCollectionCell")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionHeader")
        collectionPrefixLabel.frame = CGRect.zero
        collectionPrefixLabel.textColor = UIColor.black
        collectionPrefixLabel.textAlignment = .center
        collectionPrefixLabel.font = self.prefixTitleFont
        self.setPrefixTitle(title: self.prefixTitle)
        
        self.view.addSubview(collectionView)
    }
    
    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagNavigationCollectionCell", for: indexPath as IndexPath) as! TagNavigationCollectionCell
        
        //解決下拉更新時data source被清空，但依舊會呼叫此function導致crash的問題
        if indexPath.row > self.data.count{
            return myCell
        }
        
        //設定title
        if let titleString = self.data[indexPath.row]["key"] {
            myCell.setTitle(title: titleString as! String)
        }
        
        //設定是否選取
        if self.currentSelectedCellIndex == indexPath.row {
            myCell.isCellSelected = true
        }else{
            myCell.isCellSelected = false
        }
        
        myCell.cellTitleColor = self.cellTitleColor
        myCell.cellTitleFont = self.cellTitleFont
        myCell.cellBorderWidth = self.cellBorderWidth
        myCell.cellBorderColor = self.cellBorderColor
        myCell.cellBackgroundColor = self.cellBackgroundColor
        myCell.cellDidSelectedColor = self.cellDidSelectedColor
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let title = self.data[indexPath.row]["key"] {
            let titleString:String = title as! String
            let itemSize: CGSize = titleString.size(withAttributes: [NSAttributedStringKey.font: self.cellTitleFont])
            return CGSize.init(width: itemSize.width + 20, height: self.viewHeight-20)
        }
        return CGSize.init(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("did select item")
        self.currentSelectedCellIndex = indexPath.row
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let selectedItem = self.data[indexPath.row]["value"]
        self.delegate.cellDidSelect(row: indexPath.row, value: selectedItem)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.prefixTitle.characters.count > 0 {
            let itemSize: CGSize = self.prefixTitle.size(withAttributes: [NSAttributedStringKey.font: self.prefixTitleFont])
            return CGSize.init(width: itemSize.width + 20, height: self.viewHeight-20)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionHeader", for: indexPath)
            for subview in cell.subviews {
                subview.removeFromSuperview()
            }
            
            cell.addSubview(self.collectionPrefixLabel)
            
            return cell
        }
        
        return UICollectionReusableView.init()
    }
    
    func setPrefixTitle(title:String){
        if self.collectionPrefixLabel != nil && self.collectionView != nil {
            self.collectionPrefixLabel.text = title
            if title.characters.count > 0 {
                self.collectionPrefixLabel.sizeToFit()
                self.collectionPrefixLabel.frame = CGRect.init(x: 0, y: 0, width: self.collectionPrefixLabel.frame.size.width, height: self.collectionView.frame.size.height)
                self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
            }else{
                self.collectionPrefixLabel.frame = CGRect.zero
                self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
            }
        }
    }
}

