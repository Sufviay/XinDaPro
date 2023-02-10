//
//  DishDetailAddSpecCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishDetailAddSpecCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
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
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(17), .center)
        lab.text = "Add specifications"
        return lab
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    
    override func setViews() {
        
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.height.equalTo(line1)
            $0.bottom.equalToSuperview()
        }
        
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
