//
//  MainBottomView.swift
//  DailyMood
//
//  Created by kino on 14-7-11.
//  Copyright (c) 2014 kino. All rights reserved.
//

import UIKit

@IBDesignable class MainBottomView: UIView {
    
    @IBOutlet var addButton:UIButton
    
    var backColor:UIColor?
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
    didSet {
        layer.borderColor = borderColor.CGColor
    }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
        layer.borderWidth = borderWidth
    }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
        layer.cornerRadius = cornerRadius
    }
    }
    
    //addButton block
    typealias AddButtonBlock = (button:UIButton)->Void
    var addButtonAction:AddButtonBlock? = nil
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        backColor = self.backgroundColor
        self.backgroundColor = UIColor.grayColor()
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.backgroundColor = backColor
        var touch:UITouch = event.allTouches().anyObject() as UITouch
        var point:CGPoint = touch.locationInView(self)
        
        println("x:\(point.x)  y:\(point.y)")
        
        if(point.x >= 0 &&
            point.y >= 0 &&
            point.x <= addButton.frame.size.width &&
            point.y <= addButton.frame.size.height){
            println("ok")
            addButtonAction?(button: addButton)
        }
    }
}
