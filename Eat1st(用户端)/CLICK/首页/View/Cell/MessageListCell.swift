//
//  MessageListCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit

class MessageListCell: BaseTableViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let detailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "View details"
        return lab
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.numberOfLines = 0
        lab.text = "System information"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(10), .right)
        lab.text = "2021-05-16 12:45"
        return lab
    }()
    
    private let msgImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("msg_icon")
        return img
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "Sorry , your address is temporarily out of our delivery area. You may change to collection service. Thank you ..."
        return lab
    }()
    
    
    override func setViews() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(0.5)
        }
        
        
        backView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 10))
            $0.bottom.equalToSuperview().offset(-15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(detailLab)
        detailLab.snp.makeConstraints {
            $0.centerY.equalTo(nextImg)
            $0.left.equalToSuperview().offset(15)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.right.equalToSuperview().offset(-135)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(msgImg)
        msgImg.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalToSuperview().offset(15)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-13)
            $0.top.equalToSuperview().offset(18)
        }
        
        backView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(titlab.snp.bottom).offset(15)
        }
        
    }
    
    func setCellData(model: MessageModel) {
        self.timeLab.text = model.createTime
        self.titlab.text = model.title
        self.contentLab.text = model.content.html2String
        
        if model.isRead {
            self.contentLab.textColor = HCOLOR("#AAAAAA")
            self.titlab.textColor = HCOLOR("#AAAAAA")
            self.detailLab.textColor = HCOLOR("#AAAAAA")
            self.nextImg.image = LOIMG("msg_next_g")
        } else {
            self.contentLab.textColor = HCOLOR("#666666")
            self.titlab.textColor = FONTCOLOR
            self.detailLab.textColor = FONTCOLOR
            self.nextImg.image = LOIMG("msg_next_b")
        }
    }
}
