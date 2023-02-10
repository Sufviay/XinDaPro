//
//  SalesOrderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit

class SalesOrderCell: BaseTableViewCell {

    
    
    private let tLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(15), .center)
        lab.text = "Sales"
        return lab
    }()
    
    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(15), .center)
        lab.text = "Order"
        return lab
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#007CFF"), BFONT(15), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#007CFF"), BFONT(25), .center)
        lab.text = "897667.4"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#007CFF"), BFONT(25), .center)
        lab.text = "897667.4"
        return lab
    }()


    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
            $0.right.equalTo(contentView.snp.centerX)
        }
        
        contentView.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.centerY.equalTo(tLab1)
            $0.right.equalToSuperview()
            $0.left.equalTo(contentView.snp.centerX)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerX.equalTo(tLab1).offset(5)
            $0.bottom.equalTo(tLab1.snp.top).offset(-2)
        }
        
        contentView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-5)
            $0.right.equalTo(moneyLab.snp.left).offset(-2)
        }
        
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.centerY.equalTo(moneyLab)
            $0.centerX.equalTo(tLab2)
        }
        
        
    }
    
    
    func setCellData(money: String, order: String) {
        self.moneyLab.text = money
        self.orderLab.text = order
    }
    

    
    
}
