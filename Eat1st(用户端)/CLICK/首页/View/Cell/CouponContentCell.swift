//
//  CouponContentCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/22.
//

import UIKit

class CouponContentCell: BaseTableViewCell {

    var clickRuleBlock: VoidBlock?
    var clickUseBlock: VoidBlock?

    private let DISCOUNT_COLOR = HCOLOR("#FEC501")
    private let POUND_COLOR = HCOLOR("#FA7268")
    private let FREE_COLOR = HCOLOR("#2AD389")
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FA7268"), BFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "COUPON-POUND"
        return lab
    }()

    private let canUseLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Milton Keynes - Grange Farm available"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "13/09/2022-09/10/2022"
        return lab
    }()

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E7E7E7")
        return view
    }()
    
    
    private let limitLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(9), .right)
        lab.text = "Meet £30 available"
        return lab
    }()
    
    
    private let saleMaxLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(9), .right)
        lab.text = "maximum discount is £10"
        return lab
    }()
    
    
//    private let useBut: UIButton = {
//        let but = UIButton()
//        but.setCommentStyle(.zero, "USE", .white, BFONT(11), HCOLOR("#FA7268"))
//        but.layer.cornerRadius = 5
//        return but
//    }()
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("rule_open"), for: .normal)
        return but
    }()
    
    private let ruleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Exclusive shops use red envelopes exclusive shops use red envelopes"
        return lab
    }()
    
    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .center)
        lab.text = "FREE"
        lab.isHidden = true
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FA7268"), BFONT(20), .center)
        lab.text = "£20"
        lab.isHidden = true
        return lab
    }()
    
    private let OFFLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(10), .left)
        lab.text = "OFF"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("FEC501"), BFONT(10), .left)
        lab.text = "%"
        return lab
    }()
    
    
    private let discountlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("FEC501"), BFONT(20), .right)
        lab.text = "20"
        return lab
    }()

    

        
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(canUseLab)
        canUseLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(nameLab.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-110)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(canUseLab.snp.bottom).offset(5)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(canUseLab.snp.bottom).offset(35)
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(limitLab)
        limitLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(line.snp.top).offset(-20)
        }
        
        
        backView.addSubview(saleMaxLab)
        saleMaxLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(line.snp.top).offset(-10)
        }

        
        
//        backView.addSubview(useBut)
//        useBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 55, height: 20))
//            $0.top.equalTo(line.snp.bottom).offset(10)
//            $0.right.equalToSuperview().offset(-20)
//        }
        
        backView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(5)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(ruleLab)
        ruleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(line.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-125)
        }
        
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
        }
        
        backView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
        }
        
        backView.addSubview(discountlab)
        discountlab.snp.makeConstraints {
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
            $0.right.equalTo(limitLab.snp.centerX).offset(4)
        }

        backView.addSubview(OFFLab)
        OFFLab.snp.makeConstraints {
            $0.left.equalTo(discountlab.snp.right).offset(0)
            $0.bottom.equalTo(discountlab).offset(-4)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalTo(OFFLab)
            $0.bottom.equalTo(OFFLab.snp.top).offset(2)
        }
        
        moreBut.addTarget(self, action: #selector(clickXLAction), for: .touchUpInside)
        //useBut.addTarget(self, action: #selector(clickUseAction), for: .touchUpInside)
    }
    
 
    @objc private func clickXLAction() {
        clickRuleBlock?("")
    }
    
    
    @objc private func clickUseAction() {
        clickUseBlock?("")
    }
    
    
    func setCellData(model: CouponModel) {
        
        self.nameLab.text = model.couponName
        self.canUseLab.text = model.canUseStore
        self.timeLab.text = "Valid " + model.startDate + "~" + model.endDate
        self.limitLab.text = model.limitPriceStr
        self.ruleLab.text = model.couponRule
        self.saleMaxLab.text = "Maximum discount is £\(D_2_STR(model.couponLimitPrice))"
        
        if model.couponLimitPrice == 0 {
            self.saleMaxLab.isHidden = true
        } else {
            self.saleMaxLab.isHidden = false
        }

        if model.couponType == "1" {
            //折扣的
            //self.useBut.backgroundColor = DISCOUNT_COLOR
            self.nameLab.textColor = DISCOUNT_COLOR
            
            self.discountlab.isHidden = false
            self.tlab.isHidden = false
            self.OFFLab.isHidden = false
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = true
            self.moneyLab.text = "£\(D_2_STR(model.couponAmount))"
            
            self.freeLab.isHidden = true
        }
        
        if model.couponType == "2" {
            //满减
            //self.useBut.backgroundColor = POUND_COLOR
            self.nameLab.textColor = POUND_COLOR
            
            self.discountlab.isHidden = true
            self.tlab.isHidden = true
            self.OFFLab.isHidden = true
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = false
            self.moneyLab.text = "£\(D_2_STR(model.couponAmount))"
            
            self.freeLab.isHidden = true
        }
        
        if model.couponType == "3" {
            //赠送菜
            //self.useBut.backgroundColor = FREE_COLOR
            self.nameLab.textColor = FREE_COLOR
            
            self.discountlab.isHidden = true
            self.tlab.isHidden = true
            self.OFFLab.isHidden = true
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = true
            self.moneyLab.text = "£\(D_2_STR(model.couponAmount))"
            
            self.freeLab.isHidden = false

        }
        
        if model.ruleNeedOpen {
            self.moreBut.isHidden = false
            
            if model.ruleIsOpen {
                self.ruleLab.numberOfLines = 0
                self.moreBut.setImage(LOIMG("rule_close"), for: .normal)
            } else {
                self.ruleLab.numberOfLines = 1
                self.moreBut.setImage(LOIMG("rule_open"), for: .normal)
            }
            
        } else {
            self.ruleLab.numberOfLines = 1
            self.moreBut.isHidden = true
        }

        
    }
    

}




class SeledctCouponContentCell: BaseTableViewCell {

    var clickRuleBlock: VoidBlock?

    private let DISCOUNT_COLOR = HCOLOR("#FEC501")
    private let POUND_COLOR = HCOLOR("#FA7268")
    private let FREE_COLOR = HCOLOR("#2AD389")
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FA7268"), BFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "COUPON-POUND"
        return lab
    }()

    private let canUseLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Milton Keynes - Grange Farm available"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "13/09/2022-09/10/2022"
        return lab
    }()

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E7E7E7")
        return view
    }()
    
    
    private let limitLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(9), .right)
        lab.text = "Meet £30 available"
        return lab
    }()
    
    
    private let saleMaxLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(9), .right)
        lab.text = "maximum discount is £10"
        return lab
    }()
    
    
    private let selectImg: UIImageView  = {
        let img = UIImageView()
        img.image = LOIMG("unsel")
        return img
    }()
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("rule_open"), for: .normal)
        return but
    }()
    
    private let ruleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Exclusive shops use red envelopes exclusive shops use red envelopes"
        return lab
    }()
    
    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .center)
        lab.text = "FREE"
        lab.isHidden = true
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FA7268"), BFONT(20), .center)
        lab.text = "£20"
        lab.isHidden = true
        return lab
    }()
    
    private let OFFLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(10), .left)
        lab.text = "OFF"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("FEC501"), BFONT(10), .left)
        lab.text = "%"
        return lab
    }()
    
    
    private let discountlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("FEC501"), BFONT(20), .right)
        lab.text = "20"
        return lab
    }()

        
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(canUseLab)
        canUseLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(nameLab.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-125)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(canUseLab.snp.bottom).offset(5)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(canUseLab.snp.bottom).offset(35)
            $0.height.equalTo(0.5)
        }
        
        backView.addSubview(limitLab)
        limitLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalTo(line.snp.top).offset(-20)
        }
        
        backView.addSubview(saleMaxLab)
        saleMaxLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(line.snp.top).offset(-10)
        }
        
        
        backView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 14))
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(5)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(ruleLab)
        ruleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(line.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-125)
        }
        
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
        }
        
        backView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
        }
        
        backView.addSubview(discountlab)
        discountlab.snp.makeConstraints {
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
            $0.right.equalTo(limitLab.snp.centerX).offset(4)
        }

        backView.addSubview(OFFLab)
        OFFLab.snp.makeConstraints {
            $0.left.equalTo(discountlab.snp.right).offset(0)
            $0.bottom.equalTo(discountlab).offset(-4)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalTo(OFFLab)
            $0.bottom.equalTo(OFFLab.snp.top).offset(2)
        }
        
        
        moreBut.addTarget(self, action: #selector(clickXLAction), for: .touchUpInside)
    }
    
 
    @objc private func clickXLAction() {
        clickRuleBlock?("")
    }
    
    
    
    func setCellData(model: CouponModel, isSelect: Bool) {
        
        
        if model.status == "2" {
            //不可使用
            
            self.canUseLab.textColor = HCOLOR("#333333").withAlphaComponent(0.4)
            self.timeLab.textColor = HCOLOR("#666666").withAlphaComponent(0.4)
            self.limitLab.textColor = HCOLOR("#666666").withAlphaComponent(0.4)
            self.ruleLab.textColor = HCOLOR("#666666").withAlphaComponent(0.4)
            self.saleMaxLab.textColor = HCOLOR("#666666").withAlphaComponent(0.4)
            
            self.tlab.textColor = DISCOUNT_COLOR.withAlphaComponent(0.4)
            self.OFFLab.textColor = DISCOUNT_COLOR.withAlphaComponent(0.4)
            self.moneyLab.textColor = POUND_COLOR.withAlphaComponent(0.4)
            self.freeLab.textColor = FREE_COLOR.withAlphaComponent(0.4)
            self.discountlab.textColor = DISCOUNT_COLOR.withAlphaComponent(0.4)
            
            if model.couponType == "1" {
                self.nameLab.textColor = DISCOUNT_COLOR.withAlphaComponent(0.4)
            }
            if model.couponType == "2" {
                self.nameLab.textColor = POUND_COLOR.withAlphaComponent(0.4)
            }
            if model.couponType == "3" {
                self.nameLab.textColor = FREE_COLOR.withAlphaComponent(0.4)
            }
            
            self.selectImg.image = LOIMG("unsel 1")
            

        } else {
            
            self.canUseLab.textColor = HCOLOR("#333333").withAlphaComponent(1)
            self.timeLab.textColor = HCOLOR("#666666").withAlphaComponent(1)
            self.limitLab.textColor = HCOLOR("#666666").withAlphaComponent(1)
            self.ruleLab.textColor = HCOLOR("#666666").withAlphaComponent(1)
            self.saleMaxLab.textColor = HCOLOR("#666666").withAlphaComponent(1)
            
            self.tlab.textColor = DISCOUNT_COLOR.withAlphaComponent(1)
            self.OFFLab.textColor = DISCOUNT_COLOR.withAlphaComponent(1)
            self.moneyLab.textColor = POUND_COLOR.withAlphaComponent(1)
            self.freeLab.textColor = FREE_COLOR.withAlphaComponent(1)
            self.discountlab.textColor = DISCOUNT_COLOR.withAlphaComponent(1)
            
            if model.couponType == "1" {
                self.nameLab.textColor = DISCOUNT_COLOR.withAlphaComponent(1)
            }
            if model.couponType == "2" {
                self.nameLab.textColor = POUND_COLOR.withAlphaComponent(1)
            }
            if model.couponType == "3" {
                self.nameLab.textColor = FREE_COLOR.withAlphaComponent(1)
            }

            
            if isSelect {
                self.selectImg.image = LOIMG("sel")
            } else {
                self.selectImg.image = LOIMG("unsel")
            }
            
        }
    
        
        
        self.nameLab.text = model.couponName
        self.canUseLab.text = model.canUseStore
        self.timeLab.text = "Valid " + model.startDate + "~" + model.endDate
        self.limitLab.text = model.limitPriceStr
        self.ruleLab.text = model.couponRule
        self.saleMaxLab.text = "Maximum discount is £\(D_2_STR(model.couponLimitPrice))"
        
        if model.couponType == "1" {
            //折扣的
            self.discountlab.isHidden = false
            self.tlab.isHidden = false
            self.OFFLab.isHidden = false
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = true
            self.moneyLab.text = "£\(D_2_STR(model.couponAmount))"
            
            self.freeLab.isHidden = true
        }
        
        if model.couponType == "2" {
            //满减
            self.discountlab.isHidden = true
            self.tlab.isHidden = true
            self.OFFLab.isHidden = true
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = false
            self.moneyLab.text = "£\(D_2_STR(model.couponAmount))"
            
            self.freeLab.isHidden = true
        }
        
        if model.couponType == "3" {
            //赠送菜
            
            self.discountlab.isHidden = true
            self.tlab.isHidden = true
            self.OFFLab.isHidden = true
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = true
            self.moneyLab.text = "£\(D_2_STR(model.couponAmount))"
            
            self.freeLab.isHidden = false

        }
        
        if model.ruleNeedOpen {
            self.moreBut.isHidden = false
            
            if model.ruleIsOpen {
                self.ruleLab.numberOfLines = 0
                self.moreBut.setImage(LOIMG("rule_close"), for: .normal)
            } else {
                self.ruleLab.numberOfLines = 1
                self.moreBut.setImage(LOIMG("rule_open"), for: .normal)
            }
            
        } else {
            self.ruleLab.numberOfLines = 1
            self.moreBut.isHidden = true
        }
        
        if model.couponLimitPrice == 0 {
            self.saleMaxLab.isHidden = true
        } else {
            self.saleMaxLab.isHidden = false
        }
        
    }
    

}



