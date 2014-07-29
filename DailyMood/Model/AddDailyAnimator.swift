//
//  AddDailyAnimator.swift
//  DailyMood
//
//  Created by kino on 14-7-12.
//  Copyright (c) 2014 kino. All rights reserved.
//

import UIKit
import CustomView

class AddDailyAnimator: NSObject , UIViewControllerAnimatedTransitioning{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval{
        return 0.55
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!){
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        transitionContext.containerView().addSubview(toVC.view)
        toVC.view.alpha = 0.0
        
        let bottomView:MainBottomView = fromVC.valueForKey("bottomView") as MainBottomView
        
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
//            fromVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            bottomView.transform = CGAffineTransformMakeScale(5.0, 5.0)
            toVC.view.alpha = 1
        }, completion:{ isComplete in
//            fromVC.view.transform = CGAffineTransformIdentity
            bottomView.transform = CGAffineTransformIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
