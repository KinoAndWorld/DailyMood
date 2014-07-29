//
//  MoodChoseVC.swift
//  DailyMood
//
//  Created by kino on 14-7-15.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class MoodChoseVC: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet var moodCollectionView: UICollectionView
    
    typealias moodBeSelectBlock = (Mood,CGRect)->Void
    var moodFinishBlock:moodBeSelectBlock? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.moodCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        moodCollectionView.registerNib(UINib(nibName: "MoodCell", bundle: nil), forCellWithReuseIdentifier: "MoodCell")
        moodCollectionView.backgroundColor = UIColor.clearColor()
        moodCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int{
        return 12
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MoodCell", forIndexPath: indexPath) as MoodCell
        
//        cell.contentView.backgroundColor = UIColor.
        cell.configCellByModel(Mood.moodByIndex(indexPath.row))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let cell:MoodCell = collectionView.cellForItemAtIndexPath(indexPath) as MoodCell
        var cellFrame = cell.frame
        
//        cellFrame = collectionView.convertRect(cell.frame, fromView: cell)
        
        cellFrame = CGRect(origin: CGPoint(x: cell.left + collectionView.left,
                                           y: cell.top + collectionView.top),
                            size: cell.frame.size)
        
        moodFinishBlock?(Mood.moodByIndex(indexPath.row),cellFrame)
    }

}
