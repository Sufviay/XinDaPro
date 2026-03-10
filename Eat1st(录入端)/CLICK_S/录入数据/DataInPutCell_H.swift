//
//  DataInPutCell_H.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/22.
//

import UIKit

class DataInPutCell_H: BaseTableViewCell, UITextFieldDelegate {
    
    
    private var titStr: String = ""
    
    var editeEndBlock: VoidStringBlock?

    private let titLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .left)
        lab.text = "Orders"
        return lab
    }()
    
    private let titLab2: UILabel = {
        
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#A8853A"), SFONT(17), .left)
        lab.text = "*"
        return lab
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(14)
        tf.textColor = HCOLOR("333333")
        tf.delegate = self
        tf.textAlignment = .right
        return tf
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titLab1)
        titLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }       

        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.centerY.equalTo(titLab1)
            $0.left.equalTo(titLab1.snp.right).offset(2)
        }
        
        contentView.addSubview(titLab2)
        titLab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titLab1.snp.bottom).offset(2)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(140)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        
    }
    
    
    func setCellData(name1: String, name2: String, content: String) {
        
        self.titStr = name1
        
        
        self.titLab1.text = name1
        self.titLab2.text = name2
        self.inputTF.text = content
        
        
        if titStr == "Total(£)" {
            self.inputTF.isEnabled = false
        } else {
            self.inputTF.isEnabled = true
        }
        
        if titStr == "Goods(£)" || titStr == "Other(£)" || titStr == "Part Time(£)" || titStr == "Pre Paid(£)" || titStr == "Remain(£)" {
            self.s_lab.isHidden = true
        } else {
            self.s_lab.isHidden = false
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        var expression = ""
    // 只允许输入数字和两位小数
    //    let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        
        //"^(-)?[0-9]*(\\.[0-9]{0,4})?$"
        //只允许输入正负数且最对两位小数
        
        if titStr == "Orders" {
            expression = "^[0-9]*([0-9])?$"
        } else {
            expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        }
        
        
    // let expression = "^[0-9]*([0-9])?$" 只允许输入纯数字
    // let expression = "^[A-Za-z0-9]+$" //允许输入数字和字母
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
             print("请输入数字")
             return false
        }
      return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text ?? "" != "" {
            let num =  Double(textField.text ?? "")
            if num == nil {
                HUD_MB.showWarnig("Invalid input", onView: PJCUtil.getWindowView())
                textField.text = ""
            } else {
                if titStr == "Orders" {
                    if num! > 99999 {
                        HUD_MB.showWarnig("Invalid input", onView: PJCUtil.getWindowView())
                        textField.text = ""
                    }
                    
                } else {
                    if num! > 99999999 {
                        HUD_MB.showWarnig("Invalid input", onView: PJCUtil.getWindowView())
                        textField.text = ""
                    }
                }
            }
        }
        self.editeEndBlock?(textField.text ?? "")
    }
    

    
}
