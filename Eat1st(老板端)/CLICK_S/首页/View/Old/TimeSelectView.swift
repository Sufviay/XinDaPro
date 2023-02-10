//
//  TimeSelectView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit

class TimeSelectView: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var clickBlock: VoidBlock?

    var type: String = ""
    var idx: Int = 0
    
    
    private let hourArr: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    private let minArr: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    private let secondArr: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    private var selectH: String = "00"
    private var selectM: String = "00"
    private var selectS: String = "00"

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", FONTCOLOR, SFONT(14), .clear)
        return but
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", FONTCOLOR, SFONT(14), .clear)
        return but
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
            $0.size.equalTo(CGSize(width: 300, height: 200))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
        }
        
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
        }
        
        backView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-40)
        }
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        
    }
    
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    @objc func clickCancelAction() {
        disAppearAction()
    }
    
    @objc func clickConfirmAction() {
        disAppearAction()
        let time = selectH + ":" + selectM
        clickBlock?([type, idx, time])
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
            return hourArr.count
        }
        if component == 1 {
            return minArr.count
        }
        return secondArr.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = SFONT(16)
            pickerLabel?.textColor = HCOLOR("#333333")
            pickerLabel?.textAlignment = .center
        }
        
        if component == 0 {
            pickerLabel?.text = hourArr[row]
        }
        if component == 1 {
            pickerLabel?.text = minArr[row]
        }
        if component == 2 {
            pickerLabel?.text = secondArr[row]
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        if component == 0 {
            print("hour\(row)")
            self.selectH = hourArr[row]
        }
        if component == 1 {
            print("min\(row)")
            self.selectM = minArr[row]
        }
        if component == 2 {
            print("sec\(row)")
            self.selectS = secondArr[row]
        }
        
    }

    
}
