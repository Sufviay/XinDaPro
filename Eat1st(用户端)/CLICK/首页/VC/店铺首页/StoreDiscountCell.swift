//
//  StoreDiscountCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/19.
//

import UIKit

class StoreDiscountCell: BaseTableViewCell {


    private let backImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_dis1")
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    
    
    private let backImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_dis2")
        return img
    }()
    
    
    private let backImg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_dis3")
        return img
    }()

    
    private let backImg4: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_dis4")
        return img
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(backImg1)
        backImg1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(45)
        }
        
        
        contentView.addSubview(backImg2)
        backImg2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 45))
            $0.centerY.equalTo(backImg1)
            $0.right.equalTo(backImg1).offset(10)
        }
        
        contentView.addSubview(backImg3)
        backImg3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 65))
            $0.centerY.equalTo(backImg1)
            $0.left.equalTo(backImg1).offset(-25)
        }
        
        contentView.addSubview(backImg4)
        backImg4.snp.makeConstraints {
            $0.centerY.equalTo(backImg1)
            $0.centerX.equalTo(backImg1).offset(5)
        }
        
    }
    
    
    
}
