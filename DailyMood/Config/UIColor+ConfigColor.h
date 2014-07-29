//
//  UIColor+ConfigColor.h
//  Allinns
//
//  Created by Tarzan on 14-1-13.
//  Copyright (c) 2014年 BestApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ConfigColor)

//+(UIColor *)seperatorColor;
+ (UIColor *)navBarTitleColor;

+ (UIColor *)titleTextColor;
+ (UIColor *)subtitleTextColor;

+ (UIColor *)textColor;

+ (UIColor *)backgroundColor;
+ (UIColor *)backgroundLightColor;

//four clocl
+ (UIColor *)blueTextColor;
+ (UIColor *)yellowTextColor;
+ (UIColor *)redTextColor;
+ (UIColor *)purpleTextColor;

/* 导航 */
+ (UIColor *)barBackColor;
+ (UIColor *)barTintColor;
+ (UIColor *)barBackTintColor;

//cell分割线
+ (UIColor *)cellSpColoc;


//菜单
//+ (UIColor *)menuTextColor;
//+ (UIColor *)menuTextSelectedColor;


/* 公用 */
+ (UIColor *)tabButtonSelectColor;          //选项卡选中颜色
+ (UIColor *)tabUnderLineColor;             //选项卡下划线颜色
+ (UIColor *)tabButtonUnSelectColor;         //选项卡未选中颜色
+ (UIColor *)tabMidLineColor;

+ (UIColor *)orangeSuperColor;

@end

@interface UIFont (ConfigFont)



@end

@interface UIView (ConfigView)

- (void)applyBorderRect;

- (void)applyBorderRectWithBottomStyle;

- (void)applyScoreBorderRect;

- (void)applyShadowTop;

@end

@interface UITextField (ConfigText)

- (void)applyTextBorderRect;

- (void)applyTextBorderRectTop;

- (void)applyTextBorderRectBottom;

@end

@interface UITableViewCell (ConfigCell)

- (void)applyBottomLine;

@end