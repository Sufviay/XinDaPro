//
//  CoreLocationManager.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/3.
//

import UIKit
import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate, SystemAlertProtocol {
    
    private var locationSuccessBlock: (([PlaceModel]) -> Void)?
    
    static let shared = CoreLocationManager.init()
    
    lazy var manager = CLLocationManager()
    
    
    var isDone: Bool = false
    
    
    func doLocationCurrentPlace(success: @escaping ([PlaceModel]) -> Void) {
        
        locationSuccessBlock = success
        
        isDone = false
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        ///获取当前定位
        // 判断设备是否开启定位服务
        manager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
    
        if status.rawValue == 0 {
            manager.requestAlwaysAuthorization()
            return
        }
        if status.rawValue == 2 {
            showSystemAlert("The location service is not enabled", "Go to [Settings]>>[Privacy]>>[Location Services]>> Turn on the switch and allow Eat1st to use location services", "OK")
            return
        }

        
        
    }
    
    
    
    ///定位服务
    private func getLocalAction() {
        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        manager.startUpdatingLocation()
        
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                print("aaaaaa")
                getLocalAction()
            }
        }
     
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
            if !isDone {
                
                var tArr: [PlaceModel] = []
                
                for item in locations {
                    let model = PlaceModel()
                    tArr.append(model)
                }
                
            }
            
            isDone = true
        }
    
    
     
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
            print("Error: \(error)")
        }
    
}
