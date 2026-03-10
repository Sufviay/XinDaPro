//
//  SalesIncomePlatformCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/6.
//

import UIKit

class SalesIncomePlatformCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    private let ptNameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "Eat1st"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_10, .left)
        lab.numberOfLines = 0
        lab.text = "Orders"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_10, .center)
        lab.text = "Rate"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TXT_10, .right)
        
        lab.text = "Commission"
        return lab
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "9999"
        return lab
    }()
    
    private let tcMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .center)
        lab.text = "9999"
        return lab
    }()
    
    private let syMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .right)
        lab.text = "9999"
        return lab
    }()
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_10, .right)
        lab.text = "£"
        return lab
    }()

    
    private let sLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_10, .right)
        lab.text = "£"
        return lab
    }()

    
    
    
    
    
    

    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(ptNameLab)
        ptNameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(38)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalTo(tlab2)
        }
        
        contentView.addSubview(tcMoneyLab)
        tcMoneyLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-17)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalTo(tcMoneyLab)
        }
        
        contentView.addSubview(syMoneyLab)
        syMoneyLab.snp.makeConstraints {
            $0.centerY.equalTo(tcMoneyLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.bottom.equalTo(tcMoneyLab).offset(-2)
            $0.right.equalTo(tcMoneyLab.snp.left).offset(-2)
        }
        
        contentView.addSubview(sLab2)
        sLab2.snp.makeConstraints {
            $0.bottom.equalTo(syMoneyLab).offset(-2)
            $0.right.equalTo(syMoneyLab.snp.left).offset(-2)
        }
    }
    
    
    
    func setCellData(model: IncomePTDetailModel) {
        countLab.text = String(model.orderCount)
        tcMoneyLab.text = D_2_STR(model.commissionValue)
        syMoneyLab.text = D_2_STR(model.amount)
        ptNameLab.text = model.platform
    }
    
    
}
