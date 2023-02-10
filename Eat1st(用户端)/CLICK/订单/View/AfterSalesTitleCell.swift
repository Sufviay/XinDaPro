//
//  AfterSalesTitleCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/6/7.
//

import UIKit

class AfterSalesTitleCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 5)
        return view
    }()
    
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = "Refund reason"
        return lab
    }()
    
    let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("＊")
        return img
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
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.top.equalTo(titlab).offset(5)
            $0.left.equalTo(titlab.snp.right).offset(2)
        }
    }
    
    
}


class AfterSalesCornersCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 10), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 5)
        return view
    }()
        
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
            
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)

        }
    }

    
}
