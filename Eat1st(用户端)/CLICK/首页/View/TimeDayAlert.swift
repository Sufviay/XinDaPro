//
//  TimeDayAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/29.
//

import UIKit

class TimeDayAlert: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var selectBlock: VoidBlock?
    ///年数组
    private let yearArr: [String] = Date().getYearStrArr(yearCount: 100)
    
    ///月数组
    private let monthArr: [String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    
    ///日
    private var dayCount: Int = DateTool.getDaysBy(month: 1)
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let OKBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "OK", MAINCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", FONTCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let headView: UIView = {
        let view = UIView()
        
        view.backgroundColor = MAINCOLOR
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: 300, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

//    private let yearLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.white, BFONT(14), .center)
//        lab.text = "Year"
//        return lab
//    }()
    
    private let monthLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "month"
        return lab
    }()
    
    private let dayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "day"
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
        
//        backView.addSubview(yearLab)
//        yearLab.snp.makeConstraints {
//            $0.left.top.equalToSuperview()
//            $0.height.equalTo(45)
//            $0.width.equalTo(100)
//        }
//        
        backView.addSubview(monthLab)
        monthLab.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(45)
            $0.left.top.equalToSuperview()
        }
        
        
        backView.addSubview(dayLab)
        dayLab.snp.makeConstraints {
            $0.width.height.top.equalTo(monthLab)
            $0.left.equalTo(monthLab.snp.right)
        }

        
        backView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(headView.snp.bottom).offset(10)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        OKBut.addTarget(self, action: #selector(clickOKAction), for: .touchUpInside)
        
    }
    
    
    override func appearAction() {
        super.appearAction()
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @objc private func clickCancelAction() {
        self.disAppearAction()
    }
    
    @objc private func clickOKAction()  {
        //let year = yearArr[timePickerView.selectedRow(inComponent: 0)]
        let month = monthArr[timePickerView.selectedRow(inComponent: 0)]
        var day: String = ""
        if timePickerView.selectedRow(inComponent: 1) + 1 < 10 {
            day = "0" + String(timePickerView.selectedRow(inComponent: 1) + 1)
        } else {
            day = String(timePickerView.selectedRow(inComponent: 1) + 1)
        }
        let showStr = "\(month)-\(day)"
        self.selectBlock?([showStr, showStr, ""])
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
//        if component == 0 {
//            return  yearArr.count
//        }
        if component == 0 {
            return 12
        }
        return dayCount
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = SFONT(16)
            pickerLabel?.textColor = FONTCOLOR
            pickerLabel?.textAlignment = .center
        }
        
//        if component == 0 {
//            pickerLabel?.text = yearArr[row]
//        }
        if component == 0 {
            pickerLabel?.text = monthArr[row]
        }
        if component == 1 {
            if row + 1 < 10 {
                pickerLabel?.text = "0" + String(row + 1)
            } else {
                pickerLabel?.text = String(row + 1)
            }
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

//        if component == 0 {
//            let year = Int(yearArr[row]) ?? 0
//            let month = pickerView.selectedRow(inComponent: 1) + 1
//            self.dayCount = DateTool.getDaysBy(year: year, month: month)
//            pickerView.reloadComponent(2)
//        }

        if component == 0 {
            let year = Int(yearArr[pickerView.selectedRow(inComponent: 0)]) ?? 0
            let month = row + 1
            self.dayCount = DateTool.getDaysBy(month: month)
            pickerView.reloadComponent(1)

        }
    }
}
