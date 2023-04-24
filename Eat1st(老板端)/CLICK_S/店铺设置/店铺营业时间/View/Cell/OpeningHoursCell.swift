//
//  OpeningHoursCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit




class WeekNameCell: BaseTableViewCell {
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "Sunday"
        return lab
    }()
    
    private let point: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("week_tag")
        return img
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
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Name"
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .left)
        lab.text = ""
        return lab
    }()
    
    private let point1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()
    
    private let point2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()

    
    private let point3: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#465DFD")
        return view
    }()

    
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Opening Hours"
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

        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(14)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.equalTo(nameLab1.snp.right).offset(10)
            $0.centerY.equalTo(nameLab1)
        }
        
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalTo(nameLab1)
            $0.top.equalToSuperview().offset(42)
        }
        
        contentView.addSubview(point1)
        point1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.right.equalTo(tLab.snp.left).offset(-10)
            $0.centerY.equalTo(tLab)
        }
        
        contentView.addSubview(endLab)
        endLab.snp.makeConstraints {
            $0.centerY.equalTo(tLab)
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
            $0.left.equalTo(nameLab1)
            $0.top.equalToSuperview().offset(68)
        }
        
        contentView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.left.equalTo(nameLab1)
            $0.top.equalToSuperview().offset(94)
        }
        
        contentView.addSubview(point2)
        point2.snp.makeConstraints {
            $0.centerY.equalTo(deLab)
            $0.size.centerX.equalTo(point1)
        }
        
        contentView.addSubview(point3)
        point3.snp.makeConstraints {
            $0.centerY.equalTo(coLab)
            $0.size.centerX.equalTo(point1)
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
        nameLab1.text = model.timeName1
        nameLab2.text = model.timeName2
        endLab.text = model.endTime
        startLab.text = model.startTime

        if model.deStatus == "1" {
            //开启
            self.deImg.image = LOIMG("all_sel")
        } else {
            self.deImg.image = LOIMG("closed")
        }
        
        
        
        if model.coStatus == "1" {
            //开启
            self.coImg.image = LOIMG("all_sel")
        } else {
            self.coImg.image = LOIMG("closed")
        }
        
        
        
    }
    
    

}



class OpeningTimeListCell: BaseTableViewCell {
    
    private var dataModel = DayTimeModel()
    
    var clickMoreBlock: VoidStringBlock?
    
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
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let point: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()

    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Opening Hours"
        return lab
    }()

    
    
    private let startLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "8:00"
        return lab
    }()

    
    private let endLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "8:00"
        return lab
    }()
    
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()
    
    
    private lazy var alertView: OpeningTimeMoreAlert = {
        let alert = OpeningTimeMoreAlert()
        alert.clickBlock = { [unowned self] (type) in
            self.clickMoreBlock?(type)
        }
        return alert
    }()
    
    override func setViews() {
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.right.left.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(2)
        }
        
        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.bottom.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(point)
        point.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.right.equalTo(tLab.snp.left).offset(-10)
            $0.centerY.equalTo(tLab)
        }
        
        
        contentView.addSubview(endLab)
        endLab.snp.makeConstraints {
            $0.centerY.equalTo(tLab)
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
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
    }
    
    
    func setCellData(model: DayTimeModel) {
        
        self.dataModel = model
        
        nameLab1.text = model.timeName1
        nameLab2.text = model.timeName2
        endLab.text = model.endTime
        startLab.text = model.startTime
        
        
        if model.status == "1" {
            //启用
            nameLab1.textColor = .black
            nameLab2.textColor = HCOLOR("666666")
            tLab.textColor = FONTCOLOR
            startLab.textColor = FONTCOLOR
            endLab.textColor = FONTCOLOR
        } else {
            //禁用
            nameLab1.textColor = HCOLOR("#999999")
            nameLab2.textColor = HCOLOR("#999999")
            tLab.textColor = HCOLOR("#999999")
            startLab.textColor = HCOLOR("#999999")
            endLab.textColor = HCOLOR("#999999")
        }
        
    }
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        print(sender.frame)
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        print(cret)
        alertView.tap_H = cret.minY
        alertView.status = dataModel.status
        alertView.appearAction()

    }
    
    
}



