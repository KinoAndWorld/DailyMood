//
//  HILocationManager.m
//  HomeInn
//
//  Created by kino on 14-4-15.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import "HILocationManager.h"
#import "KOMacro.h"

#import <AMapSearchKit/AMapSearchAPI.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HILocationManager()<AMapSearchDelegate,CLLocationManagerDelegate>


//PS CLLocationManager *locationManager;
PS CLLocationManager *locationManager;

//地址编码服务
PS AMapSearchAPI *searchApi;

PS MKUserLocation *mapUserLocation;

PC LocateCoorSucceedBlock coorSucceedBlock;
PC LocateSucceedBlock succeedBlock;
PC LocateFailBlock failBlock;

PA CLLocationCoordinate2D locatedCoordinate;

@end

@implementation HILocationManager

#pragma mark - 定位

+ (HILocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


- (AMapSearchAPI *)searchApi{
    if (!_searchApi) {
        _searchApi = [[AMapSearchAPI alloc] initWithSearchKey:@"623a339136388c549f39ccf212ac02f2" Delegate:self];
    }
    return _searchApi;
}


- (void)beginLocationWithBlock:(LocateSucceedBlock)succeedblock
                      withFail:(LocateFailBlock)failBlock{
    
    self.succeedBlock = succeedblock;
    self.failBlock = failBlock;
    
    [self startLocationService];
    
}

- (void)beginLocationByCoor:(LocateCoorSucceedBlock)succeedblock
                   withFail:(LocateFailBlock)failBlock{
    self.coorSucceedBlock = succeedblock;
    self.failBlock = failBlock;

    [self startLocationService];
}

- (void)startLocationService{
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
        }
        [_locationManager startUpdatingLocation];
        
        //设置超时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //20秒后尚未成功，则
            if (_currentState == LocationStateLoding) {
                _currentState = LocationStateNoSucceed;
                
                [_locationManager stopUpdatingLocation];
                if (self.failBlock) {
                    self.failBlock([NSError errorWithDomain:@"" code:-2002 userInfo:nil]);
                }
            }
        });
        
    }else{
        _currentState = LocationStateNoSucceed;
        //handle error ?
        if (self.failBlock) {
            self.failBlock([NSError errorWithDomain:@"" code:-2001 userInfo:nil]);
        }
    }
    _currentState = LocationStateLoding;
}


- (void)clearUpBlock{
    _succeedBlock = nil;
    _failBlock = nil;
    _coorSucceedBlock = nil;
}



#pragma mark -  LocationServiceDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
    
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    CLLocationCoordinate2D userLoc = [[locations lastObject] coordinate];
    if (userLoc.latitude != 0) {
        NSLog(@"定位成功------纬度%f 经度%f", userLoc.latitude, userLoc.longitude);
    }
    
    //关闭定位服务
    [_locationManager stopUpdatingLocation];
    
    _locatedCoordinate = userLoc;
    
    if (_coorSucceedBlock) {
        _currentState = LocationStateSucceed;
        _coorSucceedBlock(userLoc);
    }
    
    if (_succeedBlock) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        AMapGeoPoint *requestLoc = [AMapGeoPoint locationWithLatitude:userLoc.latitude longitude:userLoc.longitude];
        
        request.location = requestLoc;
        request.searchType = AMapSearchType_ReGeocode;
        
        [self.searchApi AMapReGoecodeSearch:request];
    }
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    _currentState = LocationStateNoSucceed;
    if (self.failBlock) {
        self.failBlock(error);
    }
}



/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
//- (void)didFailToLocateUserWithError:(NSError *)error{
//    _currentState = LocationStateNoSucceed;
//    if (self.failBlock) {
//        self.failBlock(error);
//    }
//}


#pragma mark - Search Address


/*!
 @brief 通知查询成功或失败的回调函数
 @param searchRequest 发起的查询
 @param errInfo 错误信息
 */
- (void)search:(id)searchRequest error:(NSString*)errInfo{
    _currentState = LocationStateNoSucceed;
    
}


/*!
 @brief 逆地理编码 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapReGeocodeSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapReGeocodeSearchResponse类中的定义)
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil){
        [self searchCorrectCityByCity:response.regeocode.addressComponent];
        _currentState = LocationStateSucceed;
        //定位成功
        if (self.succeedBlock) {
            _succeedBlock();
        }
    }else{
        _currentState = LocationStateNoSucceed;
    }
}


/**
 *  通过定位到的城市搜索结果
 *
 *  @param result
 *
 *  @return
 */
- (void)searchCorrectCityByCity:(AMapAddressComponent *)result{
    NSString *cityName = result.city;
    
    //POI检索到的
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    //匹配本地城市文件
    NSData *data = [USER_DEFAULT objectForKey:@"CityDic"];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:
                             [NSKeyedUnarchiver unarchiveObjectWithData:data]];
    NSString *cityCode = [[cityDic objectForKey:cityName] objectForKey:@"city_code"];
    
    //
//    City *city = [City cityWithName:cityName code:cityCode
//                                lat:[NSString stringWithFormat:@"%f",_locatedCoordinate.latitude]
//                                lng:[NSString stringWithFormat:@"%f",_locatedCoordinate.longitude]];
//    city.detail = [NSString stringWithFormat:@"%@, %@, %@",
//                   result.city,
//                   result.district,
//                   result.township];
//    return nil;
}

@end
