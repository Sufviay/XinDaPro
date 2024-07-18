//
//  OccupyLabCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit

class OccupyLabCell: BaseTableViewCell {


    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(12), .left)
        lab.text = "Please choose a time below："
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
    }
    
    
}
