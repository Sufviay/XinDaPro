//
//  OrderRemarkCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/2.
//

import UIKit

class OrderRemarkCell: BaseTableViewCell {

    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Remark"
        return lab
    }()
    
    let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "看起来不太好的样子"
        return lab
    }()

    
    

    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
        }
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(80)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
        }
        
    }
    
    
    

}
