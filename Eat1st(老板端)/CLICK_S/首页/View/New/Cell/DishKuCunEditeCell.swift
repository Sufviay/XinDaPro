//
//  DishKuCunEditeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/8/12.
//

import UIKit

class DishKuCunEditeCell: BaseTableViewCell, UITextFieldDelegate {
    
    
    ///（1否，2是）
    var type: String = "" {
        didSet {
            if type == "1" {
                //不限购
                self.limitedImg.image = LOIMG("busy_unsel_b")
                self.unlimitedImg.image = LOIMG("busy_sel_b")
                self.tfBackView.isHidden = true
                
            }
            if type == "2" {
                //限购
                self.limitedImg.image = LOIMG("busy_sel_b")
                self.unlimitedImg.image = LOIMG("busy_unsel_b")
                self.tfBackView.isHidden = false
            }
        }
    }
    
    var number: String = ""
    
    
    var clickTypeBlock: VoidStringBlock?
    var editeNumBlock: VoidStringBlock?
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Stock"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    private let unlimitedBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()

    
    private let unlimitedImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let unlimitedLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Disable"
        return lab
    }()
    
    
    private let limitedBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()

    
    private let limitedImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let limitedLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Enable"
        return lab
    }()

    
    private let tfBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Fill in the remaining quantity in stock"
        tf.keyboardType = .numberPad
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.delegate = self
        return tf
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(unlimitedBut)
        unlimitedBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(40)
            $0.top.equalTo(titlab.snp.bottom).offset(10)
        }

        
        contentView.addSubview(limitedBut)
        limitedBut.snp.makeConstraints {
            $0.width.top.height.equalTo(unlimitedBut)
            $0.right.equalToSuperview()
        }
        
        unlimitedBut.addSubview(unlimitedImg)
        unlimitedImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
        }
        
        unlimitedBut.addSubview(unlimitedLab)
        unlimitedLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(42)
        }
        
        limitedBut.addSubview(limitedImg)
        limitedImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
        }
        
        limitedBut.addSubview(limitedLab)
        limitedLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(32)
        }
        
        contentView.addSubview(tfBackView)
        tfBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(limitedBut.snp.bottom).offset(10)
        }
        
        tfBackView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        unlimitedBut.addTarget(self, action: #selector(clickUnlimitedAciton), for: .touchUpInside)
        limitedBut.addTarget(self, action: #selector(clicklimitedAciton), for: .touchUpInside)
        
    
    }
    
    @objc private func clickUnlimitedAciton() {
        if type != "1" {
            clickTypeBlock?("1")
        }
        
        
    }
    
    
    @objc private func clicklimitedAciton() {
        if type != "2" {
            clickTypeBlock?("2")
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.editeNumBlock?(textField.text ?? "")
    }
    
    
    func setCellData(type: String, number: String) {
        self.inputTF.text = number
        self.type = type
    
    }
    

}
