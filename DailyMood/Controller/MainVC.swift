//
//  MainVC.swift
//  DailyMood
//
//  Created by kino on 14-7-11.
//  Copyright (c) 2014 kino. All rights reserved.
//

import UIKit
//import MainBottomView
import CustomView
import QuartzCore


//view
//import DailyCell

class MainVC: BaseViewController , UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    
    @IBOutlet var bottomView : MainBottomView
    
    @IBOutlet var tableView : UITableView
    
    @IBAction func showSettingVC(sender : UIBarButtonItem) {
        showSettingAnimator.style = KWTransitionStyle.RotateFromTop
        showSettingAnimator.duration = 0.5
        showSettingAnimator.action = KWTransitionStep.Present
        
        self.transitionClassName = "KWTransitionStyleNameRotateFromTop"
        self.performSegueWithIdentifier("setting", sender: nil)
    }
    var transitionClassName:NSString = ""
    
    var addDailyAnimator:UIViewControllerAnimatedTransitioning = AddDailyAnimator()
    var showSettingAnimator:KWTransition = KWTransition.manager()
    var dailys:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.setLeftSettingItem()
        
        self.navigationController.delegate = self;
        
        bottomView.addButtonAction = {button in
            self.transitionClassName = ""
            self.performSegueWithIdentifier("addDaily", sender: nil)
        }
        
        
        self.navigationController.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.brownColor(),
                NSFontAttributeName : dailyFont(22)]
        //返回按钮 颜色
        self.navigationController.navigationBar.tintColor = UIColor.brownColor();
        
//        let dailyLoc = DailyLocation.locationWithCoor(CLLocationCoordinate2DMake(23.2313, 121.2423423), detailAddress: "1223 ")
//        let coor = CLLocationCoordinate2D(latitude: 23.521, longitude: 121.213)
//        let dailyLoc = DailyLocation.MR_createEntity()
//        dailyLoc.lat = NSNumber(double: coor.latitude)
//
//        let daily = Daily.MR_createEntity()
//        daily.content = "123"
        
//        tableView.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        
//        self.bottomView.configSubViews();
        
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableView.contentInset.bottom + bottomView.frame.size.height, right: 0)
        
//        let fonts:NSArray = UIFont.familyNames() as NSArray
//        for(var i = 0 ; i < fonts.count ; i++){
//            let family:String = fonts[i] as String
//            let fontNames = UIFont.fontNamesForFamilyName(family) as NSArray
//            
//            for(var j = 0; j < fontNames.count ; j++){
//                println("Font Name: \(fontNames[j])")
//            }
//        }
    }
    
    func fetchAllDailyFromDB()->NSArray{
        return Daily.MR_findAll()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        bottomView.top = UIScreen.mainScreen().bounds.height
        bottomView.addButton.enabled = false
        
        var upAnim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        upAnim.toValue = NSNumber(float: UIScreen.mainScreen().bounds.height - bottomView.height)
        upAnim.springBounciness = 15
//        upAnim.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        bottomView.layer.pop_addAnimation(upAnim, forKey: "upMe")
        
        upAnim.completionBlock = {popAnim , finish in
            if(finish){
                self.bottomView.addButton.enabled = true
            }
        }
        
        ///data 
        
        //fetch all daily
        self.dailys = fetchAllDailyFromDB()
        if(self.dailys.count == 0){
            let isLunachMore:Bool = UserDef.boolForKey("isLunachMore")
            if isLunachMore == false{
                self.dailys = Daily.createDefaultDatas()
                NSLog("dailys:::::::::%@", self.dailys)
                NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
            }
        }
        
        tableView.reloadData()
        NSLog("dailys: %@", self.dailys)
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return dailys.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell:DailyCell = tableView.dequeueReusableCellWithIdentifier("DailyCell", forIndexPath:indexPath) as DailyCell
        
        println(" count:\(dailys.count)  index : \(indexPath.row)")
        
//        var obj:AnyObject? = dailys.objectAtIndex(indexPath.row)
//        let realDaily = obj! as? Daily
        
        var daily:Daily = (dailys.objectAtIndex(indexPath.row) as Daily)
        cell.configCellByModel(daily)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
//        cell.top += cell.height
//        cell.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.25, animations: {
//            cell.top -= cell.height
//            cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        switch editingStyle{
        case .Delete:
            UIAlertView.showWithTitle("往事如烟", message: "回忆不再？",
                style: UIAlertViewStyle.Default,
                cancelButtonTitle: "不想放弃",
                otherButtonTitles: ["后会无期"],
                tapBlock: { alertView, buttonIndex in
                    if buttonIndex == 1{
                        
                        (self.dailys[indexPath.row] as Daily).MR_deleteEntity()
                        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                        
                        let muatArr = NSMutableArray(array: self.dailys)
                        muatArr.removeObjectAtIndex(indexPath.row)
                        
                        self.dailys = muatArr
                        
                        tableView.beginUpdates()
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                        tableView.endUpdates()
                    }
                })
        default:
            println("")
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddDailyVC") as AddDailyVC
        destVC.dailyModel = self.dailys[indexPath.row] as Daily
        self.navigationController.pushViewController(destVC, animated: true)
    }
    
    /// navgation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.identifier == "addDaily"){
            NSLog("%@", NSStringFromClass(segue.destinationViewController.classForCoder))
            
            var dest:UIViewController = segue.destinationViewController as UIViewController
        }
    }
    
    
    override func settingItemAction(){
        showSettingAnimator.style = KWTransitionStyle.RotateFromTop
        showSettingAnimator.duration = 0.5
        showSettingAnimator.action = KWTransitionStep.Present
        
        self.transitionClassName = "KWTransitionStyleNameRotateFromTop"
        self.performSegueWithIdentifier("setting", sender: nil)
    }
    
    ///transitioning
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning!{
        
        if (self.transitionClassName.hasPrefix("KWTransition")){
            return self.showSettingAnimator
        }else{
            if(operation == UINavigationControllerOperation.Push){
                return self.addDailyAnimator
            }
        }
        
        return nil
    }
    
    //interAction
    func navigationController(navigationController: UINavigationController!, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!{
        return nil
    }
}
