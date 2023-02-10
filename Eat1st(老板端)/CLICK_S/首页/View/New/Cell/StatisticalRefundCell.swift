//
//  StatisticalRefundCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/12/5.
//

import UIKit

class StatisticalRefundCell: BaseTableViewCell {
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let refundMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .center)
        lab.text = "£17.89"
        return lab
    }()
    
    private let refundNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(17), .center)
        lab.text = "10"
        return lab
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Amount of refund"
        return lab
    }()
    
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Refund orders"
        return lab
    }()
    
    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_refund_money")
        return img
    }()
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_refund_order")
        return img
    }()

    

    

    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 28))
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(refundMoney)
        refundMoney.snp.makeConstraints {
            $0.right.equalTo(line1.snp.left).offset(0)
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(refundNum)
        refundNum.snp.makeConstraints {
            $0.bottom.equalTo(refundMoney)
            $0.left.equalTo(line1.snp.right).offset(0)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerX.equalTo(refundMoney).offset(20)
            $0.bottom.equalTo(refundMoney.snp.top).offset(-10)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerX.equalTo(refundNum).offset(20)
            $0.centerY.equalTo(tlab1)
        }
        
        contentView.addSubview(img1)
        img1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 22, height: 19))
            $0.centerY.equalTo(tlab1)
            $0.right.equalTo(tlab1.snp.left).offset(-5)
        }
        
        contentView.addSubview(img2)
        img2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 22))
            $0.centerY.equalTo(tlab2)
            $0.right.equalTo(tlab2.snp.left).offset(-5)
        }

    }
    
    
    func setCellData(money: Double, num: Int) {
        self.refundMoney.text = "£\(D_2_STR(money))"
        self.refundNum.text = "\(num)"
    }
    
    
}
