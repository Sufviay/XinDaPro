//
//  WalletDetailCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/1/25.
//

import UIKit

class WalletDetailCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "refund"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), SFONT(10), .left)
        lab.text = "2022-01-10 01:21:51"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .right)
        lab.text = "+10"
        return lab
    }()
    
    private let numLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), SFONT(10), .right)
        lab.text = "E2201091721508802909"
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
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(numLab)
        numLab.snp.makeConstraints {
            $0.centerY.equalTo(timeLab)
            $0.right.equalToSuperview().offset(-20)
        }
    
    }
    
    func setCellData(model: WalletDetailModel) {
        self.titlab.text = model.name
        self.timeLab.text = model.createTime
        self.numLab.text = model.orderID
        
        if model.type == "1" {
            moneyLab.textColor = HCOLOR("#B80116")
            moneyLab.text = "-" +  D_2_STR(model.amount)
        } else {
            moneyLab.textColor = MAINCOLOR
            moneyLab.text = "+" + D_2_STR(model.amount)
        }
    }
}
