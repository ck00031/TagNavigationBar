//
//  tagNavigationCollectionCell.swift
//  testProject
//
//  Created by Alex on 2018/2/2.
//  Copyright © 2018年 Alex. All rights reserved.
//
import Foundation
import UIKit

class TagNavigationCollectionCell: UICollectionViewCell {
    var titleLabel:UILabel = UILabel()
    var isCellSelected:Bool = false {
        didSet {
            self.setSelectedColor()
        }
    }
    
    var cellBorderColor:UIColor = UIColor.darkGray {
        didSet {
            self.layer.borderColor = cellBorderColor.cgColor
        }
    }
    var cellBorderWidth:CGFloat = 1 {
        didSet {
            self.layer.borderWidth = cellBorderWidth
        }
    }
    var cellBackgroundColor:UIColor = UIColor.clear {
        didSet {
            self.setSelectedColor()
        }
    }
    var cellTitleColor:UIColor = UIColor.darkGray {
        didSet {
            self.titleLabel.textColor = cellTitleColor
        }
    }
    var cellDidSelectedColor:UIColor = UIColor.init(red: 255.0/255.0, green: 87/255.0, blue: 51/255.0, alpha: 1) {
        didSet {
            self.setSelectedColor()
        }
    }
    var cellTitleFont:UIFont = UIFont.systemFont(ofSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderWidth = self.cellBorderWidth
        self.layer.borderColor = self.cellBorderColor.cgColor
        self.backgroundColor = self.cellBackgroundColor
        
        let titleLabelOriginX:CGFloat = 10
        let titleLabelOriginY:CGFloat = 0
        let titleLabelWidth:CGFloat = self.frame.size.width - 20
        let titleLabelHeight:CGFloat = self.frame.size.height
        titleLabel.frame = CGRect.init(x: titleLabelOriginX, y: titleLabelOriginY, width: titleLabelWidth, height: titleLabelHeight)
        titleLabel.font = self.cellTitleFont
        titleLabel.textColor  = self.cellTitleColor
        
        self.addSubview(titleLabel)
    }
    
    open func setTitle(title:String) {
        if title.characters.count > 0 {
            self.titleLabel.text = title
            self.titleLabel.sizeToFit()
            let titleLabelOriginX:CGFloat = 10
            let titleLabelOriginY:CGFloat = 0
            let titleLabelHeight:CGFloat = self.frame.size.height
            titleLabel.frame = CGRect.init(x: titleLabelOriginX, y: titleLabelOriginY, width: self.titleLabel.frame.size.width, height: titleLabelHeight)
        }
    }
    
    private func setSelectedColor(){
        if self.isCellSelected {
            self.backgroundColor = self.cellDidSelectedColor
        }else{
            self.backgroundColor = self.cellBackgroundColor
        }
    }
}
