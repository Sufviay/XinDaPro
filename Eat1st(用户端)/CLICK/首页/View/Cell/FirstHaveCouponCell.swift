//
//  FirstHaveCouponCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/26.
//

import UIKit

class FirstHaveCouponCell: BaseTableViewCell {


    private let gitImg1: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let gitImg2: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    private let gitImg3: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        
        return img
    }()

    private let titImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        img.image = LOIMG("coupon_wenzi")
        return img
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(gitImg1)
        gitImg1.snp.makeConstraints {
            $0.width.equalTo(R_W(350))
            $0.height.equalTo(SET_H(110, 350))
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        gitImg1.addSubview(gitImg2)
        gitImg2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(R_H(15))
            $0.right.equalToSuperview().offset(-R_W(33))
            $0.width.height.equalTo(R_H(55))
        }
        
        gitImg1.addSubview(gitImg3)
        gitImg3.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gitImg1.addSubview(titImg)
        titImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.centerY.equalTo(gitImg2)
            $0.size.equalTo(CGSize(width: R_W(225), height: SET_H(34, 225)))
        }
        
//        gitImg1.image = PJCUtil.getGifImg(name: "优惠劵背景")
//        gitImg2.image = PJCUtil.getGifImg(name: "优惠劵按钮")
//        gitImg3.image = PJCUtil.getGifImg(name: "金币喷散动图-横版")

        
    }
    
    
    func setCellData() {
        gitImg1.image = PJCUtil.getGifImg(name: "优惠劵背景")
        gitImg2.image = PJCUtil.getGifImg(name: "优惠劵按钮")
        gitImg3.image = PJCUtil.getGifImg(name: "金币喷散动图-横版")
    }
    
    
}
