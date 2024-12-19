//
//  OccupyPersonInfoCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit

class OccupyPersonInfoCell: BaseTableViewCell, UITextFieldDelegate {

    var editNameBlock: VoidStringBlock?
    var editPhoneBlock: VoidStringBlock?
    //var editEmailBlock: VoidStringBlock?
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "Name："
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "Phone Number："
        return lab
    }()
    
//    private let tlab3: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
//        lab.text = "Email："
//        return lab
//    }()

    
    private lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = BFONT(16)
        tf.tag = 1
        tf.delegate = self
        tf.setPlaceholder("Fill in the name", color: HCOLOR("#BBBBBB"))
        return tf
    }()
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = BFONT(16)
        tf.keyboardType = .numberPad
        tf.setPlaceholder("Fill in the phone number", color: HCOLOR("#BBBBBB"))
        tf.tag = 2
        tf.delegate = self
        return tf
    }()
    
    
//    private lazy var emailTF: UITextField = {
//        let tf = UITextField()
//        tf.textColor = FONTCOLOR
//        tf.font = BFONT(16)
//        tf.setPlaceholder("Fill in the email", color: HCOLOR("#BBBBBB"))
//        tf.tag = 3
//        tf.delegate = self
//        return tf
//    }()

    
    
    override func setViews() {
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab1.snp.bottom).offset(20)
        }
        
//        contentView.addSubview(tlab3)
//        tlab3.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.top.equalTo(tlab2.snp.bottom).offset(20)
//        }
        

        
        contentView.addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(80)
            $0.centerY.equalTo(tlab1)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(130)
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
//        contentView.addSubview(emailTF)
//        emailTF.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(130)
//            $0.centerY.equalTo(tlab3)
//            $0.right.equalToSuperview().offset(-20)
//            $0.height.equalTo(40)
//        }

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            editNameBlock?(textField.text ?? "")
        }
        if textField.tag == 2 {
            editPhoneBlock?(textField.text ?? "")
        }
//        if textField.tag == 3 {
//            editEmailBlock?(textField.text ?? "")
//        }
        
    }
    
    
    func setCellData(model: OccupyModel) {
        nameTF.text = model.name
        phoneTF.text = model.phone
    }
    
}
