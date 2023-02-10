//
//  AfterSalesInPutCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/24.
//

import UIKit

class AfterSalesInPutCell: BaseTableViewCell, UITextViewDelegate {
    
    
    var editeTextBlock: VoidBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.layer.cornerRadius = 10
        return view
    }()

    
    private lazy var inputTF: UITextView = {
        let tf = UITextView()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.backgroundColor = .clear
        tf.delegate = self
        return tf
    }()

    private let hlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "The complaint content"
        return lab
    }()

    
    
    override func setViews() {
        
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }

        
        tView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        

        inputTF.addSubview(hlab)
        hlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(5)
        }

    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text ?? ""  == "" {
            self.hlab.isHidden = false
        } else {
            self.hlab.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.editeTextBlock?(textView.text ?? "")
    }
    
    
    
    
    func setCellData(other: String) {
        self.inputTF.text = other
    
        if other  == "" {
            self.hlab.isHidden = false
        } else {
            self.hlab.isHidden = true
        }
    }


}
