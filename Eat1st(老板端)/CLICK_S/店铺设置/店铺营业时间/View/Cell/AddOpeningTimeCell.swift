//
//  AddOpeningTimeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit


class OpeningHoursInputCell: BaseTableViewCell {
    
    
    var clickBlock: VoidStringBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Opening Hours"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    private let startBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let endBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        view.layer.cornerRadius = 1
        return view
    }()


    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(startBut)
        startBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab.snp.bottom).offset(15)
            $0.size.equalTo(CGSize(width: 85, height: 30))
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 2))
            $0.centerY.equalTo(startBut)
            $0.left.equalTo(startBut.snp.right).offset(20)
        }
        
        contentView.addSubview(endBut)
        endBut.snp.makeConstraints {
            $0.size.centerY.equalTo(startBut)
            $0.left.equalTo(line.snp.right).offset(20)
        }
        
        startBut.addTarget(self, action: #selector(clickStartAction), for: .touchUpInside)
        endBut.addTarget(self, action: #selector(clickEndAction), for: .touchUpInside)
        
    }
    
    
    func setCellData(model: AddTimeSubmitModel) {
        self.startBut.setTitle(model.startTime, for: .normal)
        self.endBut.setTitle(model.endTime, for: .normal)
    }
    
    
    @objc private func clickStartAction() {
        clickBlock?("start")
    }
    
    @objc private func clickEndAction() {
        clickBlock?("end")
    }
    
}



class OpeningHoursInputTimeCell: BaseTableViewCell {
    
    var clickBlock: VoidStringBlock?
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Delivery:"
        return lab
    }()
    
    private let minLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .right)
        lab.text = "min"
        return lab
    }()
    
    
    
    private let minBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let maxBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        but.layer.cornerRadius = 7
        return but
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(minLab)
        minLab.snp.makeConstraints {
            $0.centerY.equalTo(tLab)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(maxBut)
        maxBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 25))
            $0.centerY.equalTo(tLab)
            $0.right.equalToSuperview().offset(-55)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 1))
            $0.centerY.equalTo(tLab)
            $0.right.equalTo(maxBut.snp.left).offset(-8)
        }
        
        contentView.addSubview(minBut)
        minBut.snp.makeConstraints {
            $0.size.centerY.equalTo(maxBut)
            $0.right.equalTo(line.snp.left).offset(-8)
        }
        
        minBut.addTarget(self, action: #selector(clickMinAction), for: .touchUpInside)
        maxBut.addTarget(self, action: #selector(clickMaxAction), for: .touchUpInside)
        
    }
    
    
    func setCellData(titStr: String, maxStr: String, minStr: String) {
        self.tLab.text = titStr
        self.maxBut.setTitle(maxStr, for: .normal)
        self.minBut.setTitle(minStr, for: .normal)
    }
    
    
    @objc private func clickMinAction() {
        clickBlock?("min")
    }
    
    
    @objc private func clickMaxAction() {
        clickBlock?("max")
    }
    
}


class TitleCell: BaseTableViewCell {
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Week"
        return lab
    }()
    
    let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    
    
    override func setViews() {
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
    }
    
}


class SelectWeekCell: BaseTableViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(13), .left)
        lab.text = "Week"
        return lab
    }()

    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("unsel_f")
        return img
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
    }
    
    
    
    func setCellData(idx: Int, select: Bool) {
        if select {
            self.selectImg.image = LOIMG("sel_f")
        } else {
            self.selectImg.image = LOIMG("unsel_f")
        }
        
        
        if idx == 0 {
            self.titlab.text = "Monday"
        }
        if idx == 1 {
            self.titlab.text = "Tuesday"
        }
        if idx == 2 {
            self.titlab.text = "Wednesday"
        }
        if idx == 3 {
            self.titlab.text = "Thursday"
        }
        if idx == 4 {
            self.titlab.text = "Friday"
        }
        if idx == 5 {
            self.titlab.text = "Saturday"
        }
        if idx == 6 {
            self.titlab.text = "Sunday"
        }
        
    }
    
}



