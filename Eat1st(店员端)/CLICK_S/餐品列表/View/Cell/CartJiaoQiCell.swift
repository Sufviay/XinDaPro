//
//  CartJiaoQiCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/19.
//

import UIKit

class CartJiaoQiCell: BaseTableViewCell {


    private let line1: UIView = {
        let view = UIView()
        return view
    }()
    
    
    private let line2: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(10), .center)
        lab.text = "叫起"
        return lab
    }()
        
    
    override func setViews() {
        
        
        line1.frame = CGRect(x: 15, y: 0, width: S_W - 30, height: 1)
        line1.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 1, lineLength: 5, lineSpacing: 5)
        contentView.addSubview(line1)
        
        
        line2.frame = CGRect(x: 15, y: 19, width: S_W - 30, height: 0.5)
        line2.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        contentView.addSubview(line2)

            
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }

}
