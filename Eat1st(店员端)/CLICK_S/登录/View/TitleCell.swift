//
//  TitleCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/6/5.
//

import UIKit

class TitleCell: BaseTableViewCell {


    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#D8D8D8")
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SETFONT_B(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    
    override func setViews() {
        
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }

    }

    func setCellData(title: String) {
        titLab.text = title
    }
    
}
