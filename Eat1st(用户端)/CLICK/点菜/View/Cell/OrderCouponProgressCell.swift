//
//  OrderCouponProgressCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/19.
//

import UIKit

class OrderCouponProgressCell: BaseTableViewCell {

    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "Get coupon progress"
        return lab
    }()

    private let lwImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_lw")
        return img
    }()
    
    private let proLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(13), .right)
        lab.text = "2/5"
        return lab
    }()
    
    private let couponNameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
        lab.numberOfLines = 2
        lab.text = "Coupon £10"
        lab.isHidden = false
        return lab
    }()
    
    
    private let proBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFF9D7")
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    private let proImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_progress")
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 4
        return img
    }()
    
    private let scaleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(10), .center)
        lab.text = "40%"
        lab.clipsToBounds = true
        lab.backgroundColor = MAINCOLOR
        lab.layer.cornerRadius = 8
        lab.layer.borderWidth = 1
        lab.layer.borderColor = HCOLOR("FFFFFF").cgColor
        return lab
    }()
    
    
    

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        backView.addSubview(lwImg)
        lwImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.top.equalToSuperview().offset(49)
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(proLab)
        proLab.snp.makeConstraints {
            $0.right.equalTo(lwImg.snp.left).offset(-15)
            $0.top.equalToSuperview().offset(48)
        }
        
        backView.addSubview(couponNameLab)
        couponNameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(38)
        }
        
        backView.addSubview(proBackView)
        proBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(lwImg.snp.left).offset(-15)
            $0.top.equalToSuperview().offset(78)
            $0.height.equalTo(8)
        }
        
        
        proBackView.addSubview(proImg)
        proImg.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
        
        proBackView.addSubview(scaleLab)
        scaleLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(proImg.snp.right)
            $0.size.equalTo(CGSize(width: 38, height: 16))
        }
    }
    
    
    func setCellData(model: ConfirmOrderCartModel) {
        
        proLab.text = "\(model.giveCouponHaveNum)/\(model.giveCouponReachNum)"
        
        let scaleValue = Double(model.giveCouponHaveNum)/Double(model.giveCouponReachNum)
        
        let scaleStr = D_2_STR(scaleValue)
        
        
        scaleLab.text = "\(D_2_STR(((Double(scaleStr) ?? 0) * 100)))%"
        
        couponNameLab.text = "For every order greater than £\(model.giveCouponOrderPrice),\nyou will receive a £\(model.giveCouponPrice) coupon"
        
        proImg.snp.remakeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy((scaleValue > 1 ? 1 : scaleValue))
        }
        
        if model.giveCouponHaveNum == 0 {
            scaleLab.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
                $0.size.equalTo(CGSize(width: 38, height: 16))
            }
        } else {
            scaleLab.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalTo(proImg.snp.right)
                $0.size.equalTo(CGSize(width: 38, height: 16))
            }
        }
    }
    
}
