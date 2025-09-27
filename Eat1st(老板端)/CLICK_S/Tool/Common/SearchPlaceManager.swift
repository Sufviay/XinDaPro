//
//  SearchPlaceManager.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/6.
//

//import UIKit
//import GooglePlaces
//
//
//class PlaceModel: NSObject {
//    var postCode: String = ""
//    var lat: String = ""
//    var lng: String = ""
//    var address: String = ""
//}
//
//
//class SearchPlaceManager: NSObject, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate {
//
//
//
//    private var searchSuccessBlock: ((PlaceModel) -> Void)?
//    
//    private var locationSuccessBlock: ((PlaceModel) -> Void)?
//    
//    static let shared = SearchPlaceManager.init()
//    
//    
//    private var placesClient = GMSPlacesClient.shared()
//    
//    lazy var locationManager = CLLocationManager()
//
//    
//    ///开始搜索
//    func doSearchPlace(success: @escaping (PlaceModel) -> Void) {
//        
//        self.searchSuccessBlock = success
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        autocompleteController.navigationController?.navigationBar.tintColor = MAINCOLOR
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .region
//        filter.country = "GB"
//
//        autocompleteController.autocompleteFilter = filter
//
//        // Display the autocomplete view controller.
//        
//        PJCUtil.currentVC()?.present(autocompleteController, animated: true, completion: nil)
//                
//    }
//    
//    
//    
//    ///开始定位
//    func doLocationCurrentPlace(success: @escaping (PlaceModel) -> Void) {
//        self.locationSuccessBlock = success
//        
//        ///获取当前定位
//        // 判断设备是否开启定位服务
//        locationManager.delegate = self
//        
//        let status = CLLocationManager.authorizationStatus()
//    
//        if status.rawValue == 0 {
//            locationManager.requestAlwaysAuthorization()
//            return
//        }
//        if status.rawValue == 2 {
//            HUD_MB.showWarnig("The location service is not enabled!\nGo to Settings to enable services", onView: PJCUtil.getWindowView())
//            return
//        }
//
//        getLocalAction()
//        
//    }
//    
//    
//    ///定位服务
//    private func getLocalAction() {
//        
//        let placeFields: GMSPlaceField = [.all]
//        //HUD_MB.loading("", onView: PJCUtil.getWindowView())
//        
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [unowned self] (placeLikehoods, error) in
//            
//            if error != nil {
//                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
//                print("错误：\(error?.localizedDescription ?? "")")
//                return
//            }
//            
//            guard let place = placeLikehoods?.first?.place else {
//                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
//                return
//            }
//            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
//            print(place.name!)
//            print(place.formattedAddress!)
//        
//            let model = PlaceModel()
//            model.address = place.formattedAddress ?? ""
//            model.lat = String(place.coordinate.latitude)
//            model.lng = String(place.coordinate.longitude)
//            model.postCode = place.name ?? ""
//
//
//            
////            UserDefaults.standard.local_lat = String(place.coordinate.latitude)
////            UserDefaults.standard.local_lng = String(place.coordinate.longitude)
////            UserDefaults.standard.address = place.formattedAddress!
//
//            self.locationSuccessBlock?(model)
//        }
//    }
//
//    
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
////        UserDefaults.standard.local_lat = String(place.coordinate.latitude)
////        UserDefaults.standard.local_lng = String(place.coordinate.longitude)
////        UserDefaults.standard.postCode = place.name
////        UserDefaults.standard.address = place.formattedAddress
//        
//        let model = PlaceModel()
//        model.address = place.formattedAddress ?? ""
//        model.lat = String(place.coordinate.latitude)
//        model.lng = String(place.coordinate.longitude)
//        model.postCode = place.name ?? ""
//        
//        PJCUtil.currentVC()?.dismiss(animated: true, completion: nil)
//        self.searchSuccessBlock?(model)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print("Error: ", error.localizedDescription)
//    }
//    
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        PJCUtil.currentVC()?.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    ///监听定位权限的变化
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("------\(status.rawValue)")
//        ///0 未选择。 2 拒绝
//        if status.rawValue != 0 && status.rawValue != 2  {
//            self.getLocalAction()
//        }
//    }
//}
