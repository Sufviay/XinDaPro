//
//  DataOverviewHeaderView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/3.
//

import UIKit

class DataOverviewHeaderView: UIView {

    private var type: String = "day"
    
    
    var selectBlock: VoidStringBlock?

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        //lab.text = Date().getString("yyyy-MM-dd")
        return lab
    }()
    
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        img.isHidden = true
        return img
    }()
    
    
    private let monthBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "This month", HCOLOR("#5C5D70"), BFONT(12), .white)
        but.titleLabel?.adjustsFontSizeToFitWidth = true
        but.isHidden = true
        return but
    }()
    

    private let weekBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "This week", HCOLOR("#5C5D70"), BFONT(12), .white)
        but.isHidden = true
        return but
    }()

    
    private let dayBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Today", HCOLOR("#465DFD"), BFONT(12), .white)
        but.isHidden = true
        return but
    }()
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()

    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titLab.snp.bottom).offset(5)
        }
        
        addSubview(monthBut)
        monthBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(70)
            $0.right.equalToSuperview().offset(-10)
        }
        
        addSubview(weekBut)
        weekBut.snp.makeConstraints {
            $0.centerY.height.equalTo(monthBut)
            $0.width.equalTo(70)
            $0.right.equalTo(monthBut.snp.left).offset(-5)
        }
        
        addSubview(dayBut)
        dayBut.snp.makeConstraints {
            $0.centerY.height.equalTo(monthBut)
            $0.width.equalTo(50)
            $0.right.equalTo(weekBut.snp.left).offset(-5)
        }
        
        dayBut.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 2))
            $0.centerX.equalTo(dayBut)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        
        weekBut.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 2))
            $0.centerX.equalTo(weekBut)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        monthBut.addSubview(line3)
        line3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 2))
            $0.centerX.equalTo(monthBut)
            $0.bottom.equalToSuperview().offset(-12)
        }


        monthBut.addTarget(self, action: #selector(clickMonthAction), for: .touchUpInside)
        weekBut.addTarget(self, action: #selector(clickWeekAction), for: .touchUpInside)
        dayBut.addTarget(self, action: #selector(clickDayAction), for: .touchUpInside)
    }
    
    
    
    
    @objc private func clickDayAction() {
        if type != "day" {
            type = "day"
            line1.isHidden = false
            line2.isHidden = true
            line3.isHidden = true
            dayBut.setTitleColor(HCOLOR("#465DFD"), for: .normal)
            weekBut.setTitleColor(HCOLOR("#5C5D70"), for: .normal)
            monthBut.setTitleColor(HCOLOR("#5C5D70"), for: .normal)
            
            selectBlock?(type)
        }
    }
    
    @objc private func clickWeekAction() {
        if type != "week" {
            type = "week"
            line1.isHidden = true
            line2.isHidden = false
            line3.isHidden = true
            dayBut.setTitleColor(HCOLOR("#5C5D70"), for: .normal)
            weekBut.setTitleColor(HCOLOR("#465DFD"), for: .normal)
            monthBut.setTitleColor(HCOLOR("#5C5D70"), for: .normal)
            selectBlock?(type)
        }

    }
    
    @objc private func clickMonthAction() {
        if type != "month" {
            type = "month"
            line1.isHidden = true
            line2.isHidden = true
            line3.isHidden = false
            dayBut.setTitleColor(HCOLOR("#5C5D70"), for: .normal)
            weekBut.setTitleColor(HCOLOR("#5C5D70"), for: .normal)
            monthBut.setTitleColor(HCOLOR("#465DFD"), for: .normal)
            selectBlock?(type)
        }
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setDate(date: String) {
        titLab.text = date
        line.isHidden = false
    }
    
}
