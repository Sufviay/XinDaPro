//
//  OrderHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit

class OrderHeaderCell: BaseTableViewCell {
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 75), byRoundingCorners: [.topLeft, .topRight], radii: 15)
        return view
    }()
    
    private let dayNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(18), .left)
        lab.text = "#099"
        return lab
    }()
    
    private let orderIDLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(11), .center)
        lab.text = "#1664519363926028290"
        lab.backgroundColor = HCOLOR("#F4F6F9")
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 3
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(14), .right)
        lab.text = "待出餐"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#7A7D8C"), BFONT(10), .left)
        lab.text = "Total:"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .right)
        lab.text = "2023-06-13  21:38:59"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(17), .left)
        lab.text = "£205.55"
        return lab
    }()
    
    
    override func setViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.top.equalToSuperview()
        }
        
        backView.addSubview(dayNumLab)
        dayNumLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(orderIDLab)
        orderIDLab.snp.makeConstraints {
            $0.centerY.equalTo(dayNumLab)
            $0.left.equalToSuperview().offset(75)
            $0.size.equalTo(CGSize(width: 145, height: 15))
        }
        
        backView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalTo(dayNumLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(tlab.snp.right).offset(2)
            $0.bottom.equalTo(tlab.snp.bottom).offset(2)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
    
    
    func setCellData(model: OrderModel) {
        dayNumLab.text = "#\(model.orderDayNum)"
        orderIDLab.text = "#\(model.orderId)"
        timeLab.text = model.createTime
        moneyLab.text = "£\(D_2_STR(model.orderPrice))"
        
        if model.status == "8" {
            //支付成功
            statusLab.text = "已下單"
        }
        if model.status == "9" {
            //已接单
            statusLab.text = "已接單"
        }
        if model.status == "10" {
            //已出餐
            statusLab.text = "已出餐"
        }
        if model.status == "12" {
            //配送中
            statusLab.text = "待結算"
        }
        
    }
    
}
