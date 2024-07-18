//
//  ShareReferrerHeaderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/6.
//

import UIKit

class ShareReferrerHeaderCell: BaseTableViewCell {

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F6F6F6")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "我推薦的人"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(35)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 4, height: 16))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(line.snp.right).offset(10)
        }
        
    }
    
    

}



class ShareFooterCell: BaseTableViewCell {

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 30, height: 20), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 15)
        return view
    }()
    
    
    
    override func setViews() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    

}

