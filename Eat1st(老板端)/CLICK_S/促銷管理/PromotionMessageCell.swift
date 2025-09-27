//
//  PromotionMessageCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/20.
//

import UIKit

class PromotionMessageCell: BaseTableViewCell {

    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "111"
        return lab
    }()

    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Menu numbering"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(5)
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(30)
        }
        
    }
    
    func setCellData(titStr: String, msgStr: String) {
        self.titleLab.text = titStr
        self.msgLab.text = msgStr
    }

    
}
