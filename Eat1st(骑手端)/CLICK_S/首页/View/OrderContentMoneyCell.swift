//
//  OrderContentMoneyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/4/2.
//

import UIKit

class OrderContentMoneyCell: BaseTableViewCell {


    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "Cash"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .right)
        lab.text = "20"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(10), .right)
        lab.text = "£ "
        return lab
    }()
    
    override func setViews() {
        
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear


        contentView.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab.snp.bottom).offset(-3)
            $0.right.equalTo(moneyLab.snp.left).offset(-2)
        }
        
    }
    
    func setCellData(type: String, money: String) {
        self.typeLab.text = type
        self.moneyLab.text = money
    }
    

}
