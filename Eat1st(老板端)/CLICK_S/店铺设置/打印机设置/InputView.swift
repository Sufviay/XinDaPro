//
//  InputView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/6/14.
//

import UIKit

class InputView: UIView, UITextFieldDelegate {
    
    
    var editBlock: VoidStringBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        lab.text = "Printer name"
        return lab
    }()
    
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    
    private let tfBack: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(15)
        tf.delegate = self
        return tf
    }()
    

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
        }

        
        addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right)
        }
        
        
        addSubview(tfBack)
        tfBack.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(titlab.snp.bottom).offset(5)
        }
        
        
        tfBack.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func setStyle(titStr: String, holderStr: String) {
        titlab.text = titStr
        inputTF.placeholder = holderStr
        //inputTF.text = tfStr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editBlock?(textField.text ?? "")
    }
    
    
}
