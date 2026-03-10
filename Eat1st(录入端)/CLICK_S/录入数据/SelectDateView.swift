//
//  SelectDateView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/6/30.
//

import UIKit

class SelectDateView: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var selectBlock: VoidBlock?

    var dateArr: [String] = []

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let OKBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", MAINCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", FONTCOLOR, BFONT(14), .clear)
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
            $0.size.equalTo(CGSize(width: 250, height: 330))
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
        

        
        backView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        dateArr.removeAll()
        for model in FeeTypeResultModel.sharedInstance.dayResultList {
            dateArr.append(model.date)
        }
        
        self.timePickerView.reloadAllComponents()
        
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
        self.selectBlock?(["date": dateArr[timePickerView.selectedRow(inComponent: 0)], "idx": timePickerView.selectedRow(inComponent: 0)])
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArr.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = SFONT(16)
            pickerLabel?.textColor = FONTCOLOR
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = dateArr[row]
        return pickerLabel!
    }
    


}
