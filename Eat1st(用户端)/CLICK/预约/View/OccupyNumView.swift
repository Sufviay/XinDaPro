//
//  OccupyNumView.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/11.
//

import UIKit

class OccupyNumView: BaseAlertView, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var selectBlock: VoidBlock?
    
    var maxCount: Int = 0 {
        didSet {
            numPickerView.reloadAllComponents()
        }
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()

    

    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", HCOLOR("333333"), BFONT(13), .clear)
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", HCOLOR("333333"), BFONT(13), .clear)
        return but
    }()
    
    private lazy var numPickerView: UIPickerView = {
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
            $0.size.equalTo(CGSize(width: 200, height: S_W))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }

        backView.addSubview(sureBut)
        sureBut.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(0)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.size.centerY.equalTo(sureBut)
            $0.left.equalToSuperview()
        }
        
        
        backView.addSubview(numPickerView)
        numPickerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(sureBut.snp.top).offset(-15)
            $0.top.equalToSuperview().offset(15)
        }
        numPickerView.selectRow(1, inComponent: 0, animated: false)
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        sureBut.addTarget(self, action: #selector(clickSureAction), for: .touchUpInside)

    }
    
    
    @objc private func clickSureAction() {
        let count = numPickerView.selectedRow(inComponent: 0) + 1
        selectBlock?(count)
        disAppearAction()
    }
    
    
    @objc private func clickCancelAction() {
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    
    
}
