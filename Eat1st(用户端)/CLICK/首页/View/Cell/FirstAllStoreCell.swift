//
//  FirstAllStoreCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/8/27.
//

import UIKit

class FirstAllStoreCell: BaseTableViewCell {

    var clickBlock: VoidBlock?
    
    private let allBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "All Shops", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    override func setViews() {
        
        contentView.addSubview(allBut)
        allBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(42)
        }
        
        
        allBut.addTarget(self, action: #selector(clickButAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickButAction() {
        self.clickBlock?("")
    }
    
    
}
