//
//  SetTimeDayTimeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/9.
//

import UIKit

class SetTimeDayTimeCell: BaseTableViewCell {
    
    
    var clickBlock: VoidBlock?
    
    var clickDSWBlock: VoidBlock?
    var clickCSWBlock: VoidBlock?

    
    private var dataModel = DaySetTimeModel()

    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("week_tag")
        return img
    }()
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(17), .center)
        lab.text = "Monday"
        return lab
    }()

    
    private let b_line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    
    private let point1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let point2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#144DDE")
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Collection"
        return lab
    }()
    
    
    private let deStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 5
        but.setCommentStyle(.zero, "00:00", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let deEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 5
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()

    
    private let coStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 5
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let coEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 5
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, BFONT(15), HCOLOR("#F8F9F9"))
        return but
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()

    private let deSliderBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_off_b"), for: .normal)
        return but
    }()
    
    private let coSliderBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_on_b"), for: .normal)
        return but
    }()

    
    
    
    

    
    override func setViews() {
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(40)
        }
        
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalTo(tlab)
        }
        
        contentView.addSubview(b_line)
        b_line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }

        
        contentView.addSubview(point1)
        point1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(65)
        }
        
        contentView.addSubview(point2)
        point2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-27)
        }
        
        contentView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.left.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerY.equalTo(point2)
            $0.left.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(deEndBut)
        deEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.centerY.equalTo(point1)
            $0.right.equalToSuperview().offset(-105)
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(deEndBut.snp.left).offset(-10)
        }
        
        contentView.addSubview(deStartBut)
        deStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(line1.snp.left).offset(-10)
        }
        
        contentView.addSubview(coEndBut)
        coEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.centerY.equalTo(point2)
            $0.right.equalToSuperview().offset(-105)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(coEndBut.snp.left).offset(-10)
        }
        
        contentView.addSubview(coStartBut)
        coStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(line2.snp.left).offset(-10)
        }
        
        contentView.addSubview(deSliderBut)
        deSliderBut.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.right.equalToSuperview().offset(-25)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        
        contentView.addSubview(coSliderBut)
        coSliderBut.snp.makeConstraints {
            $0.centerY.equalTo(point2)
            $0.right.equalToSuperview().offset(-25)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        
        deStartBut.addTarget(self, action: #selector(clickDeStartAction), for: .touchUpInside)
        deEndBut.addTarget(self, action: #selector(clickDeEndAction), for: .touchUpInside)
        coStartBut.addTarget(self, action: #selector(clickCoStartAction), for: .touchUpInside)
        coEndBut.addTarget(self, action: #selector(clickCoEndAction), for: .touchUpInside)
             
        deSliderBut.addTarget(self, action: #selector(clickDeSwAction), for: .touchUpInside)
        coSliderBut.addTarget(self, action: #selector(clickCoSwAction), for: .touchUpInside)

        
    }
    
    
    @objc func clickDeSwAction() {
        
        if self.dataModel.deliveryIsOpen {
            clickDSWBlock?("2")
        } else {
            clickDSWBlock?("1")
        }
    }
    
    @objc func clickCoSwAction() {
        
        if self.dataModel.takeIsOpen {
            clickCSWBlock?("2")
        } else {
            clickCSWBlock?("1")
        }
    }
    
    

    @objc private func clickDeStartAction() {
        clickBlock?("des")
    }
    
    @objc private func clickDeEndAction() {
        clickBlock?("dee")
    }
    
    @objc private func clickCoStartAction() {
        clickBlock?("cos")
    }
    
    @objc private func clickCoEndAction() {
        clickBlock?("coe")
    }


    func setCellData(model: DaySetTimeModel) {
        self.dataModel = model
        self.tlab.text = model.weekDay
        self.deStartBut.setTitle(model.deliveryBegin, for: .normal)
        self.deEndBut.setTitle(model.deliveryEnd, for: .normal)
        self.coStartBut.setTitle(model.takeBegin, for: .normal)
        self.coEndBut.setTitle(model.takeEnd, for: .normal)
        
        
        if model.deliveryIsOpen {
            self.deSliderBut.setImage(LOIMG("slider_on_b"), for: .normal)
            self.deLab.textColor = FONTCOLOR
            self.deStartBut.setTitleColor(FONTCOLOR, for: .normal)
            self.deEndBut.setTitleColor(FONTCOLOR, for: .normal)
        } else {
            self.deSliderBut.setImage(LOIMG("slider_off_b"), for: .normal)
            self.deLab.textColor = HCOLOR("#999999")
            self.deStartBut.setTitleColor(HCOLOR("#999999"), for: .normal)
            self.deEndBut.setTitleColor(HCOLOR("#999999"), for: .normal)

        }
        
        
        if model.takeIsOpen {
            self.coSliderBut.setImage(LOIMG("slider_on_b"), for: .normal)
            self.coLab.textColor = FONTCOLOR
            self.coStartBut.setTitleColor(FONTCOLOR, for: .normal)
            self.coEndBut.setTitleColor(FONTCOLOR, for: .normal)

        } else {
            self.coSliderBut.setImage(LOIMG("slider_off_b"), for: .normal)
            
            self.coLab.textColor = HCOLOR("#999999")
            self.coStartBut.setTitleColor(HCOLOR("#999999"), for: .normal)
            self.coEndBut.setTitleColor(HCOLOR("#999999"), for: .normal)

        }

    }

    
    
    
}
