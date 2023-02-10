//
//  OrderMoneyCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class OrderMoneyCell: BaseTableViewCell {

    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Subtotal"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Delivery fee"
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Service fee"
        return lab
    }()
    
    private let tlab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Discount"
        return lab
    }()
    
    private let tlab5: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Total"
        return lab
    }()

    private let tlab6: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Wallet"
        return lab
    }()
    
    private let tlab7: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Payment"
        return lab
    }()

    private let tlab8: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, SFONT(14), .left)
        lab.text = "Payment method"
        return lab
    }()
    
    private let moneyLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let moneyLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    
    private let moneyLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    
    private let moneyLab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF461C"), BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let moneyLab5: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let moneyLab6: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FF461C"), BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()
    
    private let moneyLab7: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()

    
    private let moneyLab8: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "£10"
        return lab
    }()


    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        return view
    }()

    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab4)
        tlab4.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab5)
        tlab5.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab6)
        tlab6.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab7)
        tlab7.snp.makeConstraints {
            $0.top.equalToSuperview().offset(165)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(tlab8)
        tlab8.snp.makeConstraints {
            $0.top.equalToSuperview().offset(190)
            $0.left.equalToSuperview().offset(10)
        }





        contentView.addSubview(moneyLab1)
        moneyLab1.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(tlab1)
        }
        
        contentView.addSubview(moneyLab2)
        moneyLab2.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab3)
        moneyLab3.snp.makeConstraints {
            $0.centerY.equalTo(tlab3)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab4)
        moneyLab4.snp.makeConstraints {
            $0.centerY.equalTo(tlab4)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab5)
        moneyLab5.snp.makeConstraints {
            $0.centerY.equalTo(tlab5)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab6)
        moneyLab6.snp.makeConstraints {
            $0.centerY.equalTo(tlab6)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(moneyLab7)
        moneyLab7.snp.makeConstraints {
            $0.centerY.equalTo(tlab7)
            $0.right.equalToSuperview().offset(-10)
        }

        contentView.addSubview(moneyLab8)
        moneyLab8.snp.makeConstraints {
            $0.centerY.equalTo(tlab8)
            $0.right.equalToSuperview().offset(-10)
        }

    }
    
    func setCellData(model: OrderModel) {
        self.moneyLab1.text = "£" + D_2_STR(model.dishPrice)
        self.moneyLab2.text = "£" + D_2_STR(model.deliveryFee)
        self.moneyLab3.text = "£" + D_2_STR(model.serviceFee)
        self.moneyLab4.text = "-£" + D_2_STR(model.discountPrice)
        self.moneyLab5.text = "£" + D_2_STR(model.orderPrice)
        self.moneyLab6.text = "-£" + D_2_STR(model.walletPrice)
        self.moneyLab7.text = "£" + D_2_STR(model.payPrice)
        
        
        
        var way = ""
        if model.paymentMethod == "1" {
            way = "Cash"
        }
        if model.paymentMethod == "2" {
            way = "Card"
        }
        if model.paymentMethod == "3" {
            way = "POS"
        }
        self.moneyLab8.text = way
    }

}
