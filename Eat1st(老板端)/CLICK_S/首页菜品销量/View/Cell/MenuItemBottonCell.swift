//
//  MenuItemBottonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/13.
//

import UIKit

class MenuItemBottonCell: BaseTableViewCell {

    var clickBlock: VoidBlock?
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .center)
        lab.text = "Information displayed is based on data collected in the past 28 days"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let backTopBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sy_backtop"), for: .normal)
        return but
    }()
    
    private let topBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Back to top", HCOLOR("#666666"), SFONT(14), .clear)
        return but
    }()
        
    
    override func setViews() {
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(topBut)
        topBut.snp.makeConstraints {

            $0.centerX.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 80, height: 30))
            $0.top.equalToSuperview().offset(60)
        }
        
        contentView.addSubview(backTopBut)
        backTopBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalTo(topBut)
            $0.right.equalTo(topBut.snp.left).offset(-5)
        }

        
        backTopBut.addTarget(self, action: #selector(clickBackTop), for: .touchUpInside)
        topBut.addTarget(self, action: #selector(clickBackTop), for: .touchUpInside)
        
    }
    
    
    
    @objc private func clickBackTop() {
        
        clickBlock?("")
    }
    
}
