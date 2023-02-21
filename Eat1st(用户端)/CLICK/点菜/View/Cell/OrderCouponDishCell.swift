//
//  OrderCouponDishCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/21.
//

import UIKit

class OrderCouponDishCell: BaseTableViewCell {


    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Gift"
        return lab
    }()
    
    private let goodsImg: CustomImgeView = {
        let img = CustomImgeView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.numberOfLines = 0
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Dish Name 1"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .right)
        lab.text = "x1"
        return lab
    }()

    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .right)
        lab.text = "FREE"
        return lab
    }()
    

    override func setViews() {
            
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 55))
            $0.top.equalTo(titlab.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        
        backView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(goodsImg.snp.centerY).offset(-2)
        }
        
        backView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(freeLab.snp.bottom).offset(2)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalTo(goodsImg)
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-75)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    
}
