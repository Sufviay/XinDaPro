//
//  TitleCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit

class TitleCell: BaseTableViewCell {
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Store ranking"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        img.image = GRADIENTCOLOR(HCOLOR("#28B1FF"), HCOLOR("#2B8AFF"), CGSize(width: 70, height: 3))
        return img
    }()
    
    

    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 70, height: 3))
        }
    }
    
    
    func setCellData(titStr: String) {
        self.titlab.text = titStr
        
        if titStr == "Live Reporting" {
            line.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        }
        if titStr == "Real time order" {
            line.image = GRADIENTCOLOR(HCOLOR("#2C6BF8"), HCOLOR("#6B12CC"), CGSize(width: 70, height: 3))
        }
    }
}
