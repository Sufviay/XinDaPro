//
//  AddItemCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/24.
//

import UIKit

class AddItemCell: BaseTableViewCell {

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 10
        return view
    }()

    private let addImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dis_add")
        return img
    }()
    
    let inLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_2, .center)
        lab.text = "Add"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(inLab)
        inLab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(addImg)
        addImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(inLab.snp.left).offset(-10)
            $0.size.equalTo(CGSize(width: 25, height: 25))
        }
        
    }
    
    
}
