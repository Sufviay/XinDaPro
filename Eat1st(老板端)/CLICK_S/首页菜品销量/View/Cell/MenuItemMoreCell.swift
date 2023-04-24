//
//  MenuItemMoreCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/13.
//

import UIKit

class MenuItemMoreCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?

    private let backBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 10
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 1
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .center)
        lab.text = "More"
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("menu_down")
        return img
    }()
    

    override func setViews() {
        
        contentView.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-75)
            $0.top.equalToSuperview().offset(15)
            $0.height.equalTo(35)
        }
        
        backBut.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-5)
        }
        
        backBut.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.left.equalTo(tlab.snp.right).offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        backBut.addTarget(self, action: #selector(clickButAction), for: .touchUpInside)
        
    }
    
    @objc private func clickButAction() {
        clickBlock?("")
    }
    
    func setCellData(isShow: Bool) {
        if isShow {
            self.tlab.text = "Pack up"
            self.sImg.image = LOIMG("menu_up")
        } else {
            self.tlab.text = "More"
            self.sImg.image = LOIMG("menu_down")

        }
    }
    
    
    

}
