//
//  StatisticalFeeNumCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/12/26.
//

import UIKit

class StatisticalFeeNumCell: BaseTableViewCell {


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
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let coup_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("fee")
        return img
    }()
    
    private let coup_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Credit coupon"
        return lab
    }()
    
    private let coup_num: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let tipCash_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_tip")
        return img
    }()
    
    
    private let tipCash_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Cash tips"
        return lab
    }()
    

    private let tipCash_num: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let tipPos_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_tip")
        return img
    }()
    
    
    private let tipPos_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Pos tips"
        return lab
    }()
    

    private let tipPos_num: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()

    
    private let dis_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_zk")
        return img
    }()
    
    
    private let dis_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Checkout discount"
        return lab
    }()
    
    

    private let dis_num: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(coup_img)
        coup_img.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.left).offset(S_W / 6)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(coup_lab)
        coup_lab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalTo(coup_img)
        }

        contentView.addSubview(coup_num)
        coup_num.snp.makeConstraints {
            $0.centerX.equalTo(coup_img)
            $0.top.equalTo(coup_lab.snp.bottom).offset(5)
        }
        
        
        contentView.addSubview(tipCash_img)
        tipCash_img.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(coup_img)
        }
        
        contentView.addSubview(tipCash_lab)
        tipCash_lab.snp.makeConstraints {
            $0.centerY.equalTo(coup_lab)
            $0.centerX.equalTo(tipCash_img)
        }

        contentView.addSubview(tipCash_num)
        tipCash_num.snp.makeConstraints {
            $0.centerX.equalTo(tipCash_img)
            $0.centerY.equalTo(coup_num)
        }
        
        
        contentView.addSubview(tipPos_img)
        tipPos_img.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.right).offset(-(S_W / 6))
            $0.centerY.equalTo(coup_img)
        }

        contentView.addSubview(tipPos_lab)
        tipPos_lab.snp.makeConstraints {
            $0.centerY.equalTo(coup_lab)
            $0.centerX.equalTo(tipPos_img)
        }

        contentView.addSubview(tipPos_num)
        tipPos_num.snp.makeConstraints {
            $0.centerX.equalTo(tipPos_img)
            $0.centerY.equalTo(coup_num)
        }
        
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(S_W / 3)
            $0.centerY.equalTo(coup_lab)
            $0.size.equalTo(CGSize(width: 0.5, height: 30))
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.centerY.size.equalTo(line1)
            $0.right.equalToSuperview().offset(-(S_W / 3))
        }
        
        
        contentView.addSubview(dis_img)
        dis_img.snp.makeConstraints {
            $0.centerX.equalTo(coup_img)
            $0.top.equalToSuperview().offset(90)
        }


        contentView.addSubview(dis_lab)
        dis_lab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115)
            $0.centerX.equalTo(dis_img)
        }


        contentView.addSubview(dis_num)
        dis_num.snp.makeConstraints {
            $0.centerX.equalTo(dis_img)
            $0.top.equalTo(dis_lab.snp.bottom).offset(5)
        }

        
        contentView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }

    }
    
    
    func setCellData(model: ReportModel) {
        coup_num.text = "\(model.cashCouponNum)"
        tipCash_num.text = "\(model.tipCashNum)"
        tipPos_num.text = "\(model.tipPosNum)"
        dis_num.text = "\(model.discountNum)"
        
    }
    

}
