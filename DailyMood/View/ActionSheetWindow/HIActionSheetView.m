//
//  HIActionSheetView.m
//  HomeInn
//
//  Created by kino on 14-4-18.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import "HIActionSheetView.h"
#import "UIView+ScreenShot.h"
#import "UIImage+Alpha.h"
#import "KOMacro.h"
#import "UIView+Utils.h"


@interface HIActionSheetView()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) UIImageView *backImageV;
@property (strong, nonatomic) NSArray *dataArray;

@end


@implementation HIActionSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showSheetWithType:(ActionSheetType)type{
    [self showSheetWithType:type dataSource:nil clickIndex:nil cancel:nil];
}

- (void)showSheetWithType:(ActionSheetType)type
               dataSource:(NSArray *)array
               clickIndex:(indexClickBlock)finishBlock
                   cancel:(cancelBlock)cancelBlcok{
    self.dataArray = array;
    if (type != ActionSheetNomalHUB) {
        //截图
        UIImage *shotImage = [KeyWindow screenShotFullScreen];
        _imageV = [[UIImageView alloc] initWithImage:
                   [shotImage blurredImageWithRadius:10 iterations:10 tintColor:[UIColor blackColor]]];
//        KeyWindow.windowLevel = UIWindowLevelStatusBar + 1;
    }else{
        _imageV = [[UIImageView alloc] init];
    }
    
    _imageV.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
    _imageV.alpha = 0.0;
    _imageV.userInteractionEnabled = YES;
    
    _backImageV = [[UIImageView alloc] initWithFrame:_imageV.frame];
    _backImageV.backgroundColor = [UIColor blackColor];
    _backImageV.alpha = 0.0;
    
    
    
    [KeyWindow addSubview:_imageV];
    [KeyWindow addSubview:_backImageV];
    //
    self.frame = CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height);
    self.contentView = [self createContentViewByType:type];
    if (_isShowCancelButton) {
        [self createCloseButton];
    }
    
    [UIView animateWithDuration:0.25 animations:^(void){
        _imageV.alpha = 1.0;
        _backImageV.alpha = 0.7;
    } completion:^(BOOL finish){
        //动画
        [self addSubview:_contentView];
        [KeyWindow addSubview:self];
    }];
    
    self.okBlock = finishBlock;
    self.cancelBlock = cancelBlcok;
}

- (UIView *)createContentViewByType:(ActionSheetType)type{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    
    float width = 280, height = 50;
    switch (type) {
        case ActionSheetPhone:
            for (int i = 0; i<_dataArray.count;i++) {
                NSDictionary *dic = _dataArray[i];
                float offsetY =  Main_Screen_Height/2 - (_dataArray.count - i - 1)*height;
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(20,offsetY, width, height)];
                
                //bottom Line
                
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.userInteractionEnabled = YES;
                //btn.backgroundColor = [UIColor orangeColor];
                btn.tag = i;
                btn.frame = CGRectMake(0, 0, itemView.width, itemView.height);
                btn.adjustsImageWhenHighlighted = YES;
                //btn.showsTouchWhenHighlighted = YES;
                [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]
                               forState:UIControlStateNormal];
                [btn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]]
                               forState:UIControlStateHighlighted];
                
                [btn addTarget:self action:@selector(buttonClickOnIdx:) forControlEvents:UIControlEventTouchUpInside];
                [itemView addSubview:btn];
                
                //
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
                title.text = dic[@"title"];
                [itemView addSubview:title];
                
                UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 160, 30)];
                content.text = dic[@"content"];
                content.textColor = [UIColor yellowColor];
                [itemView addSubview:content];
                
                
                if (i != _dataArray.count-1) {
                    CALayer *bottomBorder = [CALayer layer];
                    bottomBorder.frame = CGRectMake(0.0f, itemView.height-1, itemView.width, 1.0f);
                    bottomBorder.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
                    [itemView.layer addSublayer:bottomBorder];
                }
                
                [itemView roundSelfWithCornerRadius:2];
                //add to
                itemView.backgroundColor = [UIColor whiteColor];
                [v addSubview:itemView];
                
                
                
            }
            
            break;
        case ActionSheetShare:
            
            break;
        case ActionSheetPaySucceed:
            
            
            [v addSubview:[self createLetterView:v]];
            
            [self autoDismiss];
            break;
        case ActionSheetNomalHUB:
            
            [v addSubview:[self createMessageView:v]];
            
            [self autoDismiss];
            break;
        default:
            break;
    }
    return v;
}

- (UIView *)createLetterView:(UIView *)v{
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payLetter"]];
    //482 436
    imgV.frame = CGRectMake(0, 0, 241, 218);
    imgV.center = v.center;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 241, 30)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"支付成功";
    lbl.backgroundColor = [UIColor clearColor];
    [imgV addSubview:lbl];
    
    UIImageView *flagImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order-p"]];
    flagImageV.frame = CGRectMake(imgV.width/2 - 30, 95, 60, 60);
    [imgV addSubview:flagImageV];
    
    return imgV;
}

- (UIView *)createMessageView:(UIView *)v{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 80)];
    backView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.820];
    backView.center = v.center;
    [backView roundSelfWithCornerRadius:5];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 60)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = _message;
    lbl.textColor = [UIColor darkGrayColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:15.f];
    lbl.numberOfLines = 3;
    
    //lbl.center = backView.center;
    
    [backView addSubview:lbl];
    
    return backView;
}

//

- (void)buttonClickOnIdx:(UIButton *)sender{
    NSUInteger tag = sender.tag;
    if (self.okBlock) {
        _okBlock(tag);
    }
    [self closeSheet];
}

- (void)createCloseButton{
    //close icon
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.userInteractionEnabled = YES;
    closeButton.frame = CGRectMake(Main_Screen_Width/2 - 15, Main_Screen_Height - 80, 30, 30);
    //closeButton.backgroundColor = [UIColor whiteColor];
    [closeButton setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSheet)
          forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeButton];
}

- (void)closeSheet{
    [UIView animateWithDuration:0.25 animations:^(void){
        _imageV.alpha = 0.0;
        _backImageV.alpha = 0.0;
    } completion:^(BOOL finish){
        //动画
        [_contentView removeFromSuperview];
        [_imageV removeFromSuperview];
        [_backImageV removeFromSuperview];
        [self removeFromSuperview];
//        KeyWindow.windowLevel = UIWindowLevelNormal;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        if (self.cancelBlock) {
            _cancelBlock();
        }
    }];
}

- (void)autoDismiss{
    [self autoDismiss:1.5];
}

- (void)autoDismiss:(NSTimeInterval)interval{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //auto dismiss
        [self closeSheet];
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/* help */

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
