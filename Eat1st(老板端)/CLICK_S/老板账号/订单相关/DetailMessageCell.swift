//
//  DetailMessageCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/31.
//

import UIKit

class DetailMessageCell: BaseTableViewCell {


    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = "Payment method"
        return lab
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Cash"
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(7)
        }
        
        contentView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(150)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(7)
        }
        
    }
    
    
    func setCellData(titStr: String, msg: String) {
        tLab.text = titStr
        contentLab.text = msg
    }
    

}
