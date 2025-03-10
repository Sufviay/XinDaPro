//
//  TimeWeeksAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/27.
//

import UIKit

class TimeWeeksAlert: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectBlock: VoidBlock?
    
    ///年数组
    private let yearArr: [String] = Date().getYearStrArr(yearCount: 3)
    ///当前年的周数组
    private var weekCount: Int = DateTool.shared.getWeekCountBy(year: DateTool.shared.curYear)
    
    
    
    ///日期字符串
    private var dateStr: String = ""  {
        didSet {
            self.timeLab.text = dateStr
            print(dateStr)
        }
    }
    
    
    private var startDate_sel: Date?
    private var endDate_sel: Date?
    

    

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
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 40, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

    private let yearLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Year".local
        return lab
    }()
    
    private let weekLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Week".local
        return lab
    }()
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Period".local
        return lab
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.numberOfLines = 2
        lab.text = ""
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

        
        print(dateStr)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: S_W - 40, height: 300))
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
            $0.width.equalTo((S_W - 40) / 3)
        }
        
        backView.addSubview(weekLab)
        weekLab.snp.makeConstraints {
            $0.width.height.top.equalTo(yearLab)
            $0.left.equalTo(yearLab.snp.right)
        }
        
        backView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.width.height.top.equalTo(yearLab)
            $0.left.equalTo(weekLab.snp.right)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.width.equalTo((S_W - 40) / 3)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        backView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(headView.snp.bottom).offset(10)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
            $0.right.equalTo(timeLab.snp.left).offset(-10)
        }
        
        
        
        print("aaaaa\(DateTool.shared.curWeek)")
                
        let dateRange = DateTool.shared.getWeekRangeDateBy(year: DateTool.shared.curYear, week: DateTool.shared.curWeek)
        dateStr = dateRange.startDate.getString("yyyy-MM-dd") + "\n~" + dateRange.endDate.getString("yyyy-MM-dd")
        startDate_sel = dateRange.startDate
        endDate_sel = dateRange.endDate
        timePickerView.selectRow(DateTool.shared.curWeek - 1, inComponent: 1, animated: false)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        OKBut.addTarget(self, action: #selector(clickOKAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickCancelAction() {
        
        let date = DateTool.dateFromStringByFormatter(dateString: "2025-01-06", formatter: "yyyy-MM-dd")
        
        let com = DateTool.getDateComponents(date: date)
        
        print(com.weekOfYear!)

        
        self.disAppearAction()
    }
    
    @objc private func clickOKAction()  {
    
        if let sDate = startDate_sel, let eDate = endDate_sel {
            
            let year = yearArr[timePickerView.selectedRow(inComponent: 0)]
            let week = timePickerView.selectedRow(inComponent: 1) + 1
            let showStr = "\(year) \(week)th weeks (\(sDate.getString("MM-dd"))~\(eDate.getString("MM-dd")))"

            let parDateStr1 = sDate.getString("yyyy-MM-dd")
            let parDateStr2 = eDate.getString("yyyy-MM-dd")
            selectBlock?([showStr, parDateStr1, parDateStr2])
            disAppearAction()
        } else {
            disAppearAction()
        }
        

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
        return weekCount
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
            pickerLabel?.text = String(row + 1)
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            //更改周数
            let year = Int(yearArr[row]) ?? 0
            self.weekCount = DateTool.shared.getWeekCountBy(year: year)
            pickerView.reloadComponent(1)
            let week = pickerView.selectedRow(inComponent: 1) + 1
            print(week)
            
            let dateRange = DateTool.shared.getWeekRangeDateBy(year: year, week: week)
            dateStr = dateRange.startDate.getString("yyyy-MM-dd") + "\n~" + dateRange.endDate.getString("yyyy-MM-dd")
            startDate_sel = dateRange.startDate
            endDate_sel = dateRange.endDate
        }
        
        if component == 1 {
            //更新日期
            let year = Int(yearArr[pickerView.selectedRow(inComponent: 0)]) ?? 0
            let week = row + 1
            let dateRange = DateTool.shared.getWeekRangeDateBy(year: year, week: week)
            dateStr = dateRange.startDate.getString("yyyy-MM-dd") + "\n~" + dateRange.endDate.getString("yyyy-MM-dd")
            startDate_sel = dateRange.startDate
            endDate_sel = dateRange.endDate
        }
        
    }

}
