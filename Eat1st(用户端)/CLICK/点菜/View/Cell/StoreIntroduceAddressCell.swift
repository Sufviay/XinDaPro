//
//  StoreIntroduceAddressCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class StoreIntroduceAddressCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    
    private let addressImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_local")
        return img
    }()
    
    private let phoneImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("phone_y")
        return img
    }()

    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "TEL：13465868138"
        return lab
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
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(addressImg)
        addressImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 16))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(13)
        }
        
        backView.addSubview(phoneImg)
        phoneImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.centerY.equalTo(phoneImg)
            $0.left.equalToSuperview().offset(35)
        }
        
        backView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    
    func setCellData(model: StoreInfoModel) {
        self.addressLab.text = model.storeAddress
        self.phoneLab.text = "TEL：\(model.phone)"
    }
    
    

}
