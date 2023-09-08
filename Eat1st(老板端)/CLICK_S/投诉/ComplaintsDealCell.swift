//
//  ComplaintsDealCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/18.
//

import UIKit


class ComplaintsTitleCell: BaseTableViewCell {
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(14), .left)
        lab.text = "Processing mode"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .left)
        lab.text = "*"
        return lab
    }()
    
    
    override func setViews() {
            
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLab.snp.right).offset(2)
        }
    }
    
    
}


class ComplaintsDealCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
    
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Treatment method 2"
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    

    override func setViews() {
        
//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-20)
//            $0.height.equalTo(0.5)
//            $0.bottom.equalToSuperview()
//        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-60)
        }
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        
        
    }

    
    func setCellData(title: String, selected: Bool) {
        titLab.text = title
        if selected {
            selectImg.image = LOIMG("busy_sel_b")
        } else {
            selectImg.image = LOIMG("busy_unsel_b")
        }
    }

}



class ComplaintsDealInputCell: BaseTableViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#CCCCCC"), BFONT(14), .left)
        lab.text = "Reply from the merchant:"
        return lab
    }()
    
    private let inputTF: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .clear
        tf.textColor = HCOLOR("#333333")
        tf.font = SFONT(14)
        return tf
    }()
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-5)
            $0.top.equalToSuperview().offset(30)
        }
                
    }
    
    
}
