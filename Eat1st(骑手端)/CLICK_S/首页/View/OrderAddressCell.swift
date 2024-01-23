//
//  OrderAddressCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/7/21.
//

import UIKit

class OrderAddressCell: BaseTableViewCell {
    
    private var lat: Double = 0
    private var lng: Double = 0
    //private var address: String = ""
    
    private let disLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "1.5miles"
        return lab
    }()
    
    private let checkBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("local_y"), for: .normal)
        return but
    }()
    
    private let localImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("local")
        return img
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "太原街 陕西路 绍兴街18号 900444室 就在这里的啊"
        return lab
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(disLab)
        disLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(0)
        }
        
        contentView.addSubview(checkBut)
        checkBut.snp.makeConstraints {
            $0.centerY.equalTo(disLab)
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(localImg)
        localImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 13, height: 13))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-10)
        }
        
        checkBut.addTarget(self, action: #selector(clickLocalAciton), for: .touchUpInside)

    }
    
    func setCellData(model: OrderModel) {
        self.disLab.text = "Distance:  " +  D_2_STR(model.distance) + "miles"
        self.addressLab.text = model.addressStr//model.postCode + "\n" + model.address
        
        self.lat = model.lat
        self.lng = model.lng
        //self.address = model.address
    }
    
    
    @objc func clickLocalAciton() {
        PJCUtil.goDaohang(lat: self.lat, lng: self.lng)
    }
    
    
//    func appleMap(lat:Double,lng:Double,destination:String){
//        let loc = CLLocationCoordinate2DMake(lat, lng)
//        let currentLocation = MKMapItem.forCurrentLocation()
//        let toLocation = MKMapItem(placemark:MKPlacemark(coordinate:loc,addressDictionary:nil))
//        toLocation.name = destination
//
//
//        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue, MKLaunchOptionsShowsTrafficKey: "true"])
//    }

    
}
