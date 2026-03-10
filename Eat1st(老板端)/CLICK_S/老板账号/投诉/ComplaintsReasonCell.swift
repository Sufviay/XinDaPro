//
//  ComplaintsReasonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsReasonCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = HCOLOR("#FFF0EC")
        return view
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("ts_red")
        return img
    }()
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FC7050"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Missing item -- Collection"
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 28, height: 28))
            $0.left.equalToSuperview().offset(14)
        }
        
        backView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
    func setCellData(model: ComplaintsModel) {
        contentLab.text = model.plaintReason
        
        if model.handleType == "1" {
            //未处理
            contentLab.textColor = HCOLOR("#FC7050")
            backView.backgroundColor = HCOLOR("#FFF0EC")
            sImg.image = LOIMG("ts_red")
        }
        
        if model.handleType == "2" {
            //已处理
            contentLab.textColor = HCOLOR("#2AD389")
            backView.backgroundColor = HCOLOR("#E9FBF2")
            sImg.image = LOIMG("ts_green")

        }
        
    }
    
    
}
