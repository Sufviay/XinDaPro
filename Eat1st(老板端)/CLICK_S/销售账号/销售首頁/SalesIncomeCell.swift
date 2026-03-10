//
//  SalesIncomeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/5.
//

import UIKit


class SalesIncomeCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, TIT_14, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "24/12/2025 — 24/1/2026"
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_blue")
        return img
    }()
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TIT_12, .left)
        lab.text = "Orders"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TIT_12, .left)
        lab.text = "Commission"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .left)
        lab.text = "99999"
        return lab
    }()

    
    
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_10, .left)
        lab.text = "£"
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .left)
        lab.text = "99999"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    

    

    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-50)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalTo(timeLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(timeLab.snp.bottom).offset(10)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(170))
            $0.centerY.equalTo(tlab1)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(tlab1.snp.bottom).offset(2)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(tlab2).offset(10)
            $0.centerY.equalTo(countLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.left.equalTo(tlab2)
            $0.bottom.equalTo(moneyLab).offset(-2)
        }
        
    }
    
    
    func setCellData(model: IncomeRecordModel) {
        timeLab.text = model.beginTime.changeDateStr() + " - " + model.endTime.changeDateStr()
        countLab.text = String(model.orderCount)
        moneyLab.text = D_2_STR(model.commission)
    }
    
    
}
