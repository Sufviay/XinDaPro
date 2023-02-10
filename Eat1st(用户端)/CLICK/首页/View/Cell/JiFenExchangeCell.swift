//
//  JiFenExchangeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/10.
//

import UIKit

class JiFenExchangeCell: BaseTableViewCell {
    
    var clickRuleBlock: VoidBlock?
    var clickExchangeBlock: VoidBlock?
    
    private let DISCOUNT_COLOR = HCOLOR("#FEC501")
    private let POUND_COLOR = HCOLOR("#FA7268")
    private let FREE_COLOR = HCOLOR("#2AD389")
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E7E7E7")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FA7268"), BFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "COUPON-POUNDCOUPON-"
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
    
    private let exchangeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "1000 POINTS", .white, BFONT(9), HCOLOR("#2AD389"))
        but.layer.cornerRadius = 5
        return but
    }()

        
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-100)
        }
        
        contentView.addSubview(canUseLab)
        canUseLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-120)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(canUseLab.snp.bottom).offset(2)
        }
        
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(canUseLab.snp.bottom).offset(25)
            $0.height.equalTo(0.5)
        }

        

        contentView.addSubview(limitLab)
        limitLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(line2.snp.top).offset(-20)
        }
        
        contentView.addSubview(saleMaxLab)
        saleMaxLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(line2.snp.top).offset(-7)
        }
        
        contentView.addSubview(exchangeBut)
        exchangeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 20))
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(line2.snp.bottom).offset(5)
        }
        
        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom).offset(5)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.right.equalToSuperview().offset(-125)
        }
        
        contentView.addSubview(ruleLab)
        ruleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line2.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-155)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
        }
        
        contentView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.centerX.equalTo(limitLab)
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
        }
        
        contentView.addSubview(discountlab)
        discountlab.snp.makeConstraints {
            $0.bottom.equalTo(limitLab.snp.top).offset(-2)
            $0.right.equalTo(limitLab.snp.centerX).offset(4)
        }

        contentView.addSubview(OFFLab)
        OFFLab.snp.makeConstraints {
            $0.left.equalTo(discountlab.snp.right).offset(0)
            $0.bottom.equalTo(discountlab).offset(-4)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalTo(OFFLab)
            $0.bottom.equalTo(OFFLab.snp.top).offset(2)
        }
        
        
        moreBut.addTarget(self, action: #selector(clickXLAction), for: .touchUpInside)
        exchangeBut.addTarget(self, action: #selector(clickExAciton), for: .touchUpInside)
    }
    
 
    @objc private func clickXLAction() {
        clickRuleBlock?("")
    }
    
    @objc private func clickExAciton() {
        clickExchangeBlock?("")
    }
    
    
    func setCellData(model: JiFenExchangeModel, curJifen: Int) {
        
        
        let isCanUse = curJifen >= model.pointsNum ? true : false
        
        if !isCanUse {
            //不可兑换
            self.exchangeBut.isEnabled = false
            self.exchangeBut.backgroundColor = HCOLOR("#CCCCCC")
            

        } else {
            self.exchangeBut.isEnabled = true
            
            if model.couponType == "1" {
                self.exchangeBut.backgroundColor = DISCOUNT_COLOR
            }
            if model.couponType == "2" {
                self.exchangeBut.backgroundColor = POUND_COLOR
            }
            if model.couponType == "3" {
                self.exchangeBut.backgroundColor = FREE_COLOR
            }

        }
    
        if model.couponType == "1" {
            self.nameLab.textColor = DISCOUNT_COLOR
        }
        if model.couponType == "2" {
            self.nameLab.textColor = POUND_COLOR
        }
        if model.couponType == "3" {
            self.nameLab.textColor = FREE_COLOR
        }

        
        
        self.exchangeBut.setTitle("\(model.pointsNum) POINTS", for: .normal)
        self.nameLab.text = model.couponName
        self.canUseLab.text = model.canUseStore
        self.timeLab.text = "Valid " + model.startDate + "~" + model.endDate
        self.limitLab.text = model.limitPriceStr
        self.ruleLab.text = model.useRule
        self.saleMaxLab.text = "Maximum discount is £\(D_2_STR(model.couponLimitPrice))"
        
        if model.couponType == "1" {
            //折扣的
            self.discountlab.isHidden = false
            self.tlab.isHidden = false
            self.OFFLab.isHidden = false
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = true
            self.moneyLab.text = "£\(D_2_STR(model.couponPrice))"
            
            self.freeLab.isHidden = true
        }
        
        if model.couponType == "2" {
            //满减
            self.discountlab.isHidden = true
            self.tlab.isHidden = true
            self.OFFLab.isHidden = true
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = false
            self.moneyLab.text = "£\(D_2_STR(model.couponPrice))"
            
            self.freeLab.isHidden = true
        }
        
        if model.couponType == "3" {
            //赠送菜
            
            self.discountlab.isHidden = true
            self.tlab.isHidden = true
            self.OFFLab.isHidden = true
            self.discountlab.text = "\(Int(model.couponScale * 100))"
            
            self.moneyLab.isHidden = true
            self.moneyLab.text = "£\(D_2_STR(model.couponPrice))"
            
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
