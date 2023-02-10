//
//  EditeAddressController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/27.
//

import UIKit
import RxSwift

class EditeAddressController: BaseViewController, UITextViewDelegate, SystemAlertProtocol, UITextFieldDelegate {
    

    
    var isNew: Bool = true 
    
    var addressModel = AddressModel() {
        didSet {
            self.nameTF.text = addressModel.receiver
            self.phoneTF.text = addressModel.phone
            self.postcodeTF.text = addressModel.postcode
            self.addressTF.text = addressModel.address
            self.detailTF.text = addressModel.detail
            self.lng = addressModel.lng
            self.lat = addressModel.lat
            self.isDefault = addressModel.isDefault
            //self.postCode = addressModel.postcode
            if addressTF.text != "" {
                self.a_Lab.isHidden = true
            } else {
                self.a_Lab.isHidden = false
            }
            
            if detailTF.text != "" {
                self.d_Lab.isHidden = true
            } else {
                self.d_Lab.isHidden = false
            }
        }
    }
    
    private let bag = DisposeBag()
    
    private var lat: String = ""
    private var lng: String = ""
    
    private var isDefault: Bool = false {
        didSet {
            if isDefault {
                self.defaultBut.setImage(LOIMG("sel"), for: .normal)
            } else {
                self.defaultBut.setImage(LOIMG("unsel"), for: .normal)
            }
        }
    }
    
    private lazy var alertView: AddressAlertView = {
        let alert = AddressAlertView()
        return alert
    }()
    

    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Name:"
        return lab
    }()
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "phone:"
        return lab
    }()
    
    private let postCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Postcode:"
        return lab
    }()

    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Address:"
        return lab
    }()
    
    private let detailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "House number:"
        return lab
    }()

    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString.init(string:"Enter the name", attributes: [
            NSAttributedString.Key.foregroundColor:HCOLOR("#999999")])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        return tf
    }()
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()

        tf.attributedPlaceholder = NSAttributedString.init(string:"Enter the phone", attributes: [
            NSAttributedString.Key.foregroundColor:HCOLOR("#999999")])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.delegate = self
        return tf
    }()
    
    
    private lazy var postcodeTF: UITextField = {
        let tf = UITextField()

        tf.attributedPlaceholder = NSAttributedString.init(string:"Enter the postcode", attributes: [
            NSAttributedString.Key.foregroundColor:HCOLOR("#999999")])
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        return tf
    }()

    
    
    private lazy var addressTF: UITextView = {
        let view = UITextView()
        view.backgroundColor = .white
        view.textColor = FONTCOLOR
        view.font = SFONT(14)
        view.delegate = self
        view.tag = 1
        return view
    }()
    
    private let a_Lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "Enter the address"
        return lab
    }()
    
    private lazy var detailTF: UITextView = {
        let view = UITextView()
        view.backgroundColor = .white
        view.textColor = FONTCOLOR
        view.font = SFONT(14)
        view.tag = 2
        view.delegate = self
        return view
    }()
    
    private let d_Lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "Fill in the house number"
        return lab
    }()
    
    

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "save", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_but"), for: .normal)
        return but
    }()
    
    private let defaultLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Set as delivery address"
        return lab
    }()
    
    private let defaultBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("unsel"), for: .normal)
        return but
    }()
    

    
    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("F7F7F7")
        setUpUI()
    }
    

    
    private let butTitleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Delete the address"
        return lab
    }()

    
    
    
    override func setNavi() {
        
        if !isNew {
            self.naviBar.headerTitle = "Edit address"
        } else {
            self.naviBar.headerTitle = "New address"
            
        }
        
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightImg = LOIMG("nav_delete")
        self.naviBar.rightBut.isHidden = isNew
        
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func clickRightButAction() {
        // 删除地址
        self.showSystemChooseAlert("Alert", "Are you sure you want to delete it?", "YES", "NO") {
            self.deleteAddress_Net()
        }
    }
    


    private func setUpUI() {
        
        
        view.backgroundColor = .white
    
        
        let line = UIView()
        line.backgroundColor = HCOLOR("#F7F7F7")
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(7)
            $0.top.equalTo(naviBar.snp.bottom).offset(0)
        }
        
        
        
        view.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(45)
        }

        
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(15)
        }
        
        view.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line.snp.bottom).offset(65)
        }
        
        view.addSubview(postCodeLab)
        postCodeLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line.snp.bottom).offset(115)
        }
        
        view.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(line.snp.bottom).offset(165)
        }
        
        view.addSubview(detailLab)
        detailLab.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(245)
            $0.left.equalTo(nameLab)
        }
        
        
        
        
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(40)
            $0.centerY.equalTo(nameLab)
        }
        
        view.addSubview(phoneTF)
        phoneTF.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerY.equalTo(phoneLab)
            $0.left.right.equalTo(nameTF)
        }
        
        view.addSubview(postcodeTF)
        postcodeTF.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerY.equalTo(postCodeLab)
            $0.left.right.equalTo(nameTF)
        }
        
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(postCodeLab)
            $0.right.equalToSuperview().offset(-10)
        }
    
        
        view.addSubview(addressTF)
        addressTF.snp.makeConstraints {
            $0.right.equalTo(nameTF)
            $0.left.equalTo(nameTF).offset(-5)
            $0.top.equalTo(addressLab).offset(-5)
            $0.bottom.equalTo(detailLab.snp.top).offset(-5)
        }
        
        addressTF.addSubview(a_Lab)
        a_Lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(8)
        }
        
        
        view.addSubview(detailTF)
        detailTF.snp.makeConstraints {
            $0.left.equalTo(detailLab)
            $0.top.equalTo(detailLab.snp.bottom).offset(0)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
            //$0.bottom.equalToSuperview().offset(-15)
        }
        
        detailTF.addSubview(d_Lab)
        d_Lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(8)
        }
        
        
        view.addSubview(defaultLab)
        defaultLab.snp.makeConstraints {
            $0.left.equalTo(detailLab)
            $0.top.equalTo(detailTF.snp.bottom).offset(10)
        }
        
        view.addSubview(defaultBut)
        defaultBut.snp.makeConstraints {
            $0.centerY.equalTo(defaultLab)
            $0.size.equalTo(CGSize(width: 60, height: 40))
            $0.right.equalToSuperview().offset(0)
        }
        
    

        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAddressAction))
        postcodeTF.addGestureRecognizer(tap)
        defaultBut.addTarget(self, action: #selector(clickDefaultAciton), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickAddressAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    @objc private func clickAddressAction() {
        SearchPlaceManager.shared.doSearchPlace { (model) in
            if model.address != "" {
                self.a_Lab.isHidden = true
            } else {
                self.a_Lab.isHidden = false
            }
            self.addressTF.text = model.address
            
            self.postcodeTF.text = model.postCode
            self.lng = model.lng
            self.lat = model.lat
        }
    }
    
    @objc func clickDefaultAciton() {
        isDefault = !isDefault
    }
    
    @objc private func clickSaveAction() {
        
        if nameTF.text == "" {
            HUD_MB.showWarnig("Please fill in your name", onView: self.view)
            return
        }
        
        if phoneTF.text == "" {
            HUD_MB.showWarnig("Please fill in your phone", onView: self.view)
            return
        }
        
        if postcodeTF.text == "" {
            HUD_MB.showWarnig("Please fill in postcode", onView: self.view)
            return
        }
        
//        if addressTF.text == "" {
//            HUD_MB.showWarnig("Please fill in your address", onView: self.view)
//            return
//        }
        
        if detailTF.text == "" {
            HUD_MB.showWarnig("Please fill in  the house number", onView: self.view)
            return
        }
        
        self.editeAddress_Net()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let tag = textView.tag
        
        if tag == 1 {
            if textView.text ?? "" != "" {
                self.a_Lab.isHidden = true
            } else {
                self.a_Lab.isHidden = false
            }
        }
        
        if tag == 2 {
            if textView.text ?? "" != "" {
                self.d_Lab.isHidden = true
            } else {
                self.d_Lab.isHidden = false
            }
        }
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
    
    
    //MARK: - 网络请求
    
    ///添加新地址
    private func editeAddress_Net() {

        HUD_MB.loading("", onView: view)
        
        let defaultOrNot = isDefault ? "2" : "1"
        
        HTTPTOOl.editeAddress(address: addressTF.text!, postCode: postcodeTF.text!, phone: phoneTF.text!, receiver: nameTF.text!, lat: self.lat, lng: self.lng, id: addressModel.id, detail: self.detailTF.text ?? "", defaultOrNot: defaultOrNot).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    private func deleteAddress_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteAddress(id: addressModel.id).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }

}
