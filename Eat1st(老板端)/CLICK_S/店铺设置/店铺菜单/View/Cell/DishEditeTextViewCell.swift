//
//  DishEditeTextViewCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/24.
//

import UIKit

class DishEditeTextViewCell: BaseTableViewCell, UITextViewDelegate {
    
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
    
    private lazy var inputTF: UITextView = {
        let tf = UITextView()
        tf.font = SFONT(14)
        tf.textColor = HCOLOR("333333")
        tf.delegate = self
        tf.backgroundColor = .clear
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
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-3)
        }
        
        
    }
    
    
    func setCellData(titStr: String, msgStr: String, isMust: Bool) {
        self.sLab.isHidden = !isMust
        
        self.titlab.text = titStr
        self.inputTF.text = msgStr
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.editeEndBlock?(textView.text ?? "")
    }

}
