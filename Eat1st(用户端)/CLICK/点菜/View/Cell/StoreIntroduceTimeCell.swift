//
//  StoreIntroduceTimeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit


class StoreLabCell: BaseTableViewCell {
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(17), .left)
        lab.text = "Opening Hours"
        return lab
    }()
    
    override func setViews() {
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
    }
}


class WeekNameCell: BaseTableViewCell {
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "Sunday"
        return lab
    }()
    
    private let point: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = HCOLOR("DDDDDD")
        return view
    }()
    
    private let closedLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .right)
        lab.text = "closed"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(closedLab)
        closedLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(point)
        point.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titLab.snp.left).offset(-10)
            $0.size.equalTo(CGSize(width: 8, height: 8))
        }
    }
    
    func setCellData(model: WeekOpenTimeModel) {
        
        let curW = PJCUtil.getweekDay(Date())
        
        if model.weekID == String(curW) {
            //当前天
            point.backgroundColor = MAINCOLOR
        } else {
            point.backgroundColor = HCOLOR("DDDDDD")
        }
        
        
        self.titLab.text = model.weekName
        if model.timeArr.count == 0 {
            closedLab.isHidden = false
        } else {
            closedLab.isHidden = true
        }
        
        
        
    }
}







class TimeSetInfoCell: BaseTableViewCell {
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Name"
        return lab
    }()
    
    private let startLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .right)
        lab.text = "8:00"
        return lab
    }()

    
    private let endLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .right)
        lab.text = "8:00"
        return lab
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Collection"
        return lab
    }()
    
    
    private let deImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let coImg: UIImageView = {
        let img = UIImageView()
        return img
    }()


    override func setViews() {
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(14)
        }
        
        contentView.addSubview(endLab)
        endLab.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(endLab)
            $0.right.equalTo(endLab.snp.left).offset(-5)
        }
        
        contentView.addSubview(startLab)
        startLab.snp.makeConstraints {
            $0.centerY.equalTo(endLab)
            $0.right.equalTo(line2.snp.left).offset(-5)
        }
        
        contentView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalToSuperview().offset(42)
        }
        
        contentView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalToSuperview().offset(68)
        }
        
        contentView.addSubview(deImg)
        deImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalTo(deLab)
        }
        
        contentView.addSubview(coImg)
        coImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalTo(coLab)
        }

        
    }
    
    
    func setCellData(model: DayTimeModel) {
        nameLab.text = model.timeName
        endLab.text = model.endTime
        startLab.text = model.startTime

        if model.deStatus == "1" {
            //开启
            self.deImg.image = LOIMG("sel")
        } else {
            self.deImg.image = LOIMG("closed")
        }
        
        
        
        if model.coStatus == "1" {
            //开启
            self.coImg.image = LOIMG("sel")
        } else {
            self.coImg.image = LOIMG("closed")
        }
        
        
        
    }
    
    

}

