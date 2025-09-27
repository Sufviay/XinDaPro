//
//  SelectWeekAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/19.
//

import UIKit

class SelectWeekAlert: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {


    var selectWeekBlock: VoidStringBlock?

    private let titArr: [String] = ["Monday".local, "Tuesday".local, "Wednesday".local, "Thursday".local, "Friday".local, "Saturday".local, "Sunday".local]
    
    private var selectIdx: String = "1"
    
    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm".local, .white, TIT_3, MAINCOLOR)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, MAINCOLOR, TIT_3, .clear)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        return but
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
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
            $0.size.equalTo(CGSize(width: 300, height: 350))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(sureBut)
        sureBut.snp.makeConstraints {
            $0.left.equalTo(backView.snp.centerX).offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.size.centerY.equalTo(sureBut)
            $0.left.equalToSuperview().offset(20)
            
        }
        
        backView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-40)
        }


        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        sureBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)

    }
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    @objc func clickCancelAction() {
        disAppearAction()
    }
    
    @objc func clickConfirmAction() {
        
        selectWeekBlock?(selectIdx)
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = TIT_2
            pickerLabel?.textColor = TXTCOLOR_1
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = titArr[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectIdx = String(row + 1)
    }

    
    
    

}
