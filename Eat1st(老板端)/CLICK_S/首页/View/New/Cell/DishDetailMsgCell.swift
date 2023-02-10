//
//  DishDetailMsgCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishDetailMsgCell: BaseTableViewCell {


    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Menu numbering"
        return lab
    }()
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "111"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalToSuperview().offset(35)
        }
        
    }
    
    func setCellData(titStr: String, msgStr: String) {
        self.titleLab.text = titStr
        self.msgLab.text = msgStr
        
        if titStr == "Price" {
            self.msgLab.textColor = HCOLOR("#6B7DFD")
        } else {
            self.msgLab.textColor = HCOLOR("666666")
        }
        
    }
    
}


class DishDetailOptionMsgCell: BaseTableViewCell {


    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Menu numbering"
        return lab
    }()
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "111"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalToSuperview().offset(35)
        }
        
    }
    
    func setCellData(titStr: String, msgStr: String) {
        self.titleLab.text = titStr
        self.msgLab.text = msgStr
    }
    
}

