//
//  InPutAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/2/19.
//

import UIKit

class InPutAlert: BaseAlertView, UIGestureRecognizerDelegate, UITextFieldDelegate {

    
    var enterBlock: VoidBlock?
    
    var minOrMax: String = ""
    
    var deOrCo: String = ""
    
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
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.text = "Set time"
        return lab
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderColor = HCOLOR("999999").cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(16)
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 250, height: 150))
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
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
        }
        
        backView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-35)
            $0.height.equalTo(35)
            $0.top.equalToSuperview().offset(80)
        }
        
        tView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }

        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
         let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted

         // At every character in this "inverseSet" contained in the string,
         // split the string up into components which exclude the characters
         // in this inverse set
         let components = string.components(separatedBy: inverseSet)

         // Rejoin these components
         let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2

         // If the original string is equal to the filtered string, i.e. if no
         // inverse characters were present to be eliminated, the input is valid
         // and the statement returns true; else it returns false
         return string == filtered

    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    @objc func clickCancelAction() {
        disAppearAction()
    }
    
    @objc func clickConfirmAction() {
        disAppearAction()
    
        if inputTF.text != "" {
            enterBlock?([deOrCo, minOrMax, inputTF.text!])
        } else {
            HUD_MB.showWarnig("Please enter the time！", onView: PJCUtil.getWindowView())
        }
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    
    

    
}
