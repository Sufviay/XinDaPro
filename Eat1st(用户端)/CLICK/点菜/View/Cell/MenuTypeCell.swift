//
//  MenuTypeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/3.
//

import UIKit

class MenuTypeCell: BaseTableViewCell {

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(SFONTCOLOR, BFONT(11), .left)
        lab.text = "menu-5"
        lab.numberOfLines = 0
        return lab
    }()
    
//    private let line: UIView = {
//        let view = UIView()
//        view.backgroundColor = MAINCOLOR
//        return view
//    }()
    


    override func setViews() {
        
        contentView.backgroundColor = HCOLOR("#F9F9F9")
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(0)
        }
        
//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview()
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalTo(5)
//        }
    }
    
    
    func setCellData(isSelect: Bool, name: String) {
        
        self.titlab.text = name
        
        if isSelect {
            contentView.backgroundColor = MAINCOLOR
            self.titlab.textColor = .white
            
        } else {
            contentView.backgroundColor = HCOLOR("#F9F9F9")
            self.titlab.textColor = SFONTCOLOR
        }
    }
    
    
}
