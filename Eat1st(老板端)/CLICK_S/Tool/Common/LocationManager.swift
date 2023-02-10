//
//  LocationManager.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/23.
//

import UIKit
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    private var successBlock: ((PlaceModel) -> Void)?
    
    private var failBlock: (()-> Void)?

    static let shared = LocationManager.init()
    
    private lazy var l_manager = CLLocationManager()
    
    private var isFirstLocation: Bool = true
   
    
    //定位
    func doLocation(success: @escaping (PlaceModel) -> Void, fail: @escaping () -> Void) {
        isFirstLocation = true
        
        self.successBlock = success
        self.failBlock = fail
        
        self.l_manager.delegate = self
        l_manager.desiredAccuracy = kCLLocationAccuracyBest
        l_manager.requestAlwaysAuthorization()
        l_manager.allowsBackgroundLocationUpdates = true
        self.l_manager.startUpdatingLocation()
        
        
        
    }

    
    //Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if locations.count != 0 {
            manager.stopUpdatingLocation()
            let newLocation = locations.last
            if self.isFirstLocation {
                let model = PlaceModel()
                model.lat = String((newLocation!.coordinate.latitude))
                model.lng = String((newLocation!.coordinate.longitude))
                self.successBlock?(model)
            }
            self.isFirstLocation = false
        } else {
            print("未发现定位信息")
            self.failBlock?()
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错")
        self.failBlock?()
    }

}
