//
//  StartAndEndDateCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/19.
//

import UIKit

class StartAndEndDateCell: BaseTableViewCell {

    
    var clickBlock: VoidStringBlock?

    private let backView1: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let backView2: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 10
        return view
    }()

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#ADADAD")
        return view
    }()
    
    
    private let xl1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_show")
        return img
    }()
    
    private let xl2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_show")
        return img
    }()
    
    
    private let startLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TFHOLDCOLOR, TXT_1, .left)
        lab.text = "Start Date".local
        return lab
    }()
    
    
    private let endLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TFHOLDCOLOR, TXT_1, .left)
        lab.text = "End Date".local
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 1))
        }
        
        contentView.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(line.snp.left).offset(-10)
        }
        
        contentView.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(line.snp.right).offset(10)
        }
        
        backView1.addSubview(xl1)
        xl1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView2.addSubview(xl2)
        xl2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }

        backView1.addSubview(startLab)
        startLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-30)
        }
        
        backView2.addSubview(endLab)
        endLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-30)
        }


        let tap1 = UITapGestureRecognizer(target: self, action: #selector(clickStartAction))
        backView1.addGestureRecognizer(tap1)

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clickEndAction))
        backView2.addGestureRecognizer(tap2)

        
    }
    
    
    func setCellData(startDate: String, endDate: String) {
        
        if startDate == "" {
            startLab.text = "Start Date".local
            startLab.textColor = TFHOLDCOLOR
        } else {
            startLab.text = startDate
            startLab.textColor = TXTCOLOR_1
        }
        
        if endDate == "" {
            endLab.text = "End Date".local
            endLab.textColor = TFHOLDCOLOR
        } else {
            endLab.text = endDate
            endLab.textColor = TXTCOLOR_1
        }
    }
    
    
    @objc private func clickStartAction() {
        clickBlock?("start")
    }
    
    
    @objc private func clickEndAction() {
        clickBlock?("end")
    }

    
    
}



