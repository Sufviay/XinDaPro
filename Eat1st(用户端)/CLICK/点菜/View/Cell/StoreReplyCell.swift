//
//  StoreReplyCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/5.
//

import UIKit

class StoreReplyCell: BaseTableViewCell {

    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F8F8")
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = " Reply from the shop:"
        return lab
    }()
    
    
    private let replyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(13), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    
    
    
    

    override func setViews() {
    
        contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(14)
        }
        
        backView.addSubview(replyLab)
        replyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(40)
        }
    
    }
    
    
    func setCellData(model: ReviewsModel) {
        self.replyLab.text = model.replyContent
    }
    
}
