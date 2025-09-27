//
//  DetailStatusCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/14.
//

import UIKit

class DetailStatusCell: BaseTableViewCell {


    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    
    private let sellTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Delivery"
        return lab
    }()

    
    private let ptTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_5, TIT_2, .right)
        lab.text = "Deliveroo"
        return lab
    }()

    
    
    private let dayNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_4, TIT_2, .left)
        lab.text = "#099"
        return lab
    }()

    

    private var statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .right)
        lab.text = "Completed"
        return lab
    }()
    
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Order code:".local
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Order time:".local
        return lab
    }()
    
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = ""
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = ""
        return lab
    }()

    
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    
    override func setViews() {
        
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 5, height: 15))
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
        }

        
        contentView.addSubview(sellTypeLab)
        sellTypeLab.snp.makeConstraints {
            $0.left.equalTo(line1.snp.right).offset(3)
            $0.centerY.equalTo(line1)
        }
        
        contentView.addSubview(ptTypeLab)
        ptTypeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(line1)
        }

        
        contentView.addSubview(dayNumLab)
        dayNumLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line1.snp.bottom).offset(10)
        }
        
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(dayNumLab)
        }
        
        
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(dayNumLab.snp.bottom).offset(10)
        }

        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab1.snp.bottom).offset(10)
        }

        
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.left.equalTo(tlab1.snp.right).offset(5)
            $0.centerY.equalTo(tlab1)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalTo(tlab2.snp.right).offset(5)
            $0.centerY.equalTo(tlab2)
        }

        
    }
    
    
    func setCellData(model: OrderDetailModel) {
        statusLab.text = model.statusStr
        timeLab.text = model.createTime
        orderLab.text = model.orderNum
        
        dayNumLab.text = "#\(model.dayNum)"
        
        if model.deliveryType == "1" {
            sellTypeLab.text = "Delivery".local
        }
        if model.deliveryType == "2" {
            sellTypeLab.text = "Collection".local
        }
        if model.deliveryType == "3" {
            sellTypeLab.text = "Dine-in".local
        }
        
        if model.source == "0" {
            ptTypeLab.isHidden = true
        }
        if model.source == "1" {
            ptTypeLab.isHidden = false
            ptTypeLab.text = "Deliveroo"
        }
        if model.source == "2" {
            ptTypeLab.isHidden = false
            ptTypeLab.text = "Uber Eats"
        }
        if model.source == "3" {
            ptTypeLab.isHidden = false
            ptTypeLab.text = "JustEat"
        }
        
    }
    
    
    

}
