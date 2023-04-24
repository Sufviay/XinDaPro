//
//  DishDetailKuCunCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/8/12.
//

import UIKit

class DishDetailKuCunCell: BaseTableViewCell {

    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Stock"
        return lab
    }()
    
    private let msgLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "111"
        return lab
    }()
    
    private let msgLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "111"
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(msgLab1)
        msgLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)

            $0.top.equalToSuperview().offset(35)
        }
        
        
        contentView.addSubview(msgLab2)
        msgLab2.snp.makeConstraints {
            $0.centerY.equalTo(msgLab1)
            $0.left.equalTo(msgLab1.snp.right).offset(50)
        }

        
    }
    
    
    func setCellData(type: String, num: String) {
        if type == "1" {
            self.msgLab1.text = "Disable"
            self.msgLab2.text = ""
        } else {
            self.msgLab1.text = "Enable"
            self.msgLab2.text = num
        }
    }
    
    
    
}
