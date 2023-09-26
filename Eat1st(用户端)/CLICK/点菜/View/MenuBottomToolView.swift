//
//  MenuBottomToolView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/2.
//

import UIKit

class MenuBottomToolView: UIView {
    
    var clickCartBlock: VoidBlock?
    
    var clickCheckBlock: VoidBlock?
    
    private var isCanCheck: Bool = false

        
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Checkout", MAINCOLOR, BFONT(17), .white)
        but.layer.cornerRadius = 20
        return but
    }()
    
    private let cartBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#FDC501")
        return but
    }()
    
    private let cartImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("cart_y")
        return img
    }()
    
    private let dishNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(11), .center)
        lab.text = "100"
        lab.backgroundColor = HCOLOR("#FF3C00")
        lab.layer.cornerRadius = 8
        lab.clipsToBounds = true
        return lab
    }()
    
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .left)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(20), .left)
        lab.text = "0.00"
        return lab
    }()
    
    private let d_moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .left)
        lab.text = "(£0.00)"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    
    private let msgLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(10), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Store closed"
        return lab
    }()

    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        
        self.addSubview(cartBut)
        cartBut.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 110, height: 40))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }
        
        
        cartBut.addSubview(cartImg)
        cartImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 46, height: 27))
        }
        
        cartImg.addSubview(dishNumLab)
        dishNumLab.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset( -3)
            $0.centerX.equalTo(cartImg.snp.right).offset(-3)
            $0.width.equalTo(16)
        }
        
        
        cartBut.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            //$0.top.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview().offset(-8)
            $0.left.equalTo(cartImg.snp.right).offset(23)
        }
    
        cartBut.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalTo(cartImg.snp.right).offset(13)
            $0.bottom.equalTo(moneyLab).offset(-2)
        }
        
        cartBut.addSubview(msgLab)
        msgLab.snp.makeConstraints {
            $0.top.equalTo(moneyLab.snp.bottom).offset(0)
            $0.left.equalTo(s_lab)
            $0.right.equalTo(confirmBut.snp.left).offset(-5)
        }
        
        cartBut.addSubview(d_moneyLab)
        d_moneyLab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-3)
            $0.left.equalTo(moneyLab.snp.right).offset(5)
        }
        
        d_moneyLab.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(2)
            $0.right.equalToSuperview().offset(-2)
            $0.centerY.equalToSuperview()
        }
        
        cartBut.addTarget(self, action: #selector(clickCartAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickCheckAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickCartAction() {
        
        clickCartBlock?("")
    }
    
    @objc private func clickCheckAction() {
        if isCanCheck  {
            clickCheckBlock?("")
        }
    }
    
    
    
    func setValue(dishMoney: String, buyCount: Int, discountType: String, discountMoney: String, deliveryFee: String, minOrder: String, type: String) {

        ///type:  3是，4菜品金额小于等于0，5菜品金额小于店铺最低配送金额），6关店（不在营业时间呗) 7菜品不可用  8 没有菜  9未登录
        
        
        if type == "3" {
            self.isCanCheck = true
            self.msgLab.isHidden = true
            self.moneyLab.snp.updateConstraints {
                $0.centerY.equalToSuperview()
            }
        } else {
            self.isCanCheck = false
            self.msgLab.isHidden = false
            self.moneyLab.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(-8)
            }

        }
        
        if !isCanCheck {
            self.cartImg.image = LOIMG("cart_g")
            self.cartBut.backgroundColor = HCOLOR("#CCCCCC")
            self.confirmBut.setTitleColor(HCOLOR("#CCCCCC"), for: .normal)
            
        } else {
            self.cartImg.image = LOIMG("cart_y")
            self.cartBut.backgroundColor = HCOLOR("#FDC501")
            self.confirmBut.setTitleColor(MAINCOLOR, for: .normal)

        }
        
        
        if type == "6" {
            self.msgLab.text = "Store closed"
        } else if type == "3" {
            self.msgLab.text = ""
        } else if type == "7" {
            self.msgLab.text = "Some dishes are not available"
        } else if type == "9" {
            self.msgLab.text = "Please log in"
        } else if type == "4" {
            self.msgLab.text = "Please order"
        } else if type == "8" {
            self.msgLab.text = "Please order"
        }
        else {
            self.msgLab.textColor = HCOLOR("FB5348")
            self.msgLab.text = "The minimum charge is £\(minOrder)"
        }

        /// discountType 1有折扣，2无折扣
        if discountType == "1" {
        
            if dishMoney == "0" {
                self.d_moneyLab.isHidden = true
            } else {
                self.d_moneyLab.isHidden = false
            }
            self.moneyLab.text = discountMoney
            self.d_moneyLab.text = "(£\(dishMoney))"
            
        } else {
            self.moneyLab.text = dishMoney
            self.d_moneyLab.text = ""
            self.d_moneyLab.isHidden = true
        }
        
        self.dishNumLab.text = String(buyCount)
    
        if buyCount == 0 {
            self.dishNumLab.isHidden = true
        } else {
            self.dishNumLab.isHidden = false
            let s_w = dishNumLab.text!.getTextWidth(SFONT(11), 16)
            let w = (s_w + 5) > 16 ? (s_w + 5) : 16
            self.dishNumLab.snp.updateConstraints {
                $0.width.equalTo(w)
            }
        }
    }

}
