//
//  OrderInputCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit

class OrderInputCell: BaseTableViewCell, UITextFieldDelegate {


    var clickAddressBlock: VoidBlock?
    
    var editeNameBlock: VoidBlock?
    
    var editePhoneBlock: VoidBlock?
    
    var editeDoorNumBlock: VoidBlock?

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
    
    private let localImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_local")
        return img
    }()
    
    private let phoneImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_phone")
        return img
    }()
    
    private let doorImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_doorNum")
        return img
    }()
    
    private let timeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_time")
        return img
    }()
    
    private lazy var nameInputTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Name", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])

        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.tag = 1
        tf.delegate = self
        return tf
    }()
    
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Phone number", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.tag = 2
        tf.delegate = self
        return tf
    }()
    
    
    
    private lazy var addressInputTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Address and Postcode", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    
    private lazy var doorTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"House number", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.tag = 3
        tf.delegate = self
        return tf
    }()

    
    private lazy var timeTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Expected time", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    private let addressNextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        return but
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
        
        backView.addSubview(localImg)
        localImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(phoneImg.snp.bottom).offset(25)
        }
        
        backView.addSubview(doorImg)
        doorImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(localImg.snp.bottom).offset(25)
        }
        
        backView.addSubview(timeImg)
        timeImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(doorImg.snp.bottom).offset(25)
        }
    
        backView.addSubview(nameInputTF)
        nameInputTF.snp.makeConstraints {
            $0.centerY.equalTo(nameImg)
            $0.height.equalTo(44)
            $0.left.equalTo(nameImg.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-50)
        }
        
        backView.addSubview(addressInputTF)
        addressInputTF.snp.makeConstraints {
            $0.left.equalTo(nameInputTF)
            $0.centerY.equalTo(localImg)
            $0.height.equalTo(nameInputTF)
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
        
        backView.addSubview(doorTF)
        doorTF.snp.makeConstraints {
            $0.centerY.equalTo(doorImg)
            $0.left.size.equalTo(nameInputTF)
        }
        
        backView.addSubview(addressNextBut)
        addressNextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(localImg)
            $0.right.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(timeBut)
        timeBut.snp.makeConstraints {
            $0.right.size.equalTo(addressNextBut)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAddressAction))
        addressInputTF.addGestureRecognizer(tap)
        
        addressNextBut.addTarget(self, action: #selector(clickAddressAction), for: .touchUpInside)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clickTimeAction))
        timeTF.addGestureRecognizer(tap2)
        
        timeBut.addTarget(self, action: #selector(clickTimeAction), for: .touchUpInside)
    }
    
    @objc private func clickAddressAction() {
        clickAddressBlock?("")
    }
    
    @objc private func clickTimeAction() {
        self.clickTimeBlock?("")
    }

    
    
    func setCellData(name: String, phone: String, address: String, doorNum: String, time: String, isCanEdite: Bool, minTime: String, maxTime: String, ydMsg: String) {
        self.nameInputTF.text = name
        self.phoneTF.text = phone
        self.addressInputTF.text = address
        self.timeTF.text = time
        self.doorTF.text = doorNum

        addressNextBut.isEnabled = isCanEdite
        addressInputTF.isUserInteractionEnabled = isCanEdite
        timeBut.isEnabled = isCanEdite
        timeTF.isUserInteractionEnabled = isCanEdite
        nameInputTF.isEnabled = isCanEdite
        phoneTF.isEnabled = isCanEdite
        doorTF.isEnabled = isCanEdite
        
//        if busyType == "1" {
//            //是
//            self.alertLab.isHidden = false
//        } else {
//            self.alertLab.isHidden = true
//        }
        
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
        
        if tag == 3 {
            //门牌号
            self.editeDoorNumBlock?(textField.text ?? "")
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

    

    
    
}




class OrderListInputCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Your Details"
        return lab
    }()
    
    private let nameImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_name")
        return img
    }()
    
    private let localImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_local")
        return img
    }()
    
    private let phoneImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_phone")
        return img
    }()
    
    private let doorImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_doorNum")
        return img
    }()

    
    private let timeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_time")
        return img
    }()
    
    private lazy var nameInputTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Name", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Phone number", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    
    
    private lazy var addressInputTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Address and Postcode", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    
    private lazy var doorTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"House number", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    
    private lazy var timeTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Expected time", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    private let addressNextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        but.isEnabled = false
        return but
    }()
    
    private let timeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        but.isEnabled = false
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
        
        backView.addSubview(localImg)
        localImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(phoneImg.snp.bottom).offset(25)
        }
        
        backView.addSubview(doorImg)
        doorImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(localImg.snp.bottom).offset(25)
        }
        
        backView.addSubview(timeImg)
        timeImg.snp.makeConstraints {
            $0.left.size.equalTo(nameImg)
            $0.top.equalTo(doorImg.snp.bottom).offset(25)
        }

    
        backView.addSubview(nameInputTF)
        nameInputTF.snp.makeConstraints {
            $0.centerY.equalTo(nameImg)
            $0.height.equalTo(44)
            $0.left.equalTo(nameImg.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-50)
        }
        
        backView.addSubview(addressInputTF)
        addressInputTF.snp.makeConstraints {
            $0.left.equalTo(nameInputTF)
            $0.centerY.equalTo(localImg)
            $0.height.equalTo(nameInputTF)
            $0.right.equalToSuperview().offset(-50)
        }
        
        backView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints {
            $0.left.size.equalTo(nameInputTF)
            $0.centerY.equalTo(phoneImg)
        }
        
        backView.addSubview(doorTF)
        doorTF.snp.makeConstraints {
            $0.centerY.equalTo(doorImg)
            $0.left.size.equalTo(nameInputTF)
        }
        
        
        backView.addSubview(timeTF)
        timeTF.snp.makeConstraints {
            $0.centerY.equalTo(timeImg)
            $0.left.size.equalTo(nameInputTF)
        }
        
        backView.addSubview(addressNextBut)
        addressNextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(localImg)
            $0.right.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(timeBut)
        timeBut.snp.makeConstraints {
            $0.right.size.equalTo(addressNextBut)
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
        
    }
    
    
    func setCellData(name: String, phone: String, address: String, doorNum: String, time: String, minTime: String, maxTime: String, ydMsg: String) {
        self.nameInputTF.text = name
        self.phoneTF.text = phone
        self.addressInputTF.text = address
        self.timeTF.text = time
        self.doorTF.text = doorNum

        
        if ydMsg == "" {
            self.alertLab.text = "Estimated time \(minTime)-\(maxTime)"
        } else {
            self.alertLab.text = ydMsg
        }
        
    }
    
    

    
    
}
