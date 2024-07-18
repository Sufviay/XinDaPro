//
//  ShareReferrerListCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/6.
//

import UIKit

class ShareReferrerListCell: BaseTableViewCell {


    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    
    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "abcd@email.com"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#808080"), SFONT(10), .left)
        lab.text = "2022-01-10  01:21:51"
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F56D00"), BFONT(13), .right)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = " (尚未註冊)"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.width.equalTo(130)
        }
        
        contentView.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalTo(statusLab.snp.left).offset(-5)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalTo(emailLab)
            $0.top.equalTo(emailLab.snp.bottom).offset(5)
        }
        
        
    }
    
    
    func setCellData(model: ShareRecordModel) {
        emailLab.text = model.email
        timeLab.text = model.createTime
        
        if model.shareStatus == "1" {
            //未注册
            statusLab.textColor = HCOLOR("#F56D00")
            statusLab.text = "尚未註冊"
        }
        if model.shareStatus == "2" {
            //已注册 未成为会员
            statusLab.textColor = MAINCOLOR
            statusLab.text = "已註冊 但未成為會員"
        }
        if model.shareStatus == "3" {
            //已成为会员
            statusLab.textColor = HCOLOR("#10D04B")
            statusLab.text = "已成為會員"
        }
        
        
    }
    
    
}
