//
//  MenuVipCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/1.
//

import UIKit

class MenuVipCell: BaseTableViewCell {

    private var infoModel = StoreInfoModel()
    
    private let vipImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("vip")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    private let amountBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#FAFAFA")
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    
    private let amountImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        return img
    }()
    
    private let amountNext: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jf_next")
        return img
    }()
    
    private let amountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#6B4419"), BFONT(14), .right)
        lab.text = "1000.41"
        return lab
    }()
    


    override func setViews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(vipImg)
        vipImg.snp.makeConstraints {
            $0.width.equalTo(R_W(345))
            $0.height.equalTo(SET_H(50, 345))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        
        vipImg.addSubview(amountBut)
        amountBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 20))
            $0.centerY.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(R_W(90))
        }
        
        amountBut.addSubview(amountImg)
        amountImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 14))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
        }
        
        amountBut.addSubview(amountNext)
        amountNext.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 5, height: 8))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }
        
        
        amountBut.addSubview(amountLab)
        amountLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(amountImg.snp.right).offset(5)
        }
        
        amountBut.addTarget(self, action: #selector(clickVipAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickVipAction() {
        let amountVC = RechargeDetailController()
        amountVC.storeID = infoModel.storeID
        amountVC.storeName = infoModel.name
        PJCUtil.currentVC()?.navigationController?.pushViewController(amountVC, animated: true)
    }
    
    func setCellData(model: StoreInfoModel, canClick: Bool) {
        infoModel = model
        amountLab.text = model.vipAmount
        let w = model.vipAmount.getTextWidth(BFONT(14), 15)
        amountBut.snp.remakeConstraints {
            $0.centerY.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(R_W(90))
            $0.height.equalTo(20)
            $0.width.equalTo(w + 40)
        }
        
        if canClick {
            amountBut.isHidden = false
        } else {
            amountBut.isHidden = true
        }
 
    }
}
