//
//  ReviewsStarCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/18.
//

import UIKit

class ReviewsStarCell: BaseTableViewCell {

    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(11), .left)
        lab.text = "Food Quality"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(11), .left)
        lab.text = "Service"
        return lab
    }()

    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(11), .left)
        lab.text = "Delivery time"
        return lab
    }()
    
    
    private lazy var starView1: ReviewsStarView = {
        let view = ReviewsStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 11, height: 11))
        view.norStar = LOIMG("star_s_g")
        view.selStar = LOIMG("star_s_l")
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()
    
    
    private lazy var starView2: ReviewsStarView = {
        let view = ReviewsStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 11, height: 11))
        view.norStar = LOIMG("star_s_g")
        view.selStar = LOIMG("star_s_l")
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()
    
    private lazy var starView3: ReviewsStarView = {
        let view = ReviewsStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 11, height: 11))
        view.norStar = LOIMG("star_s_g")
        view.selStar = LOIMG("star_s_l")
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()

    private let pfLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#AAAAAA"), SFONT(11), .left)
        lab.text = "5.0"
        return lab
    }()
    
    
    private let pfLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#AAAAAA"), SFONT(11), .left)
        lab.text = "5.0"
        return lab
    }()

    
    private let pfLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#AAAAAA"), SFONT(11), .left)
        lab.text = "5.0"
        return lab
    }()



    
    
    override func setViews() {
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
        }
        
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab1.snp.bottom).offset(8)
        }
        
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab2.snp.bottom).offset(8)
        }

        
        
        contentView.addSubview(starView1)
        starView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.centerY.equalTo(tlab1)
            $0.size.equalTo(CGSize(width: (4/3 + 5) * 11, height: 11))
        }
        
        
        contentView.addSubview(starView2)
        starView2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.centerY.equalTo(tlab2)
            $0.size.equalTo(CGSize(width: (4/3 + 5) * 11, height: 11))
        }
        
        
        contentView.addSubview(starView3)
        starView3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.centerY.equalTo(tlab3)
            $0.size.equalTo(CGSize(width: (4/3 + 5) * 11, height: 11))
        }
        
        
        contentView.addSubview(pfLab1)
        pfLab1.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.left.equalTo(starView1.snp.right).offset(10)
        }
        
        contentView.addSubview(pfLab2)
        pfLab2.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.left.equalTo(starView2.snp.right).offset(10)
        }
        
        contentView.addSubview(pfLab3)
        pfLab3.snp.makeConstraints {
            $0.centerY.equalTo(tlab3)
            $0.left.equalTo(starView3.snp.right).offset(10)
        }
    }
    
    func setCellData(model: ReviewListModel) {
        self.starView1.setPointValue = Int(ceil(model.dishesNum))
        self.pfLab1.text = String(model.dishesNum)
        self.starView2.setPointValue = Int(ceil(model.serviceNum))
        self.pfLab2.text = String(model.serviceNum)
        self.starView3.setPointValue = Int(ceil(model.deliveryNum))
        self.pfLab3.text = String(model.deliveryNum)
        
        if model.deliveryType == "1" {
            self.tlab3.text = "Delivery time"
        }
        if model.deliveryType == "2" {
            self.tlab3.text = "Collection time"
        }
        if model.deliveryType == "3" {
            self.tlab3.text = "Dine-in time"
        }
        
    }

    
    
}
