//
//  StoreIntroduceAddressCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class StoreIntroduceAddressCell: BaseTableViewCell {

    private var phoneNum: String = ""
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()

    
    private let addressImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_local")
        return img
    }()
    
    private let phoneBut: UIButton  = {
        let but = UIButton()
        but.setImage(LOIMG("phone_y"), for: .normal)
        return but
    }()

    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Store address：88 Taishan East Street, Changchun Road Street"
        return lab
    }()
    
    

    override func setViews() {
        contentView.backgroundColor = .white
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(addressImg)
        addressImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 16))
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 28))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-65)
        }
        
        contentView.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()

        }
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(45)
            $0.right.equalTo(line2.snp.left).offset(-80)
        }
        
        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
    }
    
    
    @objc private func clickPhoneAction() {
        PJCUtil.callPhone(phone: phoneNum)
    }
    
    func setCellData(model: StoreInfoModel) {
        self.addressLab.text = model.storeAddress
        self.phoneNum = model.phone
    }
    
    

}
