//
//  OrderHeaderTypeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import MapKit

class OrderHeaderTypeCell: BaseTableViewCell {
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = "Collection"
        return lab
    }()
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.centerY.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: 6, height: 17))
        }
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
    }

}


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
        self.disLab.text = "Distance:  " +  String(model.distance) + "miles"
        self.addressLab.text = model.postCode + "\n" + model.address
        
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

class OrderRefuseCell: BaseTableViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Refuse reason"
        return lab
    }()
    
    let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "看起来不太好的样子"
        return lab
    }()

    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(130)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
    }
    
}

class OrderDealButCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        return view
    }()
    
    private let dealBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Dispose", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 15
        return but
    }()
    
    
    override func setViews() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(dealBut)
        dealBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 30))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        dealBut.addTarget(self, action: #selector(clickAciton), for: .touchUpInside)
        
    }
    
    
    @objc private func clickAciton() {
        self.clickBlock?("")
    }
}


