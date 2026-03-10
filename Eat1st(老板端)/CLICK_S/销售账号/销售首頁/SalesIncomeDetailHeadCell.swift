//
//  SalesIncomeDetailHeadCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/6.
//

import UIKit

class SalesIncomeDetailHeadCell: BaseTableViewCell {


    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#2968FE")
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let storeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .left)
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()

    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TIT_14, .left)
        lab.text = "Commission"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .right)
        lab.text = "999.99"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_10, .left)
        lab.text = "£"
        return lab
    }()

    
    
    override func setViews() {
                
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(4)
            $0.height.equalTo(15)
        }
        
        contentView.addSubview(storeLab)
        storeLab.snp.makeConstraints {
            $0.centerY.equalTo(line)
            $0.left.equalTo(line.snp.right).offset(7)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-2)
        }
        
        
    }
    
    func setCellData(name: String, money: String) {
        storeLab.text = name
        moneyLab.text = money
    }
    
    
}
