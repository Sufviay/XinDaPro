//
//  StoreIntroduceHeaderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit
import GoogleMaps


class StoreIntroduceHeaderCell: BaseTableViewCell {
    
    
    private lazy var mapView: GMSMapView = {
            
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15)
        let map = GMSMapView.map(withFrame: .zero, camera: camera)
        map.isIndoorEnabled = false
        map.isUserInteractionEnabled = false
        return map
    }()
    
//
//    private let headImg: UIImageView = {
//        let img = UIImageView()
//        img.backgroundColor = HOLDCOLOR
//        img.image = LOIMG("store1")
//        return img
//    }()
//    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "McDonald's® London"
        return lab
    }()
    
    
    private let taglab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "Fried chicken burger"
        return lab
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Store introduction, we are a good noodle shop, welcome to order foodStore introduction, we are a good noodle shop"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    
    override func setViews() {
        contentView.backgroundColor = .white
        
        
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(300)
        }

        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(300)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(taglab)
        taglab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(nameLab.snp.bottom)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(taglab.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
    }
    
    
    func setCellData(model: StoreInfoModel)  {
        
        self.mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: Double(model.lat) ?? 0, longitude: Double(model.lng) ?? 0, zoom: 15)
        mapView.camera = camera
        
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: Double(model.lat) ?? 0, longitude: Double(model.lng) ?? 0)
        marker1.title = model.name
        marker1.map = mapView
        marker1.icon = LOIMG("local_store")
    
        self.nameLab.text = model.name
        self.taglab.text = model.tags
        self.titlab.text = model.des
        
    }
    

}
