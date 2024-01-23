//
//  OrderDishFreeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit

class OrderDishFreeCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFD645").withAlphaComponent(0.08)
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF9A00"), BFONT(9), .center)
        lab.layer.cornerRadius = 2
        lab.layer.borderColor = HCOLOR("#FEB637").cgColor
        lab.layer.borderWidth = 1
        lab.text = "FREE"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), SFONT(10), .right)
        lab.text = "x1"
        return lab
    }()

    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(10), .left)
        lab.text = "£0"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.right.equalToSuperview().offset(-120)
        }
        
        backView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(65)
            $0.centerY.equalToSuperview()
            
        }
        
        backView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    
    func setCellData(count: Int) {
        countLab.text = "x\(count)"
    }

}
