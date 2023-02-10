//
//  SelectClassCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit

class SelectClassCell: BaseTableViewCell {

    
    var clickBlock: VoidBlock?
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.08)
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let classImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_fenlei")
        return img
    }()

    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_xl")
        return img
    }()
    
    private let classLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(15), .left)
        lab.text = "6 Jan 2022"
        return lab
    }()
    

    

    override func setViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(15)
        }
        
        selectBut.addSubview(classImg)
        classImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        selectBut.addSubview(classLab)
        classLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(45)
        }
        
        selectBut.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 6))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        selectBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    
    @objc private func clickAction() {
        clickBlock?("")
    }

    
    func setCellData(className: String) {
        if className == "" {
            self.classLab.text = "Choose classification"
        } else {
            self.classLab.text = className
        }
    }
    
    

}
