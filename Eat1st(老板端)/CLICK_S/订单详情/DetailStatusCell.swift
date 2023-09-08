//
//  DetailStatusCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/14.
//

import UIKit

class DetailStatusCell: BaseTableViewCell {


    private let dayNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(20), .left)
        lab.text = "#099"
        return lab
    }()

    
    private let sellTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .right)
        lab.text = "Delivery"
        return lab
    }()
    

    private var statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(18), .left)
        lab.text = "Completed"
        return lab
    }()
    
    private var moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(20), .right)
        lab.text = "£400"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "#1550515678022548934"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .right)
        lab.text = "2022-06-08"
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    override func setViews() {
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        
        contentView.addSubview(dayNumLab)
        dayNumLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(sellTypeLab)
        sellTypeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
        }
        
        
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(40)
        }
        
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(statusLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(statusLab.snp.bottom).offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(orderLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
    }
    
    
    func setCellData(model: OrderDetailModel) {
        statusLab.text = model.statusStr
        timeLab.text = model.createTime
        orderLab.text = model.id
        moneyLab.text = "£" + D_2_STR(model.payPrice)
        dayNumLab.text = "#\(model.dayNum)"
        
        if model.deliveryType == "1" {
            sellTypeLab.text = "Delivery"
        }
        if model.deliveryType == "2" {
            sellTypeLab.text = "Collection"
        }
        if model.deliveryType == "3" {
            sellTypeLab.text = "Dine-in"
        }
        
    }
    
    
    

}
