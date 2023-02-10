//
//  OrderMoneyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class OrderMoneyCell: BaseTableViewCell {

    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Sub fee"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Delivery fee"
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Total fee"
        return lab
    }()
    
    private let tlab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Payment method"
        return lab
    }()
    
    private let moneyLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let moneyLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    
    private let moneyLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    
    private let moneyLab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        return view
    }()

    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.top.equalTo(tlab1.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.top.equalTo(tlab2.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab4)
        tlab4.snp.makeConstraints {
            $0.top.equalTo(tlab3.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(10)
        }

        contentView.addSubview(moneyLab1)
        moneyLab1.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(tlab1)
        }
        
        contentView.addSubview(moneyLab2)
        moneyLab2.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab3)
        moneyLab3.snp.makeConstraints {
            $0.centerY.equalTo(tlab3)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab4)
        moneyLab4.snp.makeConstraints {
            $0.centerY.equalTo(tlab4)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    func setCellData(model: OrderModel) {
        self.moneyLab1.text = "£\(model.amountOriginal)"
        self.moneyLab2.text = "£\(model.amountDelivery)"
        self.moneyLab3.text = "£\(model.amountTotal)"
        let way = model.paymentMethod == "1" ? "cash" : "card"
        self.moneyLab4.text = way
    }

}
