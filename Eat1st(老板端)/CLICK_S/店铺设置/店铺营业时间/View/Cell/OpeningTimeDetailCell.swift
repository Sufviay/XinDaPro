//
//  OpeningTimeDetailCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/23.
//

import UIKit


class Detail_OpeningTimeCell: BaseTableViewCell {
    
    private let point: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Opening time".local
        return lab
    }()

    

    
    private let startLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = "8:00"
        return lab
    }()

    
    private let endLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = "8:00"
        return lab
    }()

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(point)
        point.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titLab.snp.left).offset(-10)
        }
        
        contentView.addSubview(endLab)
        endLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.centerY.equalTo(endLab)
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.right.equalTo(endLab.snp.left).offset(-10)
        }
        
        contentView.addSubview(startLab)
        startLab.snp.makeConstraints {
            $0.centerY.equalTo(endLab)
            $0.right.equalTo(line.snp.left).offset(-10)
        }
    }
    
    func setCelldata(start: String, end: String) {
        self.endLab.text = end
        self.startLab.text = start
    }
}


class Detail_CoOrDeStausCell: BaseTableViewCell {
    
    
    private let point: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()

    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        return lab
    }()

    
    private let statusImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("all_sel")
        return img
    }()
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(point)
        point.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titLab.snp.left).offset(-10)
        }

        contentView.addSubview(statusImg)
        statusImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.centerY.equalTo(titLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    func setCellData(titStr: String, status: String) {
        
        if titStr == "Delivery".local {
            point.backgroundColor = HCOLOR("#FEC501")
        } else {
            point.backgroundColor = HCOLOR("#465DFD")
        }
        
        self.titLab.text = titStr
        if status == "1" {
            self.statusImg.image = LOIMG("all_sel")
        } else {
            self.statusImg.image = LOIMG("closed")
        }
        
        
    }
    
}


class Detail_CoOrDeTimeCell: BaseTableViewCell {
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        return lab
    }()


    
    private let maxLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = "8:00"
        return lab
    }()

    
    private let minLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = "8:00"
        return lab
    }()

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()

    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, BFONT(13), .right)
        lab.text = "min"
        return lab
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }

        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(maxLab)
        maxLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-50)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.centerY.equalTo(maxLab)
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.right.equalTo(maxLab.snp.left).offset(-6)
        }
        
        contentView.addSubview(minLab)
        minLab.snp.makeConstraints {
            $0.centerY.equalTo(maxLab)
            $0.right.equalTo(line.snp.left).offset(-6)
        }
    }
    
    
    func setCellData(titStr: String, min: String, max: String) {
        self.titLab.text = titStr
        self.minLab.text = min
        self.maxLab.text = max
    }
    
}


class Detail_TimeStausCell: BaseTableViewCell {
    
    private let point: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#465DFD")
        return view
    }()

    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Status".local
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = ""
        return lab
    }()


    
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(point)
        point.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 6))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titLab.snp.left).offset(-10)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    func setCellData(status: String) {
        if status == "1" {
            self.statusLab.text = "Enable".local
        }
        if status == "2" {
            self.statusLab.text = "Disable".local
        }
    }
    
}


class Detail_TimeWeekCell: BaseTableViewCell {
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Status"
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("all_sel")
        return img
    }()

    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    func setCellData(idx: Int, select: Bool) {
        if idx == 0 {
            self.titlab.text = "Monday".local
        }
        if idx == 1 {
            self.titlab.text = "Tuesday".local
        }
        if idx == 2 {
            self.titlab.text = "Wednesday".local
        }
        if idx == 3 {
            self.titlab.text = "Thursday".local
        }
        if idx == 4 {
            self.titlab.text = "Friday".local
        }
        if idx == 5 {
            self.titlab.text = "Saturday".local
        }
        if idx == 6 {
            self.titlab.text = "Sunday".local
        }
        
        if select {
            self.selectImg.isHidden = false
        } else {
            self.selectImg.isHidden = true
        }
        
    }
}


class OpeningSelectDishCell: BaseTableViewCell {
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Dishes".local
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_blue")
        return img
    }()

    
    override func setViews() {
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }

        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalToSuperview()
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 12))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }

        
        
    }

    
}
