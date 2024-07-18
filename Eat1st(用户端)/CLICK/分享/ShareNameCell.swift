//
//  ShareNameCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/6.
//

import UIKit

class ShareNameCell: BaseTableViewCell {
    
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F6F6F6")
        return view
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = UserDefaults.standard.userName ?? ""
        return lab
    }()
    
    
    override func setViews() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        headView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 30, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 15)
        
        
        headView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}
