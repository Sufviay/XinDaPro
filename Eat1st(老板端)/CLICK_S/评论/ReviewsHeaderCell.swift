//
//  ReviewsHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/18.
//

import UIKit

class ReviewsHeaderCell: BaseTableViewCell {

    private let titlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Ratings and reviews"
        return lab
    }()
    
    private let line1: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FF8E12"), HCOLOR("#FFC65E"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()

    
    private let tLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(15), .left)
        lab.text = "Your overall rating"
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("pl_img")
        return img
    }()
    
    private let starView: ReviewsStarView = {
        let view = ReviewsStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 20, height: 20))
        view.selStar = LOIMG("star_b_l")
        view.norStar = LOIMG("star_b_g")
        view.setPointValue = 4
        view.isCanTap = false
        return view
    }()
    
    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#CCCCCC"), BFONT(13), .left)
        lab.text = "Based on 44 reviews"
        return lab
    }()
    
    
    private let titlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Customer reviews"
        return lab
    }()
    
    private let line2: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#28B1FF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()

    
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    override func setViews() {
        contentView.addSubview(titlab1)
        titlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab1.snp.bottom).offset(7)
        }
        
        contentView.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line1.snp.bottom).offset(30)
        }
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 74, height: 78))
            $0.top.equalToSuperview().offset(75)
            $0.left.equalToSuperview().offset(S_W - 50 - 74)
        }

        
        contentView.addSubview(starView)
        starView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tLab1.snp.bottom).offset(14)
            $0.height.equalTo(20)
            $0.width.equalTo((4/3 + 5) * 20)
        }
        
        contentView.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(starView.snp.bottom).offset(14)
        }
        
        contentView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(tLab2.snp.bottom).offset(25)
        }
        
        
        contentView.addSubview(titlab2)
        titlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tLab2.snp.bottom).offset(50)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab2.snp.bottom).offset(7)
        }
    }
    
    
    func setCellData(model: ReviewsModel) {
        starView.setPointValue = model.evaluateScore
        if model.evaluateNum == "" {
            tLab2.text = ""
        } else {
            tLab2.text = "Based on \(model.evaluateNum) reviews"
        }
    }
    
    
}
