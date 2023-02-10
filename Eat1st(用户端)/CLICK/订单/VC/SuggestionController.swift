//
//  SuggestionController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/13.
//

import UIKit
import RxSwift

class SuggestionController: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private let bag = DisposeBag()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        lab.text = "Name:"
        return lab
    }()
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        lab.text = "Phone:"
        return lab
    }()

    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        lab.text = "Message:"
        return lab
    }()
    
    
    private let tView1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F8F8")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let tView2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F8F8")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let tView3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F8F8")
        view.layer.cornerRadius = 7
        return view
    }()


    
    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.attributedPlaceholder = NSAttributedString.init(string:"Enter the name", attributes: [
            NSAttributedString.Key.foregroundColor:HCOLOR("#999999")])
        return tf
    }()
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.attributedPlaceholder = NSAttributedString.init(string:"Enter the phone", attributes: [
            NSAttributedString.Key.foregroundColor:HCOLOR("#999999")])
        tf.delegate = self
        return tf
    }()

    
    private lazy var msgTF: UITextView = {
        let tv = UITextView()
        tv.textColor = FONTCOLOR
        tv.font = SFONT(14)
        tv.backgroundColor = .clear
        tv.delegate = self
        return tv
    }()
    
    private let holdLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(14), .left)
        lab.text = "Fill in your suggestions"
        return lab
    }()
    
    
    private let submitBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Submit", .white, BFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    
    
    
    override func setNavi() {
        self.naviBar.headerTitle = "Suggestion / Need more help?"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightImg = LOIMG("nav_bd")
    }
    
    
    

    override func setViews() {
        setUpUI()
    }
    
    
    private func setUpUI() {
        
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(naviBar.snp.bottom).offset(40)
        }
        
        
        
        view.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(50)
        }
        
        view.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(phoneLab.snp.bottom).offset(50)
        }
        
        
        view.addSubview(tView1)
        tView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalTo(nameLab)
        }
        
        view.addSubview(tView2)
        tView2.snp.makeConstraints {
            $0.left.right.equalTo(tView1)
            $0.height.equalTo(40)
            $0.centerY.equalTo(phoneLab)
        }
        
        view.addSubview(tView3)
        tView3.snp.makeConstraints {
            $0.left.right.equalTo(tView1)
            $0.height.equalTo(120)
            $0.top.equalTo(msgLab).offset(-5)
        }
        
        
        
        tView1.addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        tView2.addSubview(phoneTF)
        phoneTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        tView3.addSubview(msgTF)
        msgTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        tView3.addSubview(holdLab)
        holdLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        view.addSubview(submitBut)
        submitBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(50)
        }

        submitBut.addTarget(self, action: #selector(clickSubmitAction), for: .touchUpInside)
        
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func clickRightButAction() {
        //列表
        let nextVC = SuggestListController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @objc func clickSubmitAction() {
        if nameTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter your name", onView: self.view)
            return
        }
        
        if phoneTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter your phone", onView: self.view)
            return
        }
        
        if msgTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter suggestions", onView: self.view)
            return
        }
        submitAction_Net()
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    // 只允许输入数字和两位小数
    //    let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        //只允许输入正负数且最对两位小数
    //    let expression = "^(-)?[0-9]*(\\.[0-9]{0,2})?$"
        
    // let expression = "^[0-9]*([0-9])?$" 只允许输入纯数字
    // let expression = "^[A-Za-z0-9]+$" //允许输入数字和字母
        
        let expression = "^[0-9]{0,11}?$" //输入11位数字
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
             print("请输入数字")
             return false
        }
      return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text ?? "") != "" {
            holdLab.isHidden = true
        } else {
            holdLab.isHidden = false
        }
    }
    
    
    private func submitAction_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doSuggest(name: self.nameTF.text!, phone: self.phoneTF.text!, msg: self.msgTF.text!).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

    
}
