//
//  OrderTSContentCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/17.
//

import UIKit

class OrderTSContentCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let tsContentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
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
        
        backView.addSubview(tsContentLab)
        
        tsContentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            
        }
            
    }
    
    
    func setCellData(model: OrderDetailModel) {
        
//        var str = ""
        
//        if model.tsContent == "" {
//            str = model.tsReason
//        } else {
//            str = model.tsReason + "\n" + model.tsContent
//        }
        
        self.tsContentLab.text = model.tsReason
        
    }
    
    
    
}
