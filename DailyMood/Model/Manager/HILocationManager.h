//
//  HILocationManager.h
//  HomeInn
//
//  Created by kino on 14-4-15.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "City.h"

#import <CoreLocation/CoreLocation.h>
//@class CLLocationCoordinate2D;

typedef enum{
    LocationStateNoSucceed = 0,
    LocationStateLoding,
    LocationStateSucceed
}LocationState;


typedef void(^LocateCoorSucceedBlock)(CLLocationCoordinate2D);

typedef void(^LocateSucceedBlock)();
typedef void(^LocateFailBlock)(NSError *);

@interface HILocationManager : NSObject

@property (nonatomic) LocationState currentState;

+ (HILocationManager *)shareLocation;

/**
 *  定位拿城市
 */
- (void)beginLocationWithBlock:(LocateSucceedBlock)succeedblock
                      withFail:(LocateFailBlock)failBlock;

/**
 *  定位拿坐标
 */
- (void)beginLocationByCoor:(LocateCoorSucceedBlock)succeedblock
                   withFail:(LocateFailBlock)failBlock;


- (void)clearUpBlock;

@end
