//
//  AddDailyVC.swift
//  DailyMood
//
//  Created by kino on 14-7-12.
//  Copyright (c) 2014 kino. All rights reserved.
//

import UIKit
import QuartzCore

class AddDailyVC: BaseViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    @IBOutlet var containerScrollView : UIScrollView
    @IBOutlet var dailyTextView : UITextView
    
    
    @IBOutlet var moodButton : UIButton
    @IBOutlet var pictureButton : UIButton
    @IBOutlet var locationButton : UIButton
    @IBOutlet var weatherButton : UIButton
    
    var dailyModel:Daily = Daily.MR_createEntity(){
    willSet{
        if dailyModel != nil{
            dailyModel.MR_deleteEntity()
            currentType = EditType.EditDaily
        }
    }
    }
    
    var isShouldSave:Bool = false
    var isShouldBack = true
    
    enum EditType{
        case AddDaily, EditDaily
    }
    var currentType = EditType.AddDaily
    
    func constructViewByUpdateState(model:Daily){
        println("model = \(model)")
        dailyTextView.text = model.content
        
        let mood = Mood.moodByIndex(model.moodType.integerValue)
        moodButton.setImage(UIImage(named: mood.crrentType.getImageName()),
            forState: UIControlState.Normal)
        
        let weather = Weather.weatherByStateIndex(model.weatherState.integerValue)
        weatherButton.setImage(UIImage(named: weather.weatherState?.getImageName()),
            forState: UIControlState.Normal)
        if let backImage = model.backImage as NSData?{
            pictureButton.setImage(UIImage(data: backImage),
                forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func finishDailyAction(sender : AnyObject) {
        
    }
    
    func checkDailyVaild()->String?{
        if countElements(dailyModel.content) == 0 {return "The Daily Content can no be blank"}
        return nil
    }
    
    ///life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataAndViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:",
            name:UIKeyboardWillShowNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillhide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        isShouldBack = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dailyTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if isShouldSave == false &&
            isShouldBack &&
            currentType == EditType.AddDaily{
            dailyModel.MR_deleteEntity()
        }
    }
    
    ///
    func initDataAndViews(){
        self.setRightSaveItem()
        dailyTextView.font = dailyFont(18.0)
        if currentType == EditType.EditDaily{
            constructViewByUpdateState(dailyModel)
        }
    }
    
    override func saveItemAction() {
        dailyModel.content = dailyTextView.text
        dailyModel.time = NSDate()
        let col = CIColor(CGColor: UIColor.whiteColor().CGColor)
        dailyModel.contentColor = col.stringRepresentation()
        
        if dailyModel.location == nil{
            dailyModel.location = DailyLocation.defaultLocaion
        }
        
        
        //done some thing
        if let error:String = checkDailyVaild(){
            
            let alert = UIAlertView(title: error,
                message: "",
                delegate: nil,
                cancelButtonTitle: "Well")
            alert.show()
        }else{
            
            isShouldSave = true
            self.navigationController.popToRootViewControllerAnimated(true)
            
            switch currentType{
            case .EditDaily:
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            case .AddDaily:
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.dailyModel.calcTextColor()
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    })
            }
        }
    }
    
    ///keyboard
    func keyboardWillShow(notif:NSNotification){
        updateScrollViewByNotif(notif)
    }
    
    func keyboardWillhide(notif:NSNotification){
        updateScrollViewByNotif(notif)
    }
    
    func updateScrollViewByNotif(notif:NSNotification){
        let value:NSValue = notif.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        var keyboardSize:CGSize = value.CGRectValue().size
        containerScrollView.height = UIScreen.mainScreen().bounds.height - keyboardSize.height - containerScrollView.top - 5
    }
    
    
    //DashBoard
    enum Component:Int{
        case Mood = 0, Picture, Location, Weather
    }
    
    var component:AddDailyComponent? = nil
    
    @IBAction func addComponentAction(sender : AnyObject) {
        var tag4Component:Component = Component.fromRaw(sender.tag!)!
        
        self.view.endEditing(true)
        
        switch tag4Component{
        case .Mood:
            println("mood")
//            component = MoodComponent(controller: self)
            
            let moodChose = MoodChoseVC()
            self.useBlurForPopup = true
            self.presentPopupViewController(moodChose, animated: true, completion: nil)
            moodChose.moodFinishBlock = { mood, cellFrame in
                
                self.dailyModel.moodType = mood.moodType
                //animation
                let realFrame = CGRect(origin: CGPoint(x: cellFrame.origin.x + moodChose.view.left,
                    y: cellFrame.origin.y + moodChose.view.top),
                    size: cellFrame.size)
                var moveView:UIView? = UIView(frame: realFrame)
//                println("left:\(cellFrame.origin.x)  top:\(cellFrame.origin.y)")
//                moveView.backgroundColor = UIColor.yellowColor()
                var moodImageView = UIImageView(image: UIImage(named: mood.crrentType.getImageName()))
                moodImageView.frame = CGRect(x: 16, y: 7, width: 32, height: 32)
                moveView!.addSubview(moodImageView)
                
                self.view.addSubview(moveView)
                
                self.dismissPopupViewControllerAnimated(true, completion: {
                    var moveAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                    moveAnim.springBounciness = 12
                    moveAnim.toValue = NSValue(CGPoint: CGPoint(x: self.moodButton.left + self.containerScrollView.left + self.moodButton.width/2, y: self.containerScrollView.top + self.moodButton.top + self.moodButton.height/2))
                    moveView!.layer.pop_addAnimation(moveAnim, forKey: "moveMood")
                    
                    moveAnim.completionBlock = { popAnim , finish in
                        if finish {
                            self.moodButton.setImage(moodImageView.image, forState: UIControlState.Normal)
                            moveView!.hidden = true
                            moveView = nil
                        }
                    }
                });
            }
            
            
        case .Picture:
            isShouldBack = false
            println("pic")
            var finishBlock:(UIImage)->Void = {[weak self] image in
                println("The finish Image \(image.description)")
                if let weakSelf = self{
//                    var fixedImage:UIImage? = image.resizedImage(CGSize(width: weakSelf.pictureButton.size.width, height: weakSelf.pictureButton.size.height), interpolationQuality: kCGInterpolationHigh)
                    
//                    if (fixedImage != nil){
                        weakSelf.pictureButton.setImage(image, forState: UIControlState.Normal)
                        weakSelf.dailyModel.backImage = UIImagePNGRepresentation(image)
//                    }
                }
            }
            component = PictureComponent(controller: self, pictureFinish: finishBlock)
            component!.showComponent()
            
        case .Location:
            println("loca")
//            (currentLocation:CLLocation?, status:LocationState, error:NSError?)->Void
            var exist: AnyObject! = locationButton.layer.pop_animationForKey("rotateMe")
            if exist { return }
            
            var rotateAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
            rotateAnim.duration = 20.0
            rotateAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            rotateAnim.fromValue = NSNumber(double: 0.0)
            rotateAnim.toValue = NSNumber(double: M_PI * 50.0)
            
//            rotateAnim.toValue = NSNumber(float: UIScreen.mainScreen().bounds.height - bottomView.height)
//            rotateAnim.springBounciness = 15
            //        upAnim.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            locationButton.layer.pop_addAnimation(rotateAnim, forKey: "rotateMe")
            
            KOLocationManager.sharedInstance.requestLocation(20.0, block: {currentLocation, state, err in
                self.locationButton.layer.transform = CATransform3DIdentity
                self.locationButton.layer.pop_removeAllAnimations()
                
                switch(state){
                    case .Succeed:
                        println("Succeed")
                        
                        self.dailyModel.connectLocation(currentLocation!)
                        let alert = UIAlertView(title: "Locate Succeed",
                            message: "Address:\(currentLocation?.detailAddress)",
                            delegate: nil,
                            cancelButtonTitle: "Well")
                        alert.show()
                    default:
                        println("eeeee")
                        let alert = UIAlertView(title: "定位失败",
                            message: "网络错误或者定位未开启哦",
                            delegate: nil,
                            cancelButtonTitle: "Well")
                        alert.show()
                }
            })
            
        case .Weather:
            
            let weatherChose = WeatherChoseVC()
            self.useBlurForPopup = true
            self.presentPopupViewController(weatherChose, animated: true, completion: nil)
            
            weatherChose.weatherFinishBlock = { weather in
//                dailyModel
                var weatherIcon:String? = weather.weatherState?.getImageName()
                if let iconImage:UIImage? = UIImage(named: weatherIcon) as UIImage? {
                    self.weatherButton.setImage(iconImage, forState: UIControlState.Normal)
                    
                    self.dailyModel.weatherState = NSNumber(integer: weather.weatherState!.toRaw())
                    self.dismissPopupViewControllerAnimated(true, completion: nil)
                }
            }
            
        default:
            println("other")
        }
    }
}
