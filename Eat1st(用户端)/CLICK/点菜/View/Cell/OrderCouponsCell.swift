//
//  OrderCouponsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/9.
//

import UIKit

class OrderCouponsCell: BaseTableViewCell {

    var clickBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Coupons"
        return lab
    }()
    
    private let disImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("coupon")
        return img
    }()
    

    private var tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Select"
        return lab
    }()
    
    private let clickBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_but")
        return img
    }()
    
    
    private let moreImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("coupon_back")
        return img
    }()
    
    private let zkImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    private let selectedLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF4E26"), BFONT(13), .right)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let noLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DADADA"), BFONT(14), .right)
        lab.text = "No more coupons"
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
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(disImg)
        disImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 13))
            $0.bottom.equalToSuperview().offset(-23)
            $0.left.equalToSuperview().offset(10)
        }
        
        backView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerY.equalTo(disImg)
            $0.left.equalTo(disImg.snp.right).offset(7)
        }
        
        backView.addSubview(clickBut)
        clickBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(disImg)
            $0.height.equalTo(40)
        }
        
        
        clickBut.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(disImg)
        }
        
        
        clickBut.addSubview(moreImg)
        moreImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 128, height: 23))
            $0.centerY.equalTo(disImg)
            $0.right.equalTo(nextImg.snp.left).offset(-10)
        }
        
        clickBut.addSubview(selectedLab)
        selectedLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(nextImg.snp.left).offset(-10)
        }
        
        clickBut.addSubview(zkImg)
        zkImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(selectedLab.snp.left).offset(-10)
        }
        
        clickBut.addSubview(noLab)
        noLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
        clickBut.addTarget(self, action: #selector(clickSelectAction), for: .touchUpInside)
        
    }
    
    @objc private func clickSelectAction() {
        self.clickBlock?("")
        print("aaaa")
    }
    
    
    func setCellData(coupon: CouponModel, isHave: Bool , isCanEdite: Bool) {
        
        
        //是否能按
        if !isHave || !isCanEdite {
            clickBut.isEnabled = false
        } else {
            clickBut.isEnabled = true
        }
        
        //样式
        if !isHave {
            //没有优惠券
            noLab.isHidden = false
            zkImg.isHidden = true
            selectedLab.isHidden = true
            moreImg.isHidden = true
            
            selectedLab.text = ""
            zkImg.image = nil
            nextImg.isHidden = true
        } else {
            //有可用优惠券
            noLab.isHidden = true
            nextImg.isHidden = false
            
            if coupon.couponId == "" {
                //未选择
                self.zkImg.isHidden = true
                self.selectedLab.isHidden = true
                self.moreImg.isHidden = false
                
                self.selectedLab.text = ""
                self.zkImg.image = nil
                
            } else {
                //以选择
                
                self.zkImg.isHidden = false
                self.selectedLab.isHidden = false
                self.moreImg.isHidden = true
            
                
                if coupon.couponType == "1" {
                    //折扣
                    self.selectedLab.text = "\(Int(coupon.couponScale * 100))%OFF"
                    self.zkImg.image = LOIMG("coupon_discount")
                    
                }
                
                if coupon.couponType == "2" {
                    //满减
                    self.selectedLab.text = "-£\(D_2_STR(coupon.couponAmount))"
                    self.zkImg.image = LOIMG("coupon_voucher")
                }
                
                if coupon.couponType == "3" {
                    //赠送菜
                    self.selectedLab.text = coupon.dishesName
                    self.zkImg.image = LOIMG("coupon_free")
                }
            }
            
        }        
    }
    
    
    override func reSetFrame() {
        let but_W = S_W - 120

        let maxLab_W: CGFloat = but_W - 50 - 10 - 30
        
        let r_lab_W: CGFloat = (selectedLab.text ?? "").getTextWidth(BFONT(13), 15) + 10
        
        let r_w = r_lab_W > maxLab_W ? maxLab_W : r_lab_W
        
        self.selectedLab.snp.remakeConstraints {
            $0.width.equalTo(r_w)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
        }
    }
    

}
