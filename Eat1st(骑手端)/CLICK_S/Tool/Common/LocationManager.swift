//
//  LocationManager.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/23.
//

import UIKit
import CoreLocation
import RxSwift


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let bag = DisposeBag()
    
    private var successBlock: ((PlaceModel) -> Void)?
    
    private var failBlock: (()-> Void)?
    
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()

    //static let shared = LocationManager.init()
     var l_manager: CLLocationManager?
    
    private var isFirstLocation: Bool = true
    
    
    public func initialize() {
        if (self.l_manager == nil) {
            self.l_manager = CLLocationManager()
            self.l_manager?.delegate = self
            l_manager?.requestAlwaysAuthorization()
            //self.l_manager?.desiredAccuracy = kCLLocationAccuracyBest
            //self.l_manager?.distanceFilter = 15
            self.l_manager?.allowsBackgroundLocationUpdates = true
            l_manager?.showsBackgroundLocationIndicator = true
            self.l_manager?.pausesLocationUpdatesAutomatically = false
        }
        
    }
    
    
    //定位
    func doLocation() {
        isFirstLocation = true
        
        if (self.l_manager != nil) && (CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined) {
            //么有获取权限
            //self.l_manager?.requestWhenInUseAuthorization()
        } else {
            //self.l_manager?.stopUpdatingLocation()
            self.l_manager?.startUpdatingLocation()
        }        
    }
    
       
    //定位
//    func doLocation(success: @escaping (PlaceModel) -> Void, fail: @escaping () -> Void) {
//        isFirstLocation = true
//        
//        self.successBlock = success
//        self.failBlock = fail
//        
//        if (self.l_manager != nil) && (CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined) {
//            //么有获取权限
//            self.l_manager?.requestWhenInUseAuthorization()
//        } else {
//            
//            self.l_manager?.startUpdatingLocation()
//        }
//        
////        self.l_manager.delegate = self
////        l_manager.desiredAccuracy = kCLLocationAccuracyBest
////        l_manager.requestAlwaysAuthorization()
////        l_manager.requestWhenInUseAuthorization()
////        l_manager.allowsBackgroundLocationUpdates = true
////        l_manager.pausesLocationUpdatesAutomatically = false
//    }

    
    //Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        print("---------aaaaa")
            
        if locations.count != 0 {
            let newLocation = locations.last
            if self.isFirstLocation {
                let model = PlaceModel()
                model.lat = String((newLocation!.coordinate.latitude))
                model.lng = String((newLocation!.coordinate.longitude))
                //self.successBlock?(model)
                
                if UserDefaults.standard.isLogin {
                    print("开始上传位置")
                    HTTPTOOl.uploadUserLocation(lat: model.lat, lng: model.lng).subscribe(onNext: { (json) in
                        print("上传成功！")
                    }, onError: { (error) in
                        print(ErrorTool.errorMessage(error))
                    }).disposed(by: self.bag)
                }
            }
            self.isFirstLocation = false
        } else {
            print("未发现定位信息")
            //self.failBlock?()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错")
        self.l_manager?.stopUpdatingLocation()
        //self.failBlock?()
    }

}
