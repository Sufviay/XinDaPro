//
//  AddDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/3.
//

import UIKit

class AddDataCell: BaseTableViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#AAAAAA"), BFONT(13), .center)
        lab.text = "自定义数据"
        return lab
    }()
    
    private let addImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dis_add")
        return img
    }()
    
    override func setViews() {
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(addImg)
        addImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titlab.snp.left).offset(-10)
        }
    }
    
}

