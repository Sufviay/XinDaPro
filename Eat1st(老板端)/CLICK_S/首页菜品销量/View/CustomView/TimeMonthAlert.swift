//
//  TimeMonthAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/28.
//

import UIKit

class TimeMonthAlert: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectBlock: VoidBlock?
    
    ///年数组
    private let yearArr: [String] = Date().getYearStrArr(yearCount: 3)
    
    ///月数组
    private let monthArr: [String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let OKBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "OK".local, MAINCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, FONTCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let headView: UIView = {
        let view = UIView()
        
        view.backgroundColor = MAINCOLOR
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: 300, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

    private let yearLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Year".local
        return lab
    }()
    
    private let monthLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Month".local
        return lab
    }()
    
    private lazy var timePickerView: UIPickerView = {
        let pick = UIPickerView()
        pick.delegate = self
        pick.dataSource = self
        return pick
    }()

    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 300, height: 250))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(OKBut)
        OKBut.snp.makeConstraints {
            $0.bottom.right.equalToSuperview()
            $0.height.equalTo(45)
            $0.left.equalTo(backView.snp.centerX)
        }
        
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.bottom.height.equalTo(OKBut)
            $0.left.equalToSuperview()
            $0.right.equalTo(backView.snp.centerX)
        }
        
        backView.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        backView.addSubview(yearLab)
        yearLab.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.height.equalTo(45)
            $0.width.equalTo(150)
        }
        
        backView.addSubview(monthLab)
        monthLab.snp.makeConstraints {
            $0.width.height.top.equalTo(yearLab)
            $0.left.equalTo(yearLab.snp.right)
        }
        
        backView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(headView.snp.bottom).offset(10)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-30)
        }
        
        timePickerView.selectRow(DateTool.shared.curMonth - 1, inComponent: 1, animated: false)
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        OKBut.addTarget(self, action: #selector(clickOKAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickCancelAction() {
        self.disAppearAction()
    }
    
    @objc private func clickOKAction()  {
        let year = yearArr[timePickerView.selectedRow(inComponent: 0)]
        let month = monthArr[timePickerView.selectedRow(inComponent: 1)]
        let showStr = "\(year)-\(month)"
        let parDateStr = "\(year)-\(month)"
        self.selectBlock?([showStr, parDateStr, ""])
        self.disAppearAction()
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

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearArr.count
        }
        return 12
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = SFONT(16)
            pickerLabel?.textColor = FONTCOLOR
            pickerLabel?.textAlignment = .center
        }
        
        if component == 0 {
            pickerLabel?.text = yearArr[row]
        }
        if component == 1 {
            pickerLabel?.text = monthArr[row]
        }
        
        return pickerLabel!
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        if component == 0 {
//            //更改周数
//            let year = Int(yearArr[row]) ?? 0
//            self.weekCount = DateTool.getWeekCountBy(year: year)
//            pickerView.reloadComponent(1)
//            let week = weekCount - pickerView.selectedRow(inComponent: 1)
//            print(week)
//            self.dateStr = DateTool.getWeekRangeDateBy(year: year, week: week)
//        }
//
//        if component == 1 {
//            //更新日期
//            let year = Int(yearArr[pickerView.selectedRow(inComponent: 0)]) ?? 0
//            let week = weekCount - row
//            self.dateStr = DateTool.getWeekRangeDateBy(year: year, week: week)
//        }
//
//    }

    

}
