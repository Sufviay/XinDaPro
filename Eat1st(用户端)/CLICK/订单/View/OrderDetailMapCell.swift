//
//  OrderDetailMapCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/11.
//

import UIKit
import GoogleMaps

class OrderDetailMapCell: BaseTableViewCell {

    var clickBlock: VoidBlock?
    
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15)
        let map = GMSMapView.map(withFrame: .zero, camera: camera)
        map.isUserInteractionEnabled = false
        return map
    }()
    
    
    private var refreshBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("map_Refresh"), for: .normal)
        return but
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        contentView.addSubview(refreshBut)
        refreshBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        refreshBut.addTarget(self, action: #selector(clickRefreshAction), for: .touchUpInside)
    }
    
    
    
    @objc func clickRefreshAction() {
        self.clickBlock?("")
    }
    
    
    func setCellData(model: OrderDetailModel) {
        self.mapView.clear()

        let camera = GMSCameraPosition.camera(withLatitude: Double(model.recipientLat) ?? 0, longitude: Double(model.recipientLng) ?? 0, zoom: 15)
        
        mapView.camera = camera
                
        
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: Double(model.recipientLat) ?? 0, longitude: Double(model.recipientLng) ?? 0)
        marker2.title = "user"
        marker2.snippet = "user"
        marker2.icon = LOIMG("local_shr")
        marker2.map = mapView
        
        if model.deliveryLat != "" {
            let marker3 = GMSMarker()
            marker3.position = CLLocationCoordinate2D(latitude: Double(model.deliveryLat) ?? 0, longitude: Double(model.deliveryLng) ?? 0)
            marker3.title = "psRen"
            marker3.snippet = "psRen"
            marker3.icon = LOIMG("local_qishou")
            marker3.map = mapView
            
            let northEast = CLLocationCoordinate2D(latitude: Double(model.recipientLat) ?? 0, longitude: Double(model.recipientLng) ?? 0)
            let southWest = CLLocationCoordinate2D(latitude: Double(model.deliveryLat) ?? 0, longitude: Double(model.deliveryLng) ?? 0)
            
            let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            

            let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
            
            mapView.moveCamera(update)
        }
                
    }

}
