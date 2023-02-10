//
//  DishEditeInPutCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit

class DishEditeInPutCell: BaseTableViewCell, UITextFieldDelegate {
    
    var editeEndBlock: VoidStringBlock?

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F9F9")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = HCOLOR("333333")
        tf.delegate = self
        return tf
    }()
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        
    }
    
    
    func setCellData(titStr: String, msgStr: String) {
        self.titlab.text = titStr
        self.inputTF.text = msgStr
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.editeEndBlock?(self.inputTF.text ?? "")
    }
    
    
}



class DishEditePriceInPutCell: BaseTableViewCell, UITextFieldDelegate {

    var editeEndBlock: VoidStringBlock?
    
    let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Pirce"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F8F9F9")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let moneyIconLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(14), .left)
        lab.text = "£"
        return lab
    }()

    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = HCOLOR("333333")
        tf.delegate = self
        return tf
    }()
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(moneyIconLab)
        moneyIconLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        
    }
    
    
    func setCellData(money: String) {
        
        self.inputTF.text = money
        
//        if money == 0 {
//            self.inputTF.text = ""
//        } else {
//            self.inputTF.text = String(money)
//        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    // 只允许输入数字和两位小数
    //    let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        //只允许输入正负数且最对两位小数
        let expression = "^(-)?[0-9]*(\\.[0-9]{0,2})?$"
        
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
        self.editeEndBlock?(textField.text ?? "")
    }
    
}


class PriceDesCell: BaseTableViewCell {
    
    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F75E5E"), SFONT(10), .left)
        lab.text = "The price is between -100 and 100. When it is negative, the corresponding order price is subtracted; when it is positive, the order price is increased; when it is 0, it is free."
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
        }
        
    }
    
    
}

