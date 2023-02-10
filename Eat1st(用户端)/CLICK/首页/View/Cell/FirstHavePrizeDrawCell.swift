//
//  FirstHavePrizeDrawCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/10/9.
//

import UIKit

class FirstHavePrizeDrawCell: BaseTableViewCell {

    private let c_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("wheel2")
        return img
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(c_img)
        c_img.snp.makeConstraints {
            $0.width.equalTo(R_W(353))
            $0.height.equalTo(SET_H(70, 353))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
    }

}
