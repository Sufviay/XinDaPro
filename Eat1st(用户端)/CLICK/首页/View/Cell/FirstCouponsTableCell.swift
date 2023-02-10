//
//  FirstCouponsTableCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit

class FirstCouponsTableCell: BaseTableViewCell {


    private let backView: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_coupon_b")
        return img
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(14), .left)
        lab.text = "New User Coupons"
        return lab
    }()
    
    
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(SET_H(110, 355))
            $0.top.equalToSuperview()
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(7)
            $0.top.equalToSuperview().offset(R_H(8))
        }
        
    }
    
    

}
