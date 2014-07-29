//
//  MoodCell.swift
//  DailyMood
//
//  Created by kino on 14-7-16.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class MoodCell: UICollectionViewCell {

    @IBOutlet var moodButton: UIButton
    @IBOutlet var moodLabel: UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCellByModel(model:Mood?){
        
        moodButton.setImage(UIImage(named: model?.crrentType.getImageName()), forState: UIControlState.Normal)
        moodLabel.text = model?.crrentType.getImageName()
        
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
//        self.layer.masksToBounds = true
//        self.layer.borderWidth = 3
//        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        
//        self.layer.cornerRadius = 32
        
//        self.layer.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 0.7).CGColor
        
    }
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.layer.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.25, alpha: 0.1).CGColor
        
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent:event)
        
        let delay = 0.3 * Double(NSEC_PER_SEC)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue(), {
            self.layer.shadowOpacity = 0.0
            self.layer.backgroundColor = UIColor.clearColor().CGColor
            self.layer.borderWidth = 0
        })
        
    }
    
    
}
