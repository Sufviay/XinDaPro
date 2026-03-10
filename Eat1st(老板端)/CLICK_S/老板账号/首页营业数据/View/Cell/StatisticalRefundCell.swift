//
//  StatisticalRefundCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/12/5.
//

import UIKit

class StatisticalRefundCell: BaseTableViewCell {
    
    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_refund_money")
        return img
    }()

    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Amount of refund"
        return lab
    }()

    private let refundMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "£17.89"
        return lab
    }()
    
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_refund_order")
        return img
    }()

    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Refund orders"
        return lab
    }()

    
    private let refundNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "10"
        return lab
    }()

    
    
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
    

    
    

    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(img1)
        img1.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.left).offset(S_W / 6)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalTo(img1)
        }

        contentView.addSubview(refundMoney)
        refundMoney.snp.makeConstraints {
            $0.centerX.equalTo(img1)
            $0.top.equalTo(tlab1.snp.bottom).offset(2)
        }

        contentView.addSubview(img2)
        img2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(img1)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerX.equalTo(img2)
            $0.centerY.equalTo(tlab1)
        }
        
        
        contentView.addSubview(refundNum)
        refundNum.snp.makeConstraints {
            $0.centerX.equalTo(img2)
            $0.centerY.equalTo(refundMoney)
        }


        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(S_W / 3)
            $0.centerY.equalTo(tlab1)
            $0.size.equalTo(CGSize(width: 0.5, height: 30))
        }

                
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }

    }
    
    
    func setCellData(money: Double, num: Int) {
        self.refundMoney.text = "£\(D_2_STR(money))"
        self.refundNum.text = "\(num)"
    }
    
    
}
