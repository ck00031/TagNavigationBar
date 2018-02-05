//
//  rootViewController.swift
//  testProject
//
//  Created by Alex on 2018/2/2.
//  Copyright © 2018年 Alex. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController,TagNavigationViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        var exampleArray:Array<Dictionary<String,Any>> = []
        
        for index in 1...20 {
            var exampleDictionary:Dictionary<String,Any> = [:]
            var valueDic:Dictionary<String,String> = [:]
            valueDic["type"] = "internal"
            valueDic["action"] = "webView"
            valueDic["url"] = "http://www.google.com"
            
            //key for cell title
            exampleDictionary["key"] = "abadfadfac\(index)"
            //value for return to process
            exampleDictionary["value"] = valueDic
            exampleArray.append(exampleDictionary)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        let tagCollectionVC:TagNavigationViewController = TagNavigationViewController()
        tagCollectionVC.delegate = self
        //set data
        tagCollectionVC.data = exampleArray
        //set prefix title
        tagCollectionVC.prefixTitle = "Test PrefixTitle"
        //set cell's border color
        tagCollectionVC.cellBorderColor = UIColor.clear
        //set cell's border width
        tagCollectionVC.cellBorderWidth = 1
        //set cell's title color
        tagCollectionVC.cellTitleColor = UIColor.white
        //set cell's unselected background color
        tagCollectionVC.cellBackgroundColor = UIColor.init(red: 255.0/255.0, green: 189/255.0, blue: 51/255.0, alpha: 1)
        //set tagCollectionView background color
        tagCollectionVC.tagNavigationBackgroundColor = UIColor.yellow
        //set witch cell selected
        tagCollectionVC.currentSelectedCellIndex = 3
        //set cell's didselect color
        tagCollectionVC.cellDidSelectedColor = UIColor.init(red: 255.0/255.0, green: 87/255.0, blue: 51/255.0, alpha: 1)
        
        //Add viewController to childViewController
        self.addChildViewController(tagCollectionVC)
        
        self.view.addSubview(tagCollectionVC.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TagNavigationViewControllerDelegate
    func cellDidSelect(row: Int, value: Any) {
        //you can use row number or value to dicide what you want to do
        print("didselectCellRow:\(row) itemData:\(value)")
        
        //For Example
        //you can get the action and type and url from value
    }
}
