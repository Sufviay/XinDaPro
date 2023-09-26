//
//  JuJieInputCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/10.
//

import UIKit

class JuJieInputCell: BaseTableViewCell, UITextViewDelegate {
    
    var editeTextBlock: VoidBlock?
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    

    private lazy var inputTF: UITextView = {
        let view = UITextView()
        view.textColor = FONTCOLOR
        view.font = SFONT(14)
        view.delegate = self
        return view
    }()

    
    
    private let holderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "Fill in other details"
        return lab
    }()

    


    
    
    override func setViews() {
        
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }

        inputTF.addSubview(holderLab)
        holderLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(10)
        }

    }
    
        

    func textViewDidChange(_ textView: UITextView) {
        if textView.text ?? "" != "" {
            self.holderLab.isHidden = true
        } else {
            self.holderLab.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.editeTextBlock?(textView.text ?? "")
    }
        
    func setCellData(str: String) {
        self.inputTF.text = str
        
        if str != "" {
            self.holderLab.isHidden = true
        } else {
            self.holderLab.isHidden = false
        }

    }
    
}
