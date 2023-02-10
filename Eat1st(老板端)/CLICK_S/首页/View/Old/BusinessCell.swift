//
//  BusinessCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/4.
//

import UIKit

class BusinessCell: BaseTableViewCell {


    private let cashMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.text = "100000"
        return lab
    }()
    
    private let cashLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "cash"
        return lab
    }()
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let onlineMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "100000"
        return lab
    }()
    
    private let onlineLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "card"
        return lab
    }()
    
    private let sLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    
    private let totalMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(20), .left)
        lab.text = "100000"
        return lab
    }()
    
    private let totalLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "Today's water"
        return lab
    }()
    
    private let sLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(15), .right)
        lab.text = "£"
        return lab
    }()
    
    private let deSw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = MAINCOLOR
        return sw
    }()
    
    private let coSw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = MAINCOLOR
        return sw
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(cashLab)
        cashLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(cashMoney)
        cashMoney.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.bottom.equalTo(cashMoney).offset(-2)
            $0.right.equalTo(cashMoney.snp.left)
        }
        
        contentView.addSubview(onlineMoney)
        onlineMoney.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(cashMoney)
        }
        
        contentView.addSubview(onlineLab)
        onlineLab.snp.makeConstraints {
            $0.centerX.equalTo(onlineMoney)
            $0.centerY.equalTo(cashLab)
        }
        
        contentView.addSubview(sLab2)
        sLab2.snp.makeConstraints {
            $0.bottom.equalTo(onlineMoney).offset(-2)
            $0.right.equalTo(onlineMoney.snp.left)
        }
        
        contentView.addSubview(totalMoney)
        totalMoney.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalTo(cashMoney)
        }
        
        contentView.addSubview(totalLab)
        totalLab.snp.makeConstraints {
            $0.centerX.equalTo(totalMoney)
            $0.centerY.equalTo(cashLab)
        }
        
        contentView.addSubview(sLab3)
        sLab3.snp.makeConstraints {
            $0.bottom.equalTo(totalMoney).offset(-3)
            $0.right.equalTo(totalMoney.snp.left)
        }
    
    
        
    }
    
    
}
