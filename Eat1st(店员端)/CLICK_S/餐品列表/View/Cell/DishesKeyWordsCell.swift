//
//  DishesKeyWordsCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/16.
//

import UIKit

class DishesKeyWordsCell: BaseTableViewCell {

    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .left)
        lab.text = "Key words："
        return lab
    }()
    
    private let keyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFCB06"), BFONT(13), .left)
        lab.text = "AW 23 Chicken"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(keyLab)
        keyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(85)
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    
    func setCellData(key: String) {
        keyLab.text = key
    }
    
    
}
