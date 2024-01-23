//
//  OrderDetailRefundCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/1/6.
//

import UIKit

class OrderDetailRefundCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Refund"
        return lab
    }()

    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "text"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "text"
        return lab
    }()

    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "text"
        return lab
    }()
    
    let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "11111"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(titLab.snp.bottom).offset(15)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(tlab1.snp.bottom).offset(5)
        }
        

        backView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(tlab2.snp.bottom).offset(5)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
        }

    }
    
    
    func setCellData(model: OrderDetailModel) {
        titLab.text = "Refund - \(model.refundStatusName)"
        tlab1.text = model.refundTypeName
        tlab2.text = "Refund method - \(model.refundFlowName)"
        
        var money = ""
        
        if model.cashPrice != 0 {
            money += "Cash £\(D_2_STR(model.cashPrice)) "
        }
        if model.posPrice != 0 {
            money += "POS £\(D_2_STR(model.posPrice)) "
        }
        if model.cardPrice != 0 {
            money += "Card £\(D_2_STR(model.cardPrice)) "
        }
        tlab3.text = "Refund amount - \(money)"
        timeLab.text = model.refundCreateTime
    }
    
}
