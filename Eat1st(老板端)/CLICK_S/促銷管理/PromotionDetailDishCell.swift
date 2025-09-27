//
//  PromotionDetailDishCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/20.
//

import UIKit

class PromotionDetailDishCell: BaseTableViewCell {


    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Dish name".local + ":"
        return lab
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.width.equalTo(85)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(105)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
        }
        
    }
    
    
    func setCellData(titStr: String, msgStr: String) {
        nameLab.text = msgStr
        tLab.text = titStr
    }
    
}
