//
//  UITextView+scrollInScrollView.m
//  Financial
//
//  Created by kino on 14-2-18.
//  Copyright (c) 2014年 kino. All rights reserved.
//

#import "UITextView+scrollInScrollView.h"

@implementation UITextView (scrollInScrollView)

- (void)configTextViewInScrollView:(UIScrollView *)scrollView {
    
    self.autoresizingMask = UIViewAutoresizingNone;
    CGSize size = [self sizeThatFits:CGSizeMake(self.width, FLT_MAX)];
    
    //NSLog(@"%f",size.height);
    self.height = size.height;
    
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,self.top + self.height);
    self.editable = NO;
    self.scrollEnabled = NO;
    
    //enable zoomIn
    scrollView.minimumZoomScale=1;
    scrollView.maximumZoomScale=7;
}

@end
