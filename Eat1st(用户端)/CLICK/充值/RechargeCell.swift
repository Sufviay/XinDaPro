//
//  RechargeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/16.
//

import UIKit

class RechargeCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), SFONT(10), .left)
        lab.text = "2022-01-10  01:21:51"
        return lab
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "TOP UP"
        return lab
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F56D00"), BFONT(14), .right)
        lab.text = "+100"
        return lab
    }()
    
    private let giftLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(11), .right)
        lab.text = "Gift"
        return lab
    }()
    
    

    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(giftLab)
        giftLab.snp.makeConstraints {
            $0.right.equalTo(numberLab)
            $0.top.equalTo(numberLab.snp.bottom).offset(2)
        }
        

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
        
    }
    
    
    func setCellData(model: RechargeModel) {
        timeLab.text = model.createTime
        
        if model.remark == "" {
            line.isHidden = false
        } else {
            line.isHidden = true
        }
        
        if model.detailType == "1" ||  model.detailType == "4" {
            //充值
            nameLab.text = "Top Up"
            numberLab.textColor = HCOLOR("#F56D00")
            numberLab.text = "+\(D_2_STR(model.amount))"
            if model.giftAmount == 0 {
                giftLab.isHidden = true
            }  else {
                giftLab.isHidden = false
            }
            giftLab.text = "Gift \(D_2_STR(model.giftAmount))"
        }
        if model.detailType == "2" || model.detailType == "5" {
            //消费
            nameLab.text = "USE"
            numberLab.textColor = FONTCOLOR
            numberLab.text = "-\(D_2_STR(model.amount))"
            giftLab.isHidden = true
            giftLab.text = ""
        }
        
        if model.detailType == "3" {
            //退款
            nameLab.text = "Refund"
            numberLab.textColor = HCOLOR("#F56D00")
            numberLab.text = "+\(D_2_STR(model.amount))"
            giftLab.isHidden = true
            giftLab.text = ""
        }
        
    }
    
    
}
