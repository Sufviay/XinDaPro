//
//  SelectDateCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/6/26.
//

import UIKit

class EditSelectDateCell: BaseTableViewCell {

    var clickBlock: VoidBlock?

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.text = "Date".local
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
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
        view.layer.cornerRadius = 7
        return view
    }()

    
    private let dateLab : UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_black")
        return img
    }()

    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
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
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }

        
        backView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        backView.addGestureRecognizer(tap)
        
    }
    
    func setCellData(date: String) {
        dateLab.text = date
    }
    

    @objc private func tapAction() {
        clickBlock?("")
    }
    
}
