//
//  UIView+ScreenShot.h
//  HomeInn
//
//  Created by kino on 14-4-15.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScreenShot)

- (UIImage *)screenShotFromSelf;

@end

@interface UIWindow (ScreenShot)

- (UIImage *)screenShotFullScreen;

@end
