//
//  StoreReviewsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/5.
//

import UIKit

class StoreReviewsCell: BaseTableViewCell {
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        return view
    }()


    private let headerImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = MAINCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 25 / 2
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Anonymous users"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
        lab.text = "2021-07-07 12:09"
        return lab
    }()
    
    
    

    private lazy var cpStarView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14, height: 14))
        view.isCanTap = false
        //view.setPointValue = 2
        return view
    }()
    
    
    private lazy var fwStarView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14, height: 14))
        view.isCanTap = false
        //view.setPointValue = 2
        return view
    }()
    
    private lazy var psStarView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14, height: 14))
        view.isCanTap = false
        //view.setPointValue = 2
        return view
    }()


    

    private let cpStarCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
        lab.text = "5.0"
        return lab
    }()
    
    
    private let fwStarCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
        lab.text = "5.0"
        return lab
    }()

    
    private let psStarCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
        lab.text = "5.0"
        return lab
    }()

    
    private let contentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = ""
        return lab
    }()
    
    
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(12), .left)
        lab.text = "Delivery time"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        
        
        contentView.addSubview(headerImg)
        headerImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalTo(headerImg)
            $0.left.equalTo(headerImg.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-135)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(headerImg)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        let tlab1 = UILabel()
        tlab1.setCommentStyle(HCOLOR("#333333"), SFONT(12), .left)
        tlab1.text = "Food Quality"
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-55)
        }
        
        let tlab2 = UILabel()
        tlab2.setCommentStyle(HCOLOR("#333333"), SFONT(12), .left)
        tlab2.text = "Service"
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-36)
        }
        
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-17)
        }
        
        
        contentView.addSubview(contentLab)
        contentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(60)
        }
        
        
        contentView.addSubview(cpStarView)
        cpStarView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-50)
            $0.centerY.equalTo(tlab1)
            $0.size.equalTo(CGSize(width: (4/3 * 14 + 70), height: 14))
        }
        
        contentView.addSubview(fwStarView)
        fwStarView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-50)
            $0.centerY.equalTo(tlab2)
            $0.size.equalTo(CGSize(width: (4/3 * 14 + 70), height: 14))
        }
        
        
        contentView.addSubview(psStarView)
        psStarView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-50)
            $0.centerY.equalTo(tlab3)
            $0.size.equalTo(CGSize(width: (4/3 * 14 + 70), height: 14))
        }
        
        contentView.addSubview(cpStarCountLab)
        cpStarCountLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(fwStarCountLab)
        fwStarCountLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(psStarCountLab)
        psStarCountLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab3)
            $0.right.equalToSuperview().offset(-20)
        }

    }
    
    func setCellData(model: ReviewsModel) {
        self.contentLab.text = model.plContent
        self.nameLab.text = model.name
        self.headerImg.sd_setImage(with: URL(string: model.headUrl))
        self.timeLab.text =  model.time
        
        self.cpStarView.setPointValue = Int(ceil(model.dishCount))
        self.cpStarCountLab.text = String(model.dishCount)
        
        self.fwStarView.setPointValue = Int(ceil(model.serviceCount))
        self.fwStarCountLab.text = String(model.serviceCount)
        
        self.psStarView.setPointValue = Int(ceil(model.deliveryCount))
        self.psStarCountLab.text = String(model.deliveryCount)
        
        if model.orderType == "1" {
            self.tlab3.text = "Delivery time"
        }
        if model.orderType == "2" {
            self.tlab3.text = "Collection time"
        }
        if model.orderType == "3" {
            self.tlab3.text = "Dine-in time"
        }
    }
}
