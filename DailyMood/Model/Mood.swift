//
//  Mood.swift
//  DailyMood
//
//  Created by kino on 14-7-15.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import Foundation



class Mood: NSObject {

    var moodType: NSNumber
    
    enum MoodType:Int{
        case Smile = 0, Angry, Confused, Cool, Grin, Happy, Neutral, Sad, Shock, Tongue, Wink, Wondering
        
        func getImageName()->String{
            switch(self){
                case .Smile:
                    return "smiley"
                case .Angry:
                    return "angry"
                case .Confused:
                    return "confused"
                case .Cool:
                    return "cool"
                case .Grin:
                    return "grin"
                case .Happy:
                    return "happy"
                case .Neutral:
                    return "neutral"
                case .Sad:
                    return "sad"
                case .Shock:
                    return "shocked"
                case .Tongue:
                    return "tongue"
                case .Wink:
                    return "wink"
                case .Wondering:
                    return "wondering"
            default:
                return ""
            }
        }
    }
    
    var crrentType:MoodType = MoodType.Smile
    
    init() {
        
        self.moodType = NSNumber(integer: crrentType.toRaw())
        
        super.init()
        
    }
    
    class func moodByIndex(typeIndex:Int)->Mood{
        let mood = Mood()
        
//        let idx:Int = typeIndex as Int
        println("typeIndex = \(typeIndex)")
        mood.moodType = NSNumber(integer:typeIndex)
        mood.crrentType = MoodType.fromRaw(typeIndex)!
        
        return mood
    }
    
    

}
