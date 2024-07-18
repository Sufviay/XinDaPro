//
//  RechargeRemarkCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/11.
//

import UIKit

class RechargeRemarkCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F6F6F6")
        view.layer.cornerRadius = 7
        return view
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), BFONT(12), .left)
        lab.text = "Remark"
        return lab
    }()
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), SFONT(10), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(8)
        }
        
        backView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(25)
        }
        
        
    }
    
    
    func setCellData(model: RechargeModel) {
        msgLab.text = model.remark
    }

    
}
