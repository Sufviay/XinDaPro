//
//  DataInfoCell_Other.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/5/7.
//

import UIKit

class DataInfoCell_Other: UICollectionViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_5
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "未结账收入"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    private let numberlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#222222"), NUMFONT_2, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "9999"
        return lab
    }()
    
//    private let refundLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#333333"), BFONT(12), .left)
//        return lab
//    }()
    
    
//    private let tlab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#AAAAAA"), TXT_1, .left)
//        lab.text = "上周二"
//        lab.isHidden = true
//        return lab
//    }()
    
    private let tblab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#E9522F"), TXT_1, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "99999"
        lab.isHidden = true
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(numberlab)
        numberlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(35)
            //$0.top.equalTo(titlab.snp.bottom).offset(3)
        }
        
//        backView.addSubview(refundLab)
//        refundLab.snp.makeConstraints {
//            $0.top.equalTo(numberlab.snp.bottom).offset(0)
//            $0.left.equalToSuperview().offset(15)
//        }
        
//        backView.addSubview(tlab)
//        tlab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(15)
//            //$0.width.equalTo(50)
//            $0.bottom.equalToSuperview().offset(-15)
//        }
//        
        
        backView.addSubview(tblab)
        tblab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-15)
            $0.right.equalToSuperview().offset(-10)
            //$0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(titStr: String, number: String, compareNum: String, floatingType: String, week: String) {
        
        titlab.text = titStr
    
        //已返回
        numberlab.text = number
        numberlab.textColor = HCOLOR("#222222")
        tblab.isHidden = false
        
        tblab.text = "Last ".local + week + " " + compareNum
        
        //（1上涨，2相等，3下降）
        if floatingType == "1" || floatingType == "2" || floatingType == "" {
            tblab.textColor = HCOLOR("#E9522F")
        } else {
            tblab.textColor = HCOLOR("#19B366")
        }

    }

    
    
    
}
