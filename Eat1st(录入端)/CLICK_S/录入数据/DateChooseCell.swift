//
//  DateChooseCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/24.
//

import UIKit

class DateChooseCell: BaseTableViewCell {
    
    var dateEndBlock: VoidStringBlock?

    private let titLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .left)
        lab.text = "Date(£)"
        return lab
    }()
    
    private let titlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "日期"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#A8853A"), SFONT(17), .left)
        lab.text = "*"
        return lab
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xsj")
        return img
    }()

    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .left)
        lab.text = ""
        return lab
    }()
    
    //日历弹窗
    private lazy var calendarView: DiscountSelectDateView = {
        let view = DiscountSelectDateView()
        view.clickDateBlock = { [unowned self] (par) in
            let date = par as! Date
            self.dateEndBlock?(date.getString("yyyy-MM-dd"))
        }
        
        return view
    }()
    
    
    
    
    override func setViews() {
        
        
        contentView.addSubview(titLab1)
        titLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(titlab2)
        titlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titLab1.snp.bottom)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.centerY.equalTo(titLab1)
            $0.left.equalTo(titLab1.snp.right).offset(2)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalToSuperview().offset(45)
        }
        
        backView.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 11, height: 7))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(xlImg.snp.left).offset(-20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickTapAction))
        self.backView.addGestureRecognizer(tap)
    }
    
    
    @objc private func clickTapAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.calendarView.appearAction()
    }
    
    
    func setCellData(date: String) {
        self.dateLab.text = date
    }
    
    

}
