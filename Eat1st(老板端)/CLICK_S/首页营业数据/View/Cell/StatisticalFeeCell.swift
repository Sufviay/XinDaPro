//
//  StatisticalFeeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/12/3.
//

import UIKit

class StatisticalFeeCell: BaseTableViewCell {

    
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
        view.isHidden = true
        return view
    }()
    
    private let line5: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
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
    
    private let de_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "£ 198.40"
        return lab
    }()
    
    
    private let or_ser_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("ser_fee")
        return img
    }()
    
    
    private let or_ser_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(10), .center)
        lab.numberOfLines = 0
        lab.text = "Order\nService Charge"
        return lab
    }()

    private let or_ser_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "£ 198.40"
        return lab
    }()
    
    
    private let dine_ser_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("ser_fee")
        img.isHidden = false
        return img
    }()
    
    
    private let dine_ser_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(10), .center)
        lab.numberOfLines = 0
        lab.text = "Dine-in\nService Charge"
        lab.isHidden = false
        return lab
    }()

    private let dine_ser_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "£ 198.40"
        lab.isHidden = false
        return lab
    }()


    private let bag_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("bag_fee")
        return img
    }()
    
    
    private let bag_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Bag fee"
        return lab
    }()
    
    

    private let bag_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "£ 198.40"
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
        lab.text = "Discount"
        return lab
    }()
    
    

    private let dis_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "£ 198.40"
        return lab
    }()
    
    
    private let tip_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_tip")
        return img
    }()
    
    
    private let tip_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .left)
        lab.text = "Tips"
        return lab
    }()
    
    

    private let tip_money: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .center)
        lab.text = "£ 198.40"
        return lab
    }()

    
    

    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(de_img)
        de_img.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.left).offset(S_W / 6)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(de_lab)
        de_lab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalTo(de_img)
        }

        contentView.addSubview(de_money)
        de_money.snp.makeConstraints {
            $0.centerX.equalTo(de_img)
            $0.top.equalTo(de_lab.snp.bottom).offset(5)
        }

        
        contentView.addSubview(or_ser_img)
        or_ser_img.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(or_ser_lab)
        or_ser_lab.snp.makeConstraints {
            $0.centerY.equalTo(de_lab)
            $0.centerX.equalTo(or_ser_img)
        }

        
        contentView.addSubview(or_ser_money)
        or_ser_money.snp.makeConstraints {
            $0.centerX.equalTo(or_ser_img)
            $0.centerY.equalTo(de_money)
        }
        
        
        contentView.addSubview(dine_ser_img)
        dine_ser_img.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.right).offset(-(S_W / 6))
            $0.centerY.equalTo(or_ser_img)

        }

        contentView.addSubview(dine_ser_lab)
        dine_ser_lab.snp.makeConstraints {
            $0.centerY.equalTo(or_ser_lab)
            $0.centerX.equalTo(dine_ser_img)
        }

        contentView.addSubview(dine_ser_money)
        dine_ser_money.snp.makeConstraints {
            $0.centerX.equalTo(dine_ser_img)
            $0.centerY.equalTo(or_ser_money)
        }
        
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(S_W / 3)
            $0.centerY.equalTo(de_lab)
            $0.size.equalTo(CGSize(width: 0.5, height: 30))
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.centerY.size.equalTo(line1)
            $0.right.equalToSuperview().offset(-(S_W / 3))
        }
        
        
        
        
        contentView.addSubview(bag_img)
        bag_img.snp.makeConstraints {
            $0.centerX.equalTo(de_img)
            $0.top.equalToSuperview().offset(90)
        }


        contentView.addSubview(bag_lab)
        bag_lab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115)
            $0.centerX.equalTo(bag_img)
        }


        contentView.addSubview(bag_money)
        bag_money.snp.makeConstraints {
            $0.centerX.equalTo(bag_img)
            $0.top.equalTo(bag_lab.snp.bottom).offset(5)
        }
        
        

        
        contentView.addSubview(dis_img)
        dis_img.snp.makeConstraints {
            $0.centerX.equalTo(or_ser_img)
            $0.centerY.equalTo(bag_img)
        }
        
        contentView.addSubview(dis_lab)
        dis_lab.snp.makeConstraints {
            $0.centerY.equalTo(bag_lab)
            $0.centerX.equalTo(dis_img)
            
        }

        contentView.addSubview(dis_money)
        dis_money.snp.makeConstraints {
            $0.centerX.equalTo(dis_img)
            $0.top.equalTo(dis_lab.snp.bottom).offset(5)
        }
        
        
        contentView.addSubview(tip_img)
        tip_img.snp.makeConstraints {
            $0.centerX.equalTo(dine_ser_img)
            $0.centerY.equalTo(dis_img)
        }
        
        contentView.addSubview(tip_lab)
        tip_lab.snp.makeConstraints {
            $0.centerY.equalTo(dis_lab)
            $0.centerX.equalTo(tip_img)
        }

        contentView.addSubview(tip_money)
        tip_money.snp.makeConstraints {
            $0.centerX.equalTo(tip_img)
            $0.centerY.equalTo(dis_money)
        }
        
        
//        contentView.addSubview(dine_ser_img)
//        dine_ser_img.snp.makeConstraints {
//            $0.centerX.equalTo(bag_img)
//            $0.centerY.equalTo(dis_img).offset(-5)
//        }
//
//        contentView.addSubview(dine_ser_lab)
//        dine_ser_lab.snp.makeConstraints {
//            $0.centerY.equalTo(dis_lab)
//            $0.centerX.equalTo(dine_ser_img)
//        }
//
//        contentView.addSubview(dine_ser_money)
//        dine_ser_money.snp.makeConstraints {
//            $0.centerX.equalTo(dine_ser_img)
//            $0.centerY.equalTo(dis_money)
//        }

        

        contentView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.centerX.size.equalTo(line1)
            $0.centerY.equalTo(dis_lab)
        }
        
        contentView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.centerX.size.equalTo(line2)
            $0.centerY.equalTo(line3)
        }


        contentView.addSubview(line5)
        line5.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }

    }
    
    
    func setCellData(model: ReportModel) {
        self.de_money.text = "£\(D_2_STR(model.deliveryFee))"
        self.or_ser_money.text = "£\(D_2_STR(model.platServiceFee))"
        self.dine_ser_money.text = "£\(D_2_STR(model.dineServiceFee))"
        self.bag_money.text = "£\(D_2_STR(model.packFee))"
        self.dis_money.text = "£\(D_2_STR(model.discountPrice))"
        self.tip_money.text = "£\(D_2_STR(model.tipsPrice))"
    }
    
}
