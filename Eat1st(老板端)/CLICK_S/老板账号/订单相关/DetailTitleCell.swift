//
//  DetailTitleCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/31.
//

import UIKit

class DetailTitleCell: BaseTableViewCell {

    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(14), .left)
        lab.text = "Dishes"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
    }
    
    

}
