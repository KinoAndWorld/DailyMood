//
//  UIView+ScreenShot.m
//  HomeInn
//
//  Created by kino on 14-4-15.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage *)screenShotFromSelf{
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
}

@end

@implementation UIWindow (ScreenShot)

- (UIImage *)screenShotFullScreen{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
}

@end