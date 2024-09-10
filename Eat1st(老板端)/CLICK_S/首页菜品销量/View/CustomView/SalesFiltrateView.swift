//
//  SalesFiltrateView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/22.
//

import UIKit

class SalesFiltrateView: UIView {


    private var type: String = "month"

    
    //选择了类型的Block
    var selectTypeBlock: VoidBlock?
    
    //选择时间的Block
    var selectTimeBlock: VoidBlock?
    
    
    private let typeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F6F6F6")
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(10), .center)
        lab.text = ""
        return lab
    }()
    
    private let s_img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl_b")
        return img
    }()
    
    private let s_img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl_b")
        return img
    }()
    
    private let timeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F6F6F6")
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(10), .center)
        lab.text = ""
        return lab
    }()
    
    
    private lazy var typeView: FiltrateSelectTagView = {
        let view = FiltrateSelectTagView()
        view.selectType = "month"
        view.selectBlock = { [unowned self] (str) in
            self.typeLab.text = str as? String
            self.type = str as! String
            timeLab.text = ""
            self.selectTypeBlock?(str)
            
        }
        return view
    }()
    
    
    private lazy var weekAlert: TimeWeeksAlert = {
        let view = TimeWeeksAlert()
        
        view.selectBlock = { [unowned self] (arr) in
            let showStr = (arr as! [String])[0]
            let dateStr = (arr as! [String])[1]
            let endDateStr = (arr as! [String])[2]
            self.timeLab.text = showStr
            self.selectTimeBlock?([dateStr, endDateStr])
        }
        
        return view
    }()
    
//    private lazy var yearAlert: TimeYearAlert = {
//        let view = TimeYearAlert()
//        view.selectBlock = { [unowned self] (arr) in
//            let showStr = (arr as! [String])[0]
//            let dateStr = (arr as! [String])[1]
//            self.timeLab.text = showStr
//            self.selectTimeBlock?(dateStr)
//        }
//
//        return view
//    }()
    
    private lazy var monthAlert: TimeMonthAlert = {
        let view = TimeMonthAlert()
        view.selectBlock = { [unowned self] (arr) in
            let showStr = (arr as! [String])[0]
            let dateStr = (arr as! [String])[1]
            let endDateStr = (arr as! [String])[2]
            self.timeLab.text = showStr
            self.selectTimeBlock?([dateStr, endDateStr])
        }
        return view
    }()
    
    private lazy var dayAlert: TimeDayAlert = {
        let view = TimeDayAlert()
        view.selectBlock = { [unowned self] (arr) in
            let showStr = (arr as! [String])[0]
            let dateStr = (arr as! [String])[1]
            let endDateStr = (arr as! [String])[2]
            self.timeLab.text = showStr
            self.selectTimeBlock?([dateStr, endDateStr])
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        
        
        self.addSubview(typeBut)
        typeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 85, height: 28))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(0)
        }

        
        
        self.addSubview(timeBut)
        timeBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(0)
            $0.left.equalTo(typeBut.snp.right).offset(10)
            $0.height.equalTo(28)
        }

        
        typeBut.addSubview(s_img1)
        s_img1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }
        
        typeBut.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
        }
        
        typeLab.text = "month"
        
        
        timeBut.addSubview(s_img2)
        s_img2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }
        
        timeBut.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
        }
        
        
        let year = DateTool.getDateComponents(date: Date()).year!
        let month = DateTool.getDateComponents(date: Date()).month!

        self.timeLab.text = month >= 10 ? "\(year)-\(month)" : "\(year)-0\(month)"
        
        timeBut.addTarget(self, action: #selector(clickTimeAction), for: .touchUpInside)
        typeBut.addTarget(self, action: #selector(clickTypeAction), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func clickTypeAction() {
        self.typeView.appearAction()
        
    }
    
    @objc func clickTimeAction() {
        if self.type == "weeks" {
            self.weekAlert.appearAction()
        }
        
//        if self.type == "years" {
//            self.yearAlert.appearAction()
//        }
        
        if self.type == "month" {
            self.monthAlert.appearAction()
        }
        
        if self.type == "day" {
            self.dayAlert.appearAction()
        }
    }
}
