//
//  SalesHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/4/23.
//

import UIKit

class SalesHeaderCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_4, .left)
        lab.text = "Sales".local
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        return img
    }()
    
    private let todayBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Today".local, .white, TIT_3, MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
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
        
        contentView.addSubview(todayBut)
        todayBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 25))
            $0.centerY.equalTo(titlab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        todayBut.addTarget(self, action: #selector(clickButAction), for: .touchUpInside)
    }
    
    
    @objc private func clickButAction() {
        clickBlock?("")
    }
    
    
}
