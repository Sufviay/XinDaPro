//
//  OrderStoreInfoCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit

class OrderStoreInfoCell: BaseTableViewCell {

    
    private var lat: Double = 0
    private var lng:Double = 0
    
    private var storePhone: String = ""
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 55), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_logo")
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Greggs-Milton Keynes"
        return lab
    }()
    
    private let phoneBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("phone_y"), for: .normal)
        return but
    }()
    
    private let localBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("local_y"), for: .normal)
        return but
    }()
    

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 13, height: 13))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        backView.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        
        backView.addSubview(localBut)
        localBut.snp.makeConstraints {
            $0.size.equalTo(phoneBut)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        localBut.addTarget(self, action: #selector(clickLocalAction), for: .touchUpInside)
        
    }
    
    func setCellData(model: ConfirmOrderCartModel) {
        self.nameLab.text = model.storeName
        self.storePhone = model.storePhone
        self.lat = Double(model.lat) ?? 0
        self.lng = Double(model.lng) ?? 0
    }
    
    func setCell2Data(model: StoreInfoModel) {
        self.nameLab.text = model.name
        self.storePhone = model.phone
        self.lat = Double(model.lat) ?? 0
        self.lng = Double(model.lng) ?? 0
    }
    
    

    @objc private func clickPhoneAction() {
        PJCUtil.callPhone(phone: storePhone)
    }
    
    
    @objc private func clickLocalAction() {
        PJCUtil.showLoacl(lat: lat, lng: lng)
    }
    

}
