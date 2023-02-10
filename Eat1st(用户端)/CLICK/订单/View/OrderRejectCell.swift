//
//  OrderRejectCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/20.
//

import UIKit

class OrderRejectCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Reject Reason"
        return lab
    }()
    

    private let c_lab: UITextView = {
        let tf = UITextView()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.backgroundColor = HCOLOR("#F8F8F8")
        tf.isEditable = false
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    
    override func setViews() {
        
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(c_lab)
        c_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(40)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    func setCellData(model: OrderDetailModel) {
        
        if model.refuseReason != "" {
            self.tlab.text = "Reject reason"
            self.c_lab.text = model.refuseReason
        }
        
        if model.cancelReason != "" {
            self.tlab.text = "Cancel reason"
            self.c_lab.text = model.cancelReason
        }
    }
    

}
