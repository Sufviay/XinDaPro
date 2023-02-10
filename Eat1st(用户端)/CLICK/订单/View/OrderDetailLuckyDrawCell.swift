//
//  OrderDetailLuckyDrawCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/29.
//

import UIKit

class OrderDetailLuckyDrawCell: BaseTableViewCell {


    private let c_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("wheel")
        return img
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(c_img)
        c_img.snp.makeConstraints {
            $0.width.equalTo(R_W(327))
            $0.height.equalTo(SET_H(64, 327))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
    }
    
    
}
