////
////  UIColor+ConfigColor.m
////  Allinns
////
////  Created by Tarzan on 14-1-13.
////  Copyright (c) 2014年 BestApp. All rights reserved.
////


//
//#import "UIColor+ConfigColor.h"
//
//@implementation UIColor (ConfigColor)
//
//+ (UIColor *)navBarTitleColor{
//    return UIColorFromRGB(0x595757);
//}
//
//+ (UIColor *)titleTextColor
//{
//    return UIColorFromRGB(0x836f57);
//}
//
//+ (UIColor *)subtitleTextColor{
//    return UIColorFromRGB(0x959595);
//}
//
//+ (UIColor *)textColor{
//   return UIColorFromRGB(0x535353);
//}
//
//+ (UIColor *)backgroundColor{
//    return UIColorFromRGB(0xe9e9e9);
//}
//
//+ (UIColor *)backgroundLightColor{
//    return UIColorFromRGB(0xf8f6f3);
//}
//
//+ (UIColor *)barBackColor{
//    return UIColorFromRGB(0x1e2c64);
//}
//
//+ (UIColor *)barTintColor{
//    return UIColorFromRGB(0xbe9f2d);
//}
//
//+ (UIColor *)barBackTintColor{
//    return UIColorFromRGB(0xbe9f2d);
//}
//
////cell分割线
//+ (UIColor *)cellSpColoc{
//    return [UIColor colorWithWhite:0.9 alpha:1.000];
//}
//
//
////选项卡
//
//+ (UIColor *)tabButtonSelectColor;          //选项卡选中颜色
//{
//    return UIColorFromRGB(0xe66531);
//}
//
//+ (UIColor *)tabUnderLineColor;             //选项卡下划线颜色
//{
//    return [UIColor lightGrayColor];
//}
//
//+ (UIColor *)tabButtonUnSelectColor;         //选项卡未选中颜色
//{
//    return UIColorFromRGB(0xa3a3a3);
//}
//
//+ (UIColor *)tabMidLineColor{
//    return [UIColor colorWithWhite:0.825 alpha:1.000];
//}
//
//+ (UIColor *)orangeSuperColor{
//    return UIColorFromRGB(0xe66531);
//}
//
//#pragma 4 color
//
//+ (UIColor *)blueTextColor{
//    return UIColorFromRGB(0x1e2c64);
//}
//+ (UIColor *)yellowTextColor{
//    return UIColorFromRGB(0xf39800);
//}
//+ (UIColor *)redTextColor{
//    return UIColorFromRGB(0x9d0046);
//}
//+ (UIColor *)purpleTextColor{
//    return UIColorFromRGB(0x60009d);
//}
//
//@end
//
//#pragma mark -
//
//#import <QuartzCore/QuartzCore.h>
//
//@implementation UIView (ConfigView)
//
//#define TImageV 1024
//
////adacaa
//- (void)applyBorderRect{
//    self.layer.masksToBounds = NO;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
//    self.layer.cornerRadius = 2;
//    
//}
//
//- (void)applyBorderRectWithBottomStyle{
//    self.layer.masksToBounds = NO;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
//    self.layer.cornerRadius = 2;
//    
////    UIImageView *imageV = (UIImageView *)[self viewWithTag:TImageV];
////    if (!imageV) {
////        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 3, self.width, 2)];
////        imageV.tag = TImageV;
////        imageV.backgroundColor = UIColorFromRGB(0xd9d9d9);
////        [self insertSubview:imageV atIndex:10];
////    }
//    
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, self.height-3, self.width, 2.0f);
//    bottomBorder.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
//    [self.layer addSublayer:bottomBorder];
//}
//
//- (void)applyScoreBorderRect{
//    self.layer.masksToBounds = NO;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.cornerRadius = 3;
//}
//
//- (void)applyShadowTop{
//    //加阴影
//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//    self.layer.shadowOffset = CGSizeMake(0,-2);//默认(0, -3),这个跟shadowRadius配合使用
//    self.layer.shadowOpacity = 0.3;//阴影透明度，默认0
//    self.layer.shadowRadius = 5;//阴影半径，默认3
//}
//
//@end
//
//@implementation UITextField (ConfigText)
//
//
//- (void)applyTextBorderRect{
//    self.borderStyle = UITextBorderStyleNone;
//    self.layer.masksToBounds = YES;
//    self.layer.borderColor = UIColorFromRGB(0xadacaa).CGColor;
//    self.layer.cornerRadius = 2;
//    self.layer.borderWidth = 1.f;
//    
//    [self changePaddingView];
//}
//
//
//- (void)applyTextBorderRectTop{
//    self.borderStyle = UITextBorderStyleNone;
//    self.layer.borderWidth = 1.f;
//    self.layer.borderColor = UIColorFromRGB(0xadacaa).CGColor;
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
//                                                         cornerRadii:CGSizeMake(2, 2)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//    
//    [self changePaddingView];
//}
//
//- (void)applyTextBorderRectBottom{
//    self.borderStyle = UITextBorderStyleNone;
//    self.layer.borderWidth = 1.f;
//    self.layer.borderColor = UIColorFromRGB(0xadacaa).CGColor;
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
//                                                         cornerRadii:CGSizeMake(2, 2)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//    
//    [self changePaddingView];
//}
//
//- (void)changePaddingView{
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    self.leftView = paddingView;
//    self.leftViewMode = UITextFieldViewModeAlways;
//}
//
//@end
//
//
//@implementation UITableViewCell (ConfigCell)
//
//- (void)applyBottomLine{
//    
//    // Add a bottomBorder.
//    CALayer *bottomBorder = [CALayer layer];
//    DLog(@"%f",self.height);
//    bottomBorder.frame = CGRectMake(0.0f, self.height-1, self.width, 1.0f);
//    
//    bottomBorder.backgroundColor = [UIColor cellSpColoc].CGColor;
//    
//    [self.layer addSublayer:bottomBorder];
//}
//
//@end