//
//  OrderDetailCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/2.
//

import UIKit

class DetailOneCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 40), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Details"
        return lab
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
    }
}


class DetailTwoCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 20), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 10)
        return view
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}


class OrderDetailMsgCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "text"
        return lab
    }()
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .right)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(130)
            $0.top.equalToSuperview().offset(15)
        }
        
    }
    
    func setCellData(titStr: String, msgStr: String) {
        
        if titStr == "Order number" {
            msgLab.font = BFONT(15)
        } else {
            msgLab.font = SFONT(14)
        }
        
        self.titlab.text = titStr
        self.msgLab.text = msgStr
    }
    
    
}


