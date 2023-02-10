//
//  OrderYuYueMsgCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/9.
//

import UIKit

class OrderYuYueMsgCell: BaseTableViewCell {

    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let msgBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFF6F3")
        view.layer.cornerRadius = 5
        return view
    }()
    
    let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF4E26"), SFONT(10), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(msgBackView)
        msgBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
        
        msgBackView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    
}
