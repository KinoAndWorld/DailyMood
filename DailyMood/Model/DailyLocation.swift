//
//  DailyLocation.swift
//  DailyMood
//
//  Created by kino on 14-7-15.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import Foundation
import CoreData

@objc(DailyLocation)
class DailyLocation: NSManagedObject {

    @NSManaged var detailAddress: String
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    @NSManaged var daily: Daily
    
    class var defaultLocaion:DailyLocation{
        let loc:DailyLocation = DailyLocation.MR_createEntity()
            loc.lat = NSNumber(double: 0.0)
            loc.lon = NSNumber(double: 0.0)
            loc.detailAddress = "在一个莫名其妙的地方"
        return loc
    }

    class func locationWithCoor(coor:CLLocationCoordinate2D, detailAddress:String)->DailyLocation{
        
        let loc:DailyLocation = DailyLocation.MR_createEntity()
        let lat:Double = coor.latitude
        let lon:Double = coor.longitude
        loc.lat = NSNumber(double: lat)
        loc.lon = NSNumber(double: lon)
        loc.detailAddress = detailAddress
        return loc
    }
    
    class func entityName()->NSString{
        return "DailyLocation"
    }
}
