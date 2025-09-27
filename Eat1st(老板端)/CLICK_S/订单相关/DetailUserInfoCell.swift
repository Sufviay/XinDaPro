//
//  DetailUserInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/31.
//

import UIKit

class DetailUserInfoCell: BaseTableViewCell {

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .left)
        lab.text = "Ms zhang"
        return lab
    }()
    
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "13465863987"
        return lab
    }()


    override func setViews() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.left.equalTo(nameLab.snp.right).offset(10)
        }
        
    }
    
    
    func setCellData(name: String, phone: String) {
        nameLab.text = name
        phoneLab.text = phone
    }
    
    
}
