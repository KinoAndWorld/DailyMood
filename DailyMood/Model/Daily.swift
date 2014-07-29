//
//  Daily.swift
//  DailyMood
//
//  Created by kino on 14-7-15.
//  Copyright (c) 2014 kino. All rights reserved.
//

import Foundation
import CoreData

@objc(Daily)

class Daily: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var backImage: NSData
    @NSManaged var moodType: NSNumber
    @NSManaged var location: DailyLocation
    @NSManaged var time: NSDate
    @NSManaged var weatherState: NSNumber
    
    @NSManaged var contentColor:String
    

    class func entityName()->NSString{
        return "Daily"
    }
    
    func checkDailyVaild()->String?{
        if countElements(content) == 0 {return "The Daily Content can no be blank"}
        return nil
    }
    
    class func createDefaultDatas()->NSArray{
        let d1 = Daily.MR_createEntity()
        d1.content = "Welcome to my app, you can write down your mood in it. I hope you can find the way to explore your everyThing :) "
        let location = DailyLocation.MR_createEntity()
        location.detailAddress = "The Earth"
        d1.location = location
        d1.time = NSDate()
        d1.weatherState = NSNumber(integer: 0)
        d1.moodType = NSNumber(integer: 0)
        
        let col = CIColor(CGColor: UIColor.whiteColor().CGColor)
        d1.contentColor = col.stringRepresentation()
        return NSArray(object: d1)
    }
    
    func connectLocation(addLoc:DailyLocation){
        if self.location != nil{
            self.location.MR_deleteEntity()
        }
        self.location = addLoc
    }
    
    func calcTextColor(){
        if let hasImage = UIImage(data: self.backImage) as UIImage?{
            let color = fetchContentColorByBackImage(hasImage)
            
            let colStr = CIColor(CGColor: color.CGColor).stringRepresentation()
            println("\(colStr)")
            
            contentColor = colStr
        }
    }
    
    func fetchContentColorByBackImage(backImage:UIImage)->UIColor{
        let isBlack = backImage.isNearBlackOrWhite(320, height: 100)
        if isBlack{return UIColor.blackColor()  } else { return UIColor.whiteColor() }
    }
    
}
