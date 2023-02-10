//
//  OrderChoosePayWayCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/28.
//

import UIKit

class OrderChoosePayWayCell: BaseTableViewCell {

    
    var clickTypeBlock: VoidBlock?
    
    ///1：现金、2：卡
    private var selectType: String = ""
    
    private let cashBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        but.layer.cornerRadius = 10
        return but
        
    }()
    
    
    private let cardBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        but.layer.cornerRadius = 10
        return but
        
    }()
    
    private let cashImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("cash_y")
        return img
    }()
    
    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("card_y")
        return img
    }()
    
    private let cashlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .center)
        lab.text = "Pay with Cash"
        return lab
    }()
    
    private let cardlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .center)
        lab.text = "Pay with Card"
        return lab
    }()
    
    private let cashLine: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()
    
    private let cardLine: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        view.isHidden = true
        return view
    }()


    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        contentView.addSubview(cardBut)
        cardBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
            $0.right.equalTo(contentView.snp.centerX).offset(-5)
            

        }
        
        contentView.addSubview(cashBut)
        cashBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.left.equalTo(cardBut.snp.right).offset(10)
        }
    
        
        cashBut.addSubview(cashImg)
        cashImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(35)
            $0.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        cashBut.addSubview(cashlab)
        cashlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cashImg.snp.bottom).offset(10)
        }
        
        
        cardBut.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(35)
            $0.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        cardBut.addSubview(cardlab)
        cardlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardImg.snp.bottom).offset(10)
        }
        
        cashBut.addSubview(cashLine)
        cashLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.top.equalTo(cashlab.snp.bottom).offset(5)
        }
        
        cardBut.addSubview(cardLine)
        cardLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.top.equalTo(cardlab.snp.bottom).offset(5)
        }
        
        cardBut.addTarget(self, action: #selector(clickCardAction), for: .touchUpInside)
        cashBut.addTarget(self, action: #selector(clickCashAction), for: .touchUpInside)
        
    }
    
    @objc private func clickCashAction() {
        if selectType != "1" {
            self.clickTypeBlock?("1")
        } else {
            self.clickTypeBlock?("")
        }
    }
    
    @objc private func clickCardAction() {
        if selectType != "2" {
            self.clickTypeBlock?("2")
        } else {
            self.clickTypeBlock?("")
        }
    }
    
    func setCellData(status: String, type: String) {
        
        self.selectType = type
        
        ///是否可以现金付款或是否可以在线付款 1现金 2卡 3都行
        ///1 现金  2 卡
        ///设置UI
        if status == "2" {
            ///只能用卡支付
            self.cashBut.isEnabled = false
            self.cashImg.image = LOIMG("cash_g")
            self.cashlab.textColor = HCOLOR("#DDDDDD")
            self.cashBut.backgroundColor = .white
            cashLine.isHidden = true

            self.cardBut.isEnabled = true
            
            if type == "" {
                self.cardImg.image = LOIMG("card_y")
                self.cardlab.textColor = MAINCOLOR
                self.cardBut.backgroundColor = .white
                self.cardLine.isHidden = true
            }
            
            if type == "2" {
                self.cardImg.image = LOIMG("card_b")
                self.cardlab.textColor = FONTCOLOR
                self.cardBut.backgroundColor = HCOLOR("#FEC501").withAlphaComponent(0.05)
                self.cardLine.isHidden = false
            }
            
        }
        
        if status == "1" {
            
            ///只能现金支付
            self.cardBut.isEnabled = false
            self.cardImg.image = LOIMG("card_g")
            self.cardlab.textColor = HCOLOR("#DDDDDD")
            self.cardBut.backgroundColor = .white
            cardLine.isHidden = true

            self.cashBut.isEnabled = true
            
            if type == "" {
                self.cashImg.image = LOIMG("cash_y")
                self.cashlab.textColor = MAINCOLOR
                self.cashBut.backgroundColor = .white
                self.cashLine.isHidden = true
            }
            
            if type == "1" {
                self.cashImg.image = LOIMG("cash_b")
                self.cashlab.textColor = FONTCOLOR
                self.cashBut.backgroundColor = HCOLOR("#FEC501").withAlphaComponent(0.05)
                self.cashLine.isHidden = false
            }
            
        }
        
        if status == "99" {
            ///都可以
            self.cashBut.isEnabled = true
            self.cardBut.isEnabled = true
            
            if type == "" {
                self.cashImg.image = LOIMG("cash_y")
                self.cashlab.textColor = MAINCOLOR
                self.cashBut.backgroundColor = .white
                self.cashLine.isHidden = true
                
                self.cardImg.image = LOIMG("card_y")
                self.cardlab.textColor = MAINCOLOR
                self.cardBut.backgroundColor = .white
                self.cardLine.isHidden = true
            }
            
            if type == "2" {
                self.cardImg.image = LOIMG("card_b")
                self.cardlab.textColor = FONTCOLOR
                self.cardBut.backgroundColor = HCOLOR("#FEC501").withAlphaComponent(0.05)
                self.cardLine.isHidden = false
                
                
                self.cashImg.image = LOIMG("cash_y")
                self.cashlab.textColor = MAINCOLOR
                self.cashBut.backgroundColor = .white
                self.cashLine.isHidden = true
            }
            
            if type == "1" {
                
                self.cashImg.image = LOIMG("cash_b")
                self.cashlab.textColor = FONTCOLOR
                self.cashBut.backgroundColor = HCOLOR("#FEC501").withAlphaComponent(0.05)
                self.cashLine.isHidden = false
                
                self.cardImg.image = LOIMG("card_y")
                self.cardlab.textColor = MAINCOLOR
                self.cardBut.backgroundColor = .white
                self.cardLine.isHidden = true
            }
        }
    }
}


class OrderCardPayCell: BaseTableViewCell {

    private let cardBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#FFEBDD")
        but.layer.cornerRadius = 10
        but.isEnabled = false
        return but
    }()
    
    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("card_pay")
        return img
    }()
    
    private let cardlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "Card Pay"
        return lab
    }()



    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        
        contentView.addSubview(cardBut)
        cardBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
    
        cardBut.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(37)
            $0.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        cardBut.addSubview(cardlab)
        cardlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardImg.snp.bottom).offset(10)
        }
        
    }
    
}

class OrderCashPayCell: BaseTableViewCell {

    private let cashBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#FFEBDD")
        but.layer.cornerRadius = 10
        but.isEnabled = false
        return but
        
    }()
    
    private let cashImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("cash_pay")
        return img
    }()
    

    private let cashlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "Cash Pay"
        return lab
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        contentView.addSubview(cashBut)
        cashBut.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        cashBut.addSubview(cashImg)
        cashImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(37)
            $0.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        cashBut.addSubview(cashlab)
        cashlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cashImg.snp.bottom).offset(10)
        }
        
    }
    
    
}


