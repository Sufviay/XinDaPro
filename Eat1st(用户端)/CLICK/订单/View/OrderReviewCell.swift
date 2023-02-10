//
//  OrderReviewCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/31.
//

import UIKit

class OrderReviewCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titlelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Review"
        return lab
    }()
    
    private lazy var starView1: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14 , height: 14))
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()
    
    private let starlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "4.0"
        return lab
    }()

    
    
    private lazy var starView2: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14 , height: 14))
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()
    
    private let starlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "4.0"
        return lab
    }()
    
    private lazy var starView3: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14 , height: 14))
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()
    
    private let starlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.text = "4.0"
        return lab
    }()
    
    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.numberOfLines = 0
        return lab
    }()

    

    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "2021-07-07 12:09"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(13), .left)
        lab.text = "Food"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(13), .left)
        lab.text = "Service"
        return lab
    }()

    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(13), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("F8F8F8")
        view.layer.cornerRadius = 10
        return view
    }()

    let repLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = HCOLOR("#F8F8F8")
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "11111111111111111111"
        return lab
    }()

    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(titlelab)
        titlelab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(20)
        }
        
        
        backView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(50)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(titlelab)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(starView1)
        starView1.snp.makeConstraints {
//            $0.bottom.equalTo(starView2.snp.top).offset(-8)
//            $0.size.right.equalTo(starView3)
            $0.top.equalTo(contentLab.snp.bottom).offset(30)
            $0.size.equalTo(CGSize(width: (4/3 + 5) * 14, height: 14))
            $0.right.equalToSuperview().offset(-45)
        }

        backView.addSubview(starView2)
        starView2.snp.makeConstraints {
            $0.top.equalTo(starView1.snp.bottom).offset(8)
            $0.size.right.equalTo(starView1)
        }

        
        backView.addSubview(starView3)
        starView3.snp.makeConstraints {
            $0.top.equalTo(starView2.snp.bottom).offset(8)
            $0.size.right.equalTo(starView1)
        }

        
        backView.addSubview(starlab3)
        starlab3.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(starView3)
        }
    
        backView.addSubview(starlab2)
        starlab2.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(starView2)
        }
        
        backView.addSubview(starlab1)
        starlab1.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(starView1)
        }

        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(starView1)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(starView2)
        }
        
        backView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(starView3)
        }


        backView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalTo(starView3.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        tView.addSubview(repLab)
        repLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }

    }
    
    func setCellData(model: OrderDetailModel) {
        self.contentLab.text = model.evaluateContent

        self.timeLab.text = model.evaluateTime
        self.starView1.setPointValue = Int(ceil(model.dishStar))
        self.starlab1.text = String(model.dishStar)
        self.starView2.setPointValue = Int(ceil(model.serviceStar))
        self.starlab1.text = String(model.serviceStar)
        self.starView3.setPointValue = Int(ceil(model.deliveryStar))
        self.starlab3.text = String(model.deliveryStar)
        self.repLab.text = model.pjReplyContent
        
        if model.pjReplyContent == "" {
            self.tView.isHidden = true
        } else {
            self.tView.isHidden = false
        }
 
        
    }
    
}
 
  
