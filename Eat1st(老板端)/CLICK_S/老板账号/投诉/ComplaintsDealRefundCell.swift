//
//  ComplaintsDealRefundCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/29.
//

import UIKit

class ComplaintsDealRefundCell: BaseTableViewCell {

    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
        lab.text = "Refund way:"
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
        lab.text = "Refund amount:"
        return lab
    }()
    
    private let wayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(11), .left)
        lab.text = "card"
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(11), .left)
        lab.text = "£50.00"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(160)
            $0.centerY.equalTo(tlab1)
        }
        
        contentView.addSubview(wayLab)
        wayLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.left.equalTo(tlab1.snp.right).offset(5)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.left.equalTo(tlab2.snp.right).offset(5)
        }

        
    }
    
    
    
    func setCellData(way: String, money: String) {
        wayLab.text = way
        moneyLab.text = "£\(money)"
    }
    
    

}
