//
//  OrderRemarkCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/10.
//

import UIKit

class OrderRemarkCell: BaseTableViewCell, UITextViewDelegate {
    
    var editedBlock: VoidBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "Special Instruction"
        return lab
    }()
    
    private lazy var remarkTF: UITextView = {
        let tv = UITextView()
        tv.textColor = FONTCOLOR
        tv.backgroundColor = .white
        tv.font = SFONT(14)
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        return tv
    }()

    
    private let holdLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "For Example,”Please leave my order outside my door and ring or knock to let me know it’s been delivered.”  Do not include details about allergies here"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    
     
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(remarkTF)
        remarkTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        remarkTF.addSubview(holdLab)
        holdLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.width.equalTo(S_W - 50)
            $0.top.equalToSuperview().offset(5)
        }
        
    }
    
    
    func setCellData(cStr: String, isCanEdite: Bool) {
        self.remarkTF.text = cStr
        self.remarkTF.isEditable = isCanEdite
        
        if cStr == "" {
            self.holdLab.isHidden = false
        } else {
            self.holdLab.isHidden = true
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.holdLab.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text ?? "" == "" {
            self.holdLab.isHidden = false
        } else {
            self.holdLab.isHidden = true
        }
        self.editedBlock?(textView.text ?? "")
    }
    
}
