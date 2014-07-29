//
//  HIActionSheetView.h
//  HomeInn
//
//  Created by kino on 14-4-18.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ActionSheetPhone = 0,
    ActionSheetShare,
    ActionSheetPaySucceed,
    ActionSheetNomalHUB
}ActionSheetType;

typedef void(^indexClickBlock)(NSUInteger);
typedef void(^cancelBlock)(void);

@interface HIActionSheetView : UIView

@property (copy, nonatomic) indexClickBlock okBlock;
@property (copy, nonatomic) cancelBlock cancelBlock;

@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL isShowCancelButton;


- (void)showSheetWithType:(ActionSheetType)type
               dataSource:(NSArray *)array
               clickIndex:(indexClickBlock)finishBlock
                   cancel:(cancelBlock)cancelBlcok;

- (void)showSheetWithType:(ActionSheetType)type;


@end
