//
//  DiverMapController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/3/2.
//

import UIKit
import RxSwift
import GoogleMaps

class DiverMapController: BaseViewController, GMSMapViewDelegate {

    private let bag = DisposeBag()
    
    private var dataArr: [RiderModel] = []
    
    private lazy var alertView: DiverOrderListView = {
        let view = DiverOrderListView()
        return view
    }()
    
    
    private lazy var mapView: GMSMapView = {
        //let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15)
        //let map = GMSMapView.map(withFrame: .zero, camera: camera)
        let map = GMSMapView()
        //map.isUserInteractionEnabled = false
        map.delegate = self
        return map
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        but.clipsToBounds = true
        but.layer.cornerRadius = 35 / 2
        but.backgroundColor = .black.withAlphaComponent(0.4)
        return but
    }()
    
    
    

    override func setViews() {
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        loadDate_Net()
    
    }
    
    
    override func setNavi() {
        self.naviBar.backgroundColor = MAINCOLOR
        self.naviBar.headerTitle = "Drivers"
        self.naviBar.leftImg = LOIMG("nav_back")
    }
    
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - 网络请求
    private func loadDate_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getRiderList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [RiderModel] = []
            for jsonData in json["data"].arrayValue {
                let model = RiderModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
                
                if model.lat != 0 {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: model.lat, longitude: model.lng)
                    marker.title = model.name
                    marker.snippet = model.id
                    marker.icon = LOIMG("rider_img")
                    marker.map = self.mapView
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: model.lat, longitude: model.lng, zoom: 15)
                }
                            
            }
            self.dataArr = tArr
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("aaaa")
        
        print(marker.snippet)
        
        //查看订单详情
        self.alertView.riderID = marker.snippet ?? ""
        self.alertView.appearAction()
        
        return true
    }
        

    
    
}
