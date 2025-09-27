//
//  DishesAndDeleteCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/19.
//

import UIKit

class DishesAndDeleteCell: BaseTableViewCell {
    
    var clickDeleteBlock: VoidBlock?

    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("delete"), for: .normal)
        return but
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.numberOfLines = 0
        lab.text = "芝麻大蝦吐司"
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        lab.text = "Sesame Prawn on Toast"
        return lab
    }()

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    func setCellData(name1: String, name2: String) {
        nameLab1.text = name1
        nameLab2.text = name2
    }
    
    @objc private func clickDeleteAction() {
        clickDeleteBlock?("")
    }
    
}



class InputTFCell: BaseTableViewCell, UITextFieldDelegate {
    
    var editeEndBlock: VoidStringBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 10
        return view
    }()


    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = TXT_1
        tf.textColor = TXTCOLOR_1
        tf.keyboardType = .numberPad
        tf.setPlaceholder("Please enter the number of days".local, color: TFHOLDCOLOR)
        tf.delegate = self
        return tf
    }()

    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        
    }
    
    
    func setCellData(msg: String) {
        inputTF.text = msg
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editeEndBlock?(self.inputTF.text ?? "")
    }

    
}


class SelectCell: BaseTableViewCell{
    
    var clickSelectBlock: VoidBlock?
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let xl: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_show")
        return img
    }()
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = TXT_1
        tf.textColor = TXTCOLOR_1
        tf.setPlaceholder("Please select a date.", color: TFHOLDCOLOR)
        tf.isUserInteractionEnabled = false
        return tf
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        
        backView.addSubview(xl)
        xl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
            $0.top.bottom.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(clickTapAction))
        backView.addGestureRecognizer(tap)
    }
    
    
    func setCellData(msg: String) {
        inputTF.text = msg
    }
    
    @objc private func clickTapAction() {
        clickSelectBlock?("")
    }
    
    
}
