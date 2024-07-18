//
//  SearchPlaceManager.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/6.
//

import UIKit
import GooglePlaces


class PlaceModel: NSObject {
    var postCode: String = ""
    var lat: String = ""
    var lng: String = ""
    var address: String = ""
    var placeName: String = ""
    var placeID: String = ""
}


class SearchPlaceManager: NSObject, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate, SystemAlertProtocol {

    
    private var searchSuccessBlock: ((PlaceModel) -> Void)?
    
    private var locationSuccessBlock: (([PlaceModel]) -> Void)?
    
    private var loactionErrorBlock: ((PlaceModel) -> Void)?
    
    private var notAllowBlock: (() -> Void)?
    
    static let shared = SearchPlaceManager.init()
    
    
    private var placesClient = GMSPlacesClient.shared()
    
    lazy var locationManager = CLLocationManager()
    
    private var isDone: Bool = false

    
    ///开始搜索
    func doSearchPlace(success: @escaping (PlaceModel) -> Void) {
        
        self.searchSuccessBlock = success
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        //autocompleteController.navigationController?.navigationBar.barTintColor = MAINCOLOR

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        filter.country = "GB"

        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        
        PJCUtil.currentVC()?.present(autocompleteController, animated: true, completion: nil)
                
    }
    
    
    
    ///开始定位
    func doLocationCurrentPlace(success: @escaping ([PlaceModel]) -> Void, notAllow: @escaping () -> Void,  error: @escaping (PlaceModel) -> Void) {
        self.locationSuccessBlock = success
        self.notAllowBlock = notAllow
        loactionErrorBlock = error
        
        
        isDone = false
        
        ///获取当前定位
        // 判断设备是否开启定位服务
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
    
        if status.rawValue == 0 {
            locationManager.requestAlwaysAuthorization()
            return
        }
        if status.rawValue == 2 {
            notAllowBlock?()
//            showSystemAlert("The location service is not enabled", "Go to [Settings]>>[Privacy]>>[Location Services]>> Turn on the switch and allow Eat1st to use location services", "OK")
            return
        }

        getLocalAction()
        
    }
    
    
    ///定位服务
    private func getLocalAction() {
        
        let placeFields: GMSPlaceField = [.all]
        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        
        
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [unowned self] (placeLikehoods, error) in
            
            if !isDone {
                
                isDone = true
                
                if error != nil {
                    HUD_MB.dissmiss(onView: PJCUtil.getWindowView())

                    print("错误：\(error?.localizedDescription ?? "")")
                    //出现错误就给一个默认的定位信息
                    
                    let model = PlaceModel()
                    model.postCode = "MK5 8HL"
                    model.lat = "52.0217645"
                    model.lng = "-0.7716848"
                    model.address = "Roebuck Way, Knowlhill, Milton Keynes MK5 8HL, UK"
                    loactionErrorBlock?(model)
                    return
                }
                
                guard let place = placeLikehoods?.first?.place else {
                    HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                    return
                }
                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())

                var tArr: [PlaceModel] = []
                
                for item in placeLikehoods! {
                    let model = PlaceModel()
                    model.address = item.place.formattedAddress ?? ""
                    model.placeID = item.place.placeID ?? ""
                    model.placeName = item.place.name ?? ""
                    model.lat = String(place.coordinate.latitude)
                    model.lng = String(place.coordinate.longitude)
                    tArr.append(model)
                }
                
                self.locationSuccessBlock?(tArr)
            }
        }
    }

    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        UserDefaults.standard.local_lat = String(place.coordinate.latitude)
//        UserDefaults.standard.local_lng = String(place.coordinate.longitude)
//        UserDefaults.standard.postCode = place.name
//        UserDefaults.standard.address = place.formattedAddress
        
        let model = PlaceModel()
        model.address = place.formattedAddress ?? ""
        model.lat = String(place.coordinate.latitude)
        model.lng = String(place.coordinate.longitude)
        model.postCode = place.name ?? ""
        
        PJCUtil.currentVC()?.dismiss(animated: true, completion: nil)
        self.searchSuccessBlock?(model)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        PJCUtil.currentVC()?.dismiss(animated: true, completion: nil)
    }
    
    
    ///监听定位权限的变化
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("------\(status.rawValue)")
        ///0 未选择。 2 拒绝
        if status.rawValue != 0 && status.rawValue != 2  {
            
            //print("aaaaa")
            self.getLocalAction()
        }
        
        if status.rawValue == 2 {
            notAllowBlock?()
            
           // showSystemAlert("The location service is not enabled", "We need location information to serve you better\nGo to [Settings]>>[Privacy]>>[Location Services]>> Turn on the switch and allow Eat1st to use location services", "OK")
        }
    }
}
