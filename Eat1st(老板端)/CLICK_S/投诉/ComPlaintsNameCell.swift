//
//  ComPlaintsNameCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsNameCell: BaseTableViewCell {
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(17), .left)
        lab.text = "Name"
        return lab
    }()
    
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
        lab.text = "#1550515678022548934"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(11), .right)
        lab.text = "2022-06-08"
        return lab
    }()
    
    private let sImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("guanggu")
        return img
    }()
    
    private let sImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tousu")
        return img
    }()
    
    private let tsTimeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F4305A"), SFONT(11), .left)
        lab.text = "4 times"
        return lab
    }()
    
    private let ggTimeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2ADA53"), SFONT(11), .left)
        lab.text = "4 times"
        return lab
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        
        contentView.addSubview(sImg2)
        sImg2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.right.equalToSuperview().offset(-65)
            $0.centerY.equalTo(nameLab)
        }
    
        
        contentView.addSubview(tsTimeLab)
        tsTimeLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg2)
            $0.left.equalTo(sImg2.snp.right).offset(5)
        }
        
        contentView.addSubview(sImg1)
        sImg1.snp.makeConstraints {
            $0.size.centerY.equalTo(sImg2)
            $0.right.equalToSuperview().offset(-130)
        }
        
        contentView.addSubview(ggTimeLab)
        ggTimeLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg1)
            $0.left.equalTo(sImg1.snp.right).offset(5)
        }
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(orderLab)
        }
        
    }
    
    
    func setCellData(name: String, orderNum: String, tsNum: String, xdNum: String, time: String) {
        self.orderLab.text = "#" + orderNum
        self.nameLab.text = name
        self.timeLab.text = time
        self.tsTimeLab.text = tsNum
        self.ggTimeLab.text = xdNum
    }
    
}
