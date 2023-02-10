//
//  DateHeaderCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit

class DateHeaderCell: BaseTableViewCell {
    
    
    var clickBlock: VoidStringBlock?

    
    private var date: String = ""

    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#8F92A1"), SFONT(13), .left)
        lab.text = "Show me live data today"
        return lab
    }()
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Other date", HCOLOR("#2B8AFF"), SFONT(13), .clear)
        return but
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sy_next"), for: .normal)
        return but
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 30))
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 30))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(nextBut.snp.left).offset(0)
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickMoreAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickMoreAction() {
        
        if date == Date().getString("yyyy-MM-dd") {
            clickBlock?("other")
            
        } else {
            clickBlock?("today")
        }
        
    }
    
    
    func setCellData(dateStr: String) {
        
        self.date = dateStr
        
        if dateStr == Date().getString("yyyy-MM-dd") {
            
            //self.tlab.text = "Show me live data today"
            self.moreBut.setTitle("Other date", for: .normal)
            
        } else {
            
            //self.tlab.text = "Show me live data " + dateStr.changeDateInEnglish()
            self.moreBut.setTitle("Today", for: .normal)
            
        }
    }
    
}


class SelectDateCell: BaseTableViewCell {
    
    var clickBlock: VoidBlock?
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.08)
        but.layer.cornerRadius = 7
        return but
    }()

    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_xl")
        return img
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(15), .left)
        lab.text = "6 Jan 2022"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        
        selectBut.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        selectBut.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 6))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        selectBut.addTarget(self, action: #selector(clickDateAction), for: .touchUpInside)
    }
    
    func setCellData(dateStr: String, endDateStr: String) {
        
        let sDate = dateStr.changeDateInEnglish()
        
        if endDateStr == "" {
            self.dateLab.text = sDate
        } else {
            let eDate = endDateStr.changeDateInEnglish()
            self.dateLab.text = "\(sDate) - \(eDate)"
        }
        
    }
    
    @objc private func clickDateAction() {
        clickBlock?("")
    }
    
}
