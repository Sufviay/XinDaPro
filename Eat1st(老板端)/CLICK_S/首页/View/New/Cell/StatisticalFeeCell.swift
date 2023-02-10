//
//  StatisticalFeeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/12/3.
//

import UIKit

class StatisticalFeeCell: BaseTableViewCell {

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let ser_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("ser_fee")
        return img
    }()
    
    private let bag_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("bag_fee")
        return img
    }()
    
    private let de_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("de_fee")
        return img
    }()
    
    private let de_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Delivery fee"
        return lab
    }()

    private let ser_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Service fee"
        return lab
    }()
    
    private let bag_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Bag fee"
        return lab
    }()
    
    private let ser_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "£ 198.40"
        return lab
    }()
    
    private let de_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "£ 198.40"
        return lab
    }()

    private let bag_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "£ 198.40"
        return lab
    }()


    
    

    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
                
        
        contentView.addSubview(de_money)
        de_money.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(S_W / 3)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(ser_money)
        ser_money.snp.makeConstraints {
            $0.width.equalTo(S_W / 3)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(de_money)
        }
        
        contentView.addSubview(bag_money)
        bag_money.snp.makeConstraints {
            $0.width.equalTo(S_W / 3)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(de_money)
        }
        
        contentView.addSubview(bag_lab)
        bag_lab.snp.makeConstraints {
            $0.bottom.equalTo(bag_money.snp.top).offset(-10)
            $0.centerX.equalTo(bag_money).offset(15)
        }
        
        contentView.addSubview(bag_img)
        bag_img.snp.makeConstraints {
            $0.centerY.equalTo(bag_lab)
            $0.right.equalTo(bag_lab.snp.left).offset(-5)
            $0.size.equalTo(CGSize(width: 17, height: 21))
        }
        
        
        contentView.addSubview(de_lab)
        de_lab.snp.makeConstraints {
            $0.centerY.equalTo(bag_lab)
            $0.centerX.equalTo(de_money).offset(15)
        }


        contentView.addSubview(de_img)
        de_img.snp.makeConstraints {
            $0.centerY.equalTo(bag_lab)
            $0.size.equalTo(CGSize(width: 28, height: 22))
            $0.right.equalTo(de_lab.snp.left).offset(-5)
        }
        
        contentView.addSubview(ser_lab)
        ser_lab.snp.makeConstraints {
            $0.centerY.equalTo(bag_lab)
            $0.centerX.equalTo(ser_money).offset(15)
        }
        
        contentView.addSubview(ser_img)
        ser_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 21, height: 21))
            $0.centerY.equalTo(bag_lab)
            $0.right.equalTo(ser_lab.snp.left).offset(-5)
        }
    }
    
    
    func setCellData(de_fee: Double, ser_fee: Double, bag_fee: Double) {
        self.de_money.text = "£\(D_2_STR(de_fee))"
        self.ser_money.text = "£\(D_2_STR(ser_fee))"
        self.bag_money.text = "£\(D_2_STR(bag_fee))"
    }
    
}
