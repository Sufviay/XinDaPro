//
//  OccupyStoreInfoCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit

class OccupyStoreInfoCell: BaseTableViewCell {


    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(18), .left)
        lab.numberOfLines = 0
        lab.text = "McDonald's® London"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Sandwiches·Breakfast·Lunch"
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(nameLab.snp.bottom).offset(3)
        }
        
    }
    
    func setCellData(name: String, des: String) {
        nameLab.text = name
        desLab.text = des
    }
    

}
