//
//  OrderInputZQCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/28.
//

import UIKit

class OrderInputZQCell: BaseTableViewCell, UITextFieldDelegate {
    
    var editeNameBlock: VoidBlock?
    
    var editePhoneBlock: VoidBlock?
    
    var clickTimeBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "Your Details"
        return lab
    }()
    
    private let nameImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_name")
        return img
    }()
    

    private let phoneImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_phone")
        return img
    }()
    
    private let timeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_time")
        return img
    }()
    
    private lazy var nameInputTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.tag = 1
        tf.delegate = self
        tf.setPlaceholder("Name", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.tag = 2
        tf.delegate = self
        tf.setPlaceholder("Phone number", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    
    private lazy var timeTF: UITextField = {
        let tf = UITextField()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        tf.setPlaceholder("Expected time", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    private let timeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        return but
    }()
    
    private let alertLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF4E26"), SFONT(10), .left)
        lab.numberOfLines = 0
        return lab
    }()

    private let labBView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFF6F3")
        view.layer.cornerRadius = 5
        return view
    }()
    
    override func setViews() {
    
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        backView.addSubview(nameImg)
        nameImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(50)
        }
        
        backView.addSubview(phoneImg)
        phoneImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(nameImg.snp.bottom).offset(25)
        }
        
        backView.addSubview(timeImg)
        timeImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(phoneImg.snp.bottom).offset(25)
        }
    
        backView.addSubview(nameInputTF)
        nameInputTF.snp.makeConstraints {
            $0.centerY.equalTo(nameImg)
            $0.height.equalTo(44)
            $0.left.equalTo(nameImg.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-50)
        }

        
        backView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints {
            $0.left.size.equalTo(nameInputTF)
            $0.centerY.equalTo(phoneImg)
        }
        
        backView.addSubview(timeTF)
        timeTF.snp.makeConstraints {
            $0.centerY.equalTo(timeImg)
            $0.left.size.equalTo(nameInputTF)
        }

        
        backView.addSubview(timeBut)
        timeBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(timeImg)
        }
        
        
        backView.addSubview(labBView)
        labBView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalTo(timeBut.snp.bottom).offset(0)
        }
        
        
        labBView.addSubview(alertLab)
        alertLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(clickNextAction))
        timeTF.addGestureRecognizer(tap1)

        timeBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        
    }
    
    
//    func setCellData(name: String, phone: String, time: String, isCanEidte: Bool) {
//        self.nameInputTF.text = name
//        self.phoneTF.text = phone
//        self.timeTF.text = time
//
//        self.nameInputTF.isEnabled = isCanEidte
//        self.phoneTF.isEnabled = isCanEidte
//        self.timeBut.isEnabled = isCanEidte
//    }
    
    

    
    func setCellData1(name: String, phone: String, hopeTime: String, isCanEidte: Bool,  minTime: String, maxTime: String, ydMsg: String, storeKind: String, reserveDate: String) {
        self.nameInputTF.text = name
        self.phoneTF.text = phone
        self.timeTF.text = hopeTime
        
        self.nameInputTF.isEnabled = isCanEidte
        self.phoneTF.isEnabled = isCanEidte
        self.timeBut.isEnabled = isCanEidte
        self.timeTF.isUserInteractionEnabled = isCanEidte
        
//        if busyType == "1" {
//            //是
//            self.alertLab.isHidden = false
//        } else {
//            self.alertLab.isHidden = true
//        }
//
        
        if storeKind != "2" {
            labBView.isHidden = false
            timeTF.text = hopeTime
        } else {
            labBView.isHidden = true
            timeTF.text = reserveDate
        }
        
    
        if ydMsg == "" {
            self.alertLab.text = "Estimated time \(minTime)-\(maxTime)"
        } else {
            self.alertLab.text = ydMsg
        }
    
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        
        if tag == 1 {
            //名字
            self.editeNameBlock?(textField.text ?? "")
        }
        
        if tag == 2 {
            //电话
            self.editePhoneBlock?(textField.text ?? "")
        }
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 2 {
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
        }
        
      return true
    }
    
    
    @objc private func clickNextAction() {
        self.clickTimeBlock?("")
    }
    
}

