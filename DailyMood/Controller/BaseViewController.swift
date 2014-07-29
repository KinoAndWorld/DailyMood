//
//  BaseViewController.swift
//  DailyMood
//
//  Created by kino on 14-7-11.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    func setLeftSettingItem(){
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        btn.setBackgroundImage(UIImage(named: "more"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "settingItemAction", forControlEvents: UIControlEvents.TouchUpInside)
        let barItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func settingItemAction(){
        
    }
    
    
    //===========================================
    func setRightSaveItem(){
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btn.setBackgroundImage(UIImage(named: "saveIn"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "saveItemAction", forControlEvents: UIControlEvents.TouchUpInside)
        let barItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func saveItemAction(){
        
    }
    
    
    
}
