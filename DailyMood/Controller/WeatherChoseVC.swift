//
//  WeatherChoseVC.swift
//  DailyMood
//
//  Created by kino on 14-7-15.
//  Copyright (c) 2014 kino. All rights reserved.
//

import UIKit

class WeatherChoseVC: UIViewController {

    @IBOutlet var titleLabel: UILabel
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.font = dailyFont(17.0)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    typealias weatherBeSelectBlock = (Weather)->Void
    var weatherFinishBlock:weatherBeSelectBlock? = nil
    
    @IBAction func choseWeatherAction(sender: UIButton) {
        let tag = sender.tag as Int
        println("weather index :\(tag)")
        let weather:Weather = Weather.weatherByStateIndex(tag)
        
        weatherFinishBlock?(weather)
//        swtch(tag){
//            case
//        }
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
