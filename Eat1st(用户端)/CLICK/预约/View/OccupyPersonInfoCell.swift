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
    
    private lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = BFONT(16)
        tf.tag = 1
        tf.delegate = self
        return tf
    }()
    
    private lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = BFONT(16)
        tf.keyboardType = .numberPad
        tf.tag = 2
        tf.delegate = self
        return tf
    }()
    
    
    
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
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            editNameBlock?(textField.text ?? "")
        }
        if textField.tag == 2 {
            editPhoneBlock?(textField.text ?? "")
        }
    }
    
    
    func setCellData(model: OccupyModel) {
        nameTF.text = model.name
        phoneTF.text = model.phone
    }
    
}
