//
//  PromotionStatusCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/20.
//

import UIKit

class PromotionStatusCell: BaseTableViewCell {


    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TIT_2, .left)
        lab.text = "Discount"
        return lab
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TXT_3, .center)
        lab.text = "In progress"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 20))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    func setCellData(statusID: String, couponType: String) {
        if statusID == "0" {
            //进行中
            backView.backgroundColor = HCOLOR("#3BC772")
            statusLab.text = "In progress".local
            
        }
        if statusID == "1" {
            //结束
            backView.backgroundColor = HCOLOR("#F75E5E")
            statusLab.text = "End".local
        }
        if statusID == "2" {
            //停止
            backView.backgroundColor = HCOLOR("#F75E5E")
            statusLab.text = "Stop".local
            
        }
        
        ///1折扣，2满减，3赠菜
        if couponType == "1" {
            typeLab.text = "p_Discount".local
        }
        if couponType == "2" {
            typeLab.text = "p_Money".local
        }
        if couponType == "3" {
            typeLab.text = "p_Dish".local
        }
        
    }
    
    
}


class PromotionEndCell: BaseTableViewCell {
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "End Date".local + ":"
        return lab
    }()
    
    
    let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Menu numbering"
        return lab
    }()


    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLab.snp.right).offset(5)
        }
        
    }
    
}
