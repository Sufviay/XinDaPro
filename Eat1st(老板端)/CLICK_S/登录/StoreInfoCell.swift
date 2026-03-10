//
//  StoreInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/1/26.
//

import UIKit

class StoreInfoCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderColor = MAINCOLOR.cgColor
        return view
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_black")
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(50)
        }
        
    }
    
    func setCellData(name: String, isSelect: Bool) {
        nameLab.text = name
        
        if isSelect {
            backView.layer.borderWidth = 2
        } else {
            backView.layer.borderWidth = 0
        }
    }
    
}
