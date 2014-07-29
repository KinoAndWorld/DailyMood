//
//  DailyCell.swift
//  DailyMood
//
//  Created by kino on 14-7-11.
//  Copyright (c) 2014 kino. All rights reserved.
//

import UIKit
import Foundation
//import Daily

class DailyCell: UITableViewCell {
    
    @IBOutlet var timeLabel : UILabel
    @IBOutlet var locationLabel : UILabel
    @IBOutlet var contentLabel : UILabel
    
    @IBOutlet var moodImageView : UIImageView
    @IBOutlet var weatherImageView : UIImageView
    
    @IBOutlet var backgroundImageView: UIImageView
    
    
    
    func configCellByModel(model:Daily?){
        timeLabel.font = dailyFont(15.0)
        contentLabel.font = dailyFont(15.0)
        locationLabel.font = dailyFont(13.0)
        
        
        
        self.contentLabel.text = model?.content
        
        if model?.contentColor == nil { println("fucccccccck") }
        if let colorStr = model?.contentColor as? String{
            let contentColor = CIColor(string: colorStr)
            self.contentLabel.textColor = UIColor(CIColor: contentColor)
        }
        println("location = \(model?.location)")
        
        if model?.location != nil{
            locationLabel.text = model?.location.detailAddress
        }
        
        timeLabel.text = model?.time.stringMMDDHHmmByChinese()
        
        var moodTypeIdx = model?.moodType.integerValue as Int
        if let mood = Mood.moodByIndex(moodTypeIdx) as Mood?{
            var imageName = mood.crrentType.getImageName()
            moodImageView.image = UIImage(named: imageName)
        }
        
        var weatherIdx = model?.weatherState.integerValue as Int
        if let weather = Weather.weatherByStateIndex(weatherIdx) as Weather?{
            var imageName = weather.weatherState?.getImageName()
            weatherImageView.image = UIImage(named: imageName)
        }
        
        self.backgroundImageView.image = nil
        
        if let backImage = UIImage(data: model?.backImage) as UIImage?{
            self.backgroundImageView.image = backImage
//            model?.calcTextColor()
//            let color = fetchContentColorByBackImage(backImage)
//            contentLabel.textColor = color
        }else{
            var randomX:Float =  Float(arc4random_uniform(10)) / 20
            
            self.backgroundImageView.backgroundColor = UIColor(red: 0.2 + randomX, green: 0.7, blue: 0.4 + randomX, alpha: 0.8)
        }
        self.backgroundImageView.height = self.contentView.height
    }
    
    
}
