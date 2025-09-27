//
//  SelectTagCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/25.
//

import UIKit

class SelectTagCell: BaseTableViewCell {

    
    var clickBlock: VoidBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Customer Tags".local
        return lab
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 7
        return view
    }()
    

    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_show")
        return img
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(17)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview()
        }
    
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        backView.addGestureRecognizer(tap)
    }
    
    
    @objc private func clickAction() {
        clickBlock?("")
    }
    
    
    func setCellData(titStr: String) {
        contentLab.text = titStr
    }
    
}
