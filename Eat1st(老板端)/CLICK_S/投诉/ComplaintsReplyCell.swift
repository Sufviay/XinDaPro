//
//  ComplaintsReplyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsReplyCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Reply from the merchant:\nCall if you have any questions.Call if you have any questions."
        return lab
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(13), .right)
        return lab
    }()
    
    
    override func setViews() {
       
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    
    func setCellData(content: String, time: String) {
        contentLab.text = content
        timeLab.text = time
    }

}
