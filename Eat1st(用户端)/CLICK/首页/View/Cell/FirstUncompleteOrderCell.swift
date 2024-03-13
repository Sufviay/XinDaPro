//
//  FirstUncompleteOrderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/1/23.
//

import UIKit

class FirstUncompleteOrderCell: BaseTableViewCell {

    
    private let cImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("first_order")
        return img
    }()

    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cImg)
        cImg.snp.makeConstraints {
            $0.width.equalTo(R_W(356))
            $0.height.equalTo(SET_H(90, 356))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)

        }
        
        
    }
    
    
}
