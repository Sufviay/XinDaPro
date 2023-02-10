//
//  OrderEvaluateCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class OrderEvaluateCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        return view
    }()
    
    private lazy var starView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: (4/3 + 5) * 14 , height: 14))
        view.isCanTap = false
        view.setPointValue = 2
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Evaluate content"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Evaluate time"
        return lab
    }()
    
    
    let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.text = "---"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .right)
        lab.numberOfLines = 0
        lab.text = "--"
        return lab
    }()
    
    

    
    override func setViews() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
            $0.top.equalToSuperview()
        }
        
        contentView.addSubview(starView)
        starView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(14)
            $0.width.equalTo((4/3 + 5) * 14)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(45)
        }
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(130)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(45)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalTo(tlab)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    func setCellData(model: OrderModel) {
        self.starView.setPointValue = Int(ceil(model.evaluateStar))
        self.msgLab.text = model.evaluateContent
        self.timeLab.text = model.evaluateTime
    }

}
