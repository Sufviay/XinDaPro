//
//  ComplaintsContentCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsContentCell: BaseTableViewCell {

    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "This dish is not fresh, it is very salty, and it is not delicious.This dish is not fresh, it is very salty, and it is not delicious"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    
    func setCellData(content: String) {
        self.contentLab.text = content
    }

}
