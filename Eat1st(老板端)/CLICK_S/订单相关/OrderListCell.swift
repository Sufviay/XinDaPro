//
//  OrderListCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/7/20.
//

import UIKit

class OrderListCell: BaseTableViewCell {


    private var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        
        view.layer.shadowColor = HCOLOR("#252275").withAlphaComponent(0.3).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3

        return view
    }()
    
    
    private let xlhLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), TIT_2, .left)
        lab.text = "#999"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    private let orderNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        lab.text = "#1550515678022548934"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    
    private let orderTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = "Delivery"
        return lab
    }()
    
    
    private let payTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), TIT_3, .right)
        lab.text = "Card"
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), TIT_3, .right)
        lab.text = "£46.80"
        return lab
    }()
    
    private let sourceLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        lab.text = "Deliveroo"
        return lab
    }()

    
    private let stautsLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "已完成"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_2, .right)
        lab.text = "2024-04-05"
        return lab
    }()

    
    
    private let payLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, SFONT(14), .right)
        lab.text = "Card: £0.00"
        lab.numberOfLines = 0
        return lab
    }()
    
    

    
    
    
    override func setViews() {
        
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        
        backView.addSubview(xlhLab)
        xlhLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(45)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(orderNumLab)
        orderNumLab.snp.makeConstraints {
            $0.left.equalTo(xlhLab.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-80)
            $0.centerY.equalTo(xlhLab)
        }
        
        backView.addSubview(orderTypeLab)
        orderTypeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalTo(xlhLab)
        }
        
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalTo(xlhLab.snp.bottom).offset(7)
            $0.right.equalToSuperview().offset(-15)

        }


        
        backView.addSubview(payTypeLab)
        payTypeLab.snp.makeConstraints {
            $0.right.equalTo(moneyLab.snp.left).offset(-5)
            $0.centerY.equalTo(moneyLab)
        }

        
        
        
        
        backView.addSubview(sourceLab)
        sourceLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalTo(moneyLab)
        }
        
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-12)
            
        }
        
        backView.addSubview(stautsLab)
        stautsLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalTo(timeLab)
        }
        
        
        backView.addSubview(payLab1)
        payLab1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-15)
        }
                
    }
    
    
    func setCellData(model: OrderDetailModel) {
        
        payLab1.text = model.payTypeStr
        
        xlhLab.text = "#" + model.dayNum
        orderNumLab.text = model.orderNum
        
        if model.deliveryType == "1" {
            orderTypeLab.text = "Delivery".local
        }
        if model.deliveryType == "2" {
            orderTypeLab.text = "Collection".local
        }
        if model.deliveryType == "3" {
            orderTypeLab.text = "Dine-in".local
        }
        
        moneyLab.text = "£\(D_2_STR(model.orderPrice))"
        
        
        if model.paymentMethod == "1" {
            payTypeLab.text = "Cash"
        } else if model.paymentMethod == "2" {
            payTypeLab.text = "Card"
        } else if model.paymentMethod == "3" {
            payTypeLab.text = "Pos"
        } else if model.paymentMethod == "4" {
            payTypeLab.text = "Cash&Pos"
        } else if model.paymentMethod == "5" {
            payTypeLab.text = "WX"
        } else if model.paymentMethod == "6" {
            payTypeLab.text = "Wallet Spent"
        } else {
            payTypeLab.text = "Unknow"
        }
        

            
        if model.source == "1" {
            sourceLab.text = "Deliveroo"
            sourceLab.textColor = HCOLOR("#02C392")
            backView.backgroundColor = HCOLOR("#EFFFF2")
        } else if model.source == "2" {
            sourceLab.text = "Uber Eats"
            sourceLab.textColor = TXTCOLOR_1
            backView.backgroundColor = HCOLOR("#EEEEEE")
        } else if model.source == "3" {
            sourceLab.text = "JustEat"
            sourceLab.textColor = HCOLOR("#FCB138")
            backView.backgroundColor = HCOLOR("#FFFAEE")
        } else {
            sourceLab.text = ""
            sourceLab.textColor = TXTCOLOR_1
            backView.backgroundColor = .white
        }
        
        
        stautsLab.text = model.statusStr
        timeLab.text = model.createTime

        
        
        
        
        
    }
    
    
}
