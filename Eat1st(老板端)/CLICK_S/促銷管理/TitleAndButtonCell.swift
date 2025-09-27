//
//  TitleAndButtonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/19.
//

import UIKit

class TitleAndButtonCell: BaseTableViewCell {

    var clickAddBlock: VoidBlock?
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Select dishes".local
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        return lab
    }()

    
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
        lab.text = "Add specifications".local
        return lab
    }()

    
    

    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            //$0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(17)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.height.equalTo(50)
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

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAddAction))
        backView.addGestureRecognizer(tap)
        
    }
    
    
    @objc private func clickAddAction() {
        clickAddBlock?("")
    }
    
    
    
}

