//
//  FirstNoDataCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/13.
//

import UIKit

class FirstNoDataCell: BaseTableViewCell {

    var clickBlock: VoidBlock?

    let picImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("noData")
        return img
    }()
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = "NO RESTAURANT NEARBY"
        return lab
    }()

    private let addressBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "CHANGE ADDRESS", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    override func setViews() {
                
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.size.equalTo(CGSize(width: 165, height: 112))
        }
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(picImg.snp.bottom).offset(20)
        }
        
        contentView.addSubview(addressBut)
        addressBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(70)
            $0.right.equalToSuperview().offset(-70)
            $0.height.equalTo(45)
            $0.top.equalTo(picImg.snp.bottom).offset(100)
        }
        
        addressBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)

    }

    
    @objc private func clickAllAction() {
        clickBlock?("")
    }


}
