//
//  CalendarAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/2/7.
//

import UIKit

class CalendarAlert: BaseAlertView, UIGestureRecognizerDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    var clickDateBlock: VoidBlock?

    private var selectDate: Date?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(13), MAINCOLOR)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", MAINCOLOR, BFONT(13), .clear)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        return but
    }()
    
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        
        
        calendar.appearance.todayColor = HCOLOR("999999")
        //calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.headerTitleFont = BFONT(18)
        calendar.appearance.headerTitleColor = HCOLOR("333333")
        calendar.appearance.weekdayTextColor = HCOLOR("#465DFD")
        calendar.appearance.weekdayFont = BFONT(14)
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.selectionColor = HCOLOR("#465DFD")

        calendar.delegate = self
        calendar.dataSource = self
        
        
        let local = Locale.init(identifier: MyLanguageManager.shared.language.code)
        
        calendar.locale = local
        calendar.backgroundColor = .clear
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 5
        
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = false

        
        return calendar
    }()
    
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: S_W - 40, height: S_W))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(sureBut)
        sureBut.snp.makeConstraints {
            $0.left.equalTo(backView.snp.centerX).offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.size.centerY.equalTo(sureBut)
            $0.left.equalToSuperview().offset(20)
            
        }
        
        backView.addSubview(calendar)
        calendar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-20)
        }
        
        
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        sureBut.addTarget(self, action: #selector(clickSureAction), for: .touchUpInside)
        
    }
    
    
    
    @objc private func clickSureAction() {

        if selectDate != nil {
            clickDateBlock?(selectDate)
            disAppearAction()
        }
    }
    
    
    @objc private func clickCancelAction() {
        self.disAppearAction()
    }
    
    
    
    override func appearAction() {
        
//        self.dateStr = ""
//        for date in calendar.selectedDates {
//            //取消选中状态
//            calendar.deselect(date)
//        }
        super.appearAction()
    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }

    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    
    
    //MARK: - Calendar Delegate
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectDate = date
    }
    
    
        
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//
//
//
//        if calendar.selectedDates.count + 1 > 2 {
//            print("只能选择起始日期")
//
//            for date in calendar.selectedDates {
//                //取消选中状态
//                calendar.deselect(date)
//            }
//
//
//
//        }
//        return true
//
//    }

    
    
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        let dateStr = date.getString("yyyy-MM-dd")
//        let currentStr = Date().getString("yyyy-MM-dd")
//        if dateStr == currentStr {
//            return ""
//        }
//        return nil
//    }
//

    
    
    
    
}
