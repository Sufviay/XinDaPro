//
//  PageSettingOptionCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/24.
//

import UIKit

class PageSettingOptionCell: BaseTableViewCell {
    
    var clickBlock: VoidBoolBlock?

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        return lab
    }()
    
    let rightImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tuodong")
        return img
    }()
    
    private let showBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Display".local, TXTCOLOR_1, BFONT(10), BACKCOLOR_3)
        but.layer.cornerRadius = 3
        but.isHidden = true
        return but
    }()
    
    private let hideBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Hide".local, TXTCOLOR_1, BFONT(10), BACKCOLOR_3)
        but.layer.cornerRadius = 3
        but.isHidden = true
        return but
    }()


    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        
//        contentView.addSubview(rightImg)
//        rightImg.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.right.equalToSuperview().offset(-20)
//        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(hideBut)
        hideBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-65)
        }
        
        contentView.addSubview(showBut)
        showBut.snp.makeConstraints {
            $0.size.centerY.equalTo(hideBut)
            $0.right.equalTo(hideBut.snp.left).offset(-10)
        }
        
        showBut.addTarget(self, action: #selector(clickShowAction), for: .touchUpInside)
        hideBut.addTarget(self, action: #selector(clickHideAction), for: .touchUpInside)
        
    }
    
    @objc private func clickHideAction() {
        if hideBut.backgroundColor == HCOLOR("#F6F6F6") {
            clickBlock?(false)
        }
    }
    
    @objc private func clickShowAction() {
        if showBut.backgroundColor == HCOLOR("#F6F6F6") {
            clickBlock?(true)
        }
    }

    
    func setCellData(titStr: String, isShow: Bool) {
        titLab.text = titStr.local
//        if isShow {
//            showBut.setTitleColor(MAINCOLOR, for: .normal)
//            hideBut.setTitleColor(TXTCOLOR_1, for: .normal)
//            showBut.backgroundColor = HCOLOR("#E9EBFF")
//            hideBut.backgroundColor = HCOLOR("#F6F6F6")
//        } else {
//            showBut.setTitleColor(TXTCOLOR_1, for: .normal)
//            hideBut.setTitleColor(MAINCOLOR, for: .normal)
//            hideBut.backgroundColor = HCOLOR("#E9EBFF")
//            showBut.backgroundColor = HCOLOR("#F6F6F6")
//        }
    }
    
}
