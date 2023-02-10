//
//  SuggestionCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/13.
//

import UIKit

class SuggestionContentCell: BaseTableViewCell {

    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .left)
        return lab
    }()
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .right)
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        contentView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    
    func setCellData(model: SuggestionModel) {
        self.msgLab.text = model.suggestContent
        self.nameLab.text = "name:\(model.name)"
        self.phoneLab.text = "phone:\(model.phone)"
    }
    
}

class SuggestionReplyCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F8F8")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "2021-07-07 12:09"
        return lab
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Call if you have any questions.Call if you have any questions."
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
        }
        
    }
    
    func setCellData(model: SuggestionModel) {
        self.contentLab.text = model.replyContent
        self.timeLab.text = model.replyTime
    }
    
    
}
