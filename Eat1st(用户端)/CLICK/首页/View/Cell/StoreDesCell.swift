//
//  StoreDesCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/3/16.
//

import UIKit

class StoreDesCell: BaseTableViewCell {

    
    private let introduceLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(12), .center)
        lab.numberOfLines = 0
        lab.text = ""
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(introduceLab)
        introduceLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }

    }
    
    func setCellData(desLab: String) {
        self.introduceLab.text = desLab
    }
    
}
