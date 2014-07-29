//
//  KOLocationManager.swift
//  DailyMood
//
//  Created by kino on 14-7-14.
//  Copyright (c) 2014 kino. All rights reserved.
//

import Foundation

import CoreLocation

class KOLocationManager: NSObject , CLLocationManagerDelegate{
    /** Returns YES if location services are enabled in the system settings, and the app has NOT been denied/restricted access. Returns NO otherwise. */
    var locationServicesAvailable:Bool{
        if (CLLocationManager.locationServicesEnabled() == false) {
            return false;
        } else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied) {
            return false;
        } else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted) {
            return false;
        }
        return true;
    }
    
    enum LocationState:Int{
        case NoSucceed = 0, Loding, Succeed
    }
    
    var currentState:LocationState = LocationState.NoSucceed

    typealias LocationRequestBlock = (currentLocation:DailyLocation?, status:LocationState, error:NSError?)->Void
    
    var finishLocationBlock:LocationRequestBlock? = nil
    
    class var sharedInstance : KOLocationManager{
        struct Static{
            static let instance : KOLocationManager = KOLocationManager()
        }
        return Static.instance
    }
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestLocation(timeout:NSTimeInterval, block:LocationRequestBlock?){
        if currentState == LocationState.Loding {return}
        
        if(locationServicesAvailable == true){
            locationManager.startUpdatingLocation()
            finishLocationBlock = block
            //set timeout
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
//                [weak self]
                if (self.currentState == LocationState.Loding) {
                    self.currentState = LocationState.NoSucceed
                    
                    self.locationManager.stopUpdatingLocation()
                    let err:NSError? = NSError.errorWithDomain("", code: -2002, userInfo: nil)
                    block!(currentLocation: nil,status:self.currentState,error:err)
                    
                }
            })
            
            //next step
            currentState = LocationState.Loding
            //address service
            
            
            
        }else{
            currentState = LocationState.NoSucceed;
            //handle error ?
            let err:NSError? = NSError.errorWithDomain("", code: -2001, userInfo: nil)
            block!(currentLocation: nil,status:self.currentState,error:err)
        }
    }
    
    
    var _geocoder:CLGeocoder? = nil
    var geocoder:CLGeocoder{
        if(_geocoder == nil){
            _geocoder = CLGeocoder()
        }
        return _geocoder!
    }
    
    
    ///CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        let userLoc:CLLocationCoordinate2D = (locations[0] as CLLocation).coordinate
        locationManager.stopUpdatingLocation()
        
        if(finishLocationBlock){
//            let request:AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
//            let requestLoc:AMapGeoPoint = AMapGeoPoint.locationWithLatitude(CGFloat(userLoc.latitude), longitude:CGFloat(userLoc.longitude))
//            request.location = requestLoc
//            request.searchType = AMapSearchType_ReGeocode
//            request.radius = 1000
//            request.requireExtension = true
//            _searchApi = AMapSearchAPI(searchKey: GaoDeMapKey, delegate: self)
//            _searchApi!.AMapReGoecodeSearch(request)
            let location:CLLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
            
            self.geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, err) in
                var locatedAt:String = ""
                let placemark:CLPlacemark? = placemarks?[0] as? CLPlacemark
                
                if  placemark{
                    self.currentState = LocationState.Succeed;
                    println("\(placemark!.name)")
                   
                    locatedAt = (placemark!.addressDictionary["FormattedAddressLines"] as NSArray).componentsJoinedByString(", ")
                    
                }
                
                let dailyLoc = DailyLocation.MR_createEntity()
                dailyLoc.lat = NSNumber(double: userLoc.latitude)
                dailyLoc.lon = NSNumber(double: userLoc.longitude)
                dailyLoc.detailAddress = locatedAt
                
                self.finishLocationBlock!(currentLocation: dailyLoc,status:self.currentState,error:nil)
            })
        }
        
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        self.currentState = LocationState.NoSucceed
        finishLocationBlock!(currentLocation: nil,status:self.currentState,error:error)
    }
    
    ///ReGoecode
//    func search(searchRequest:AnyObject, errInfo:NSString){
//        
//    }
//    
//    func onReGeocodeSearchDone(request:AMapReGeocodeSearchRequest, response:AMapReGeocodeSearchResponse){
//        
//    }
}



