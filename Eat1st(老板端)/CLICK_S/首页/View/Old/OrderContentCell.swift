//
//  OrderContentCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/2/10.
//

import UIKit

class OrderContentCell: BaseTableViewCell {


    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .left)
        lab.text = "#99"
        return lab
    }()
    
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.text = "Delivery"
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .right)
        return lab
    }()
    
    private let payWayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(15), .right)
        lab.text = "Cash Pay"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(10), .center)
        lab.text = "#1234567891234567891"
        return lab
    }()
    
    private let postCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(18), .left)
        lab.text = "MK8 8AN"
        return lab
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "3 Medhurst，Two Mile Ash"
        return lab
    }()
    
//    private let line: UIView = {
//        let view = UIView()
//        view.backgroundColor = MAINCOLOR
//        return view
//    }()
    
//    private let coLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(.black, BFONT(18), .left)
//        lab.text = "COLLECTION"
//        return lab
//    }()
    
    
        
    
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalTo(numberLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(postCodeLab)
        postCodeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(45)
        }
        
        
        contentView.addSubview(payWayLab)
        payWayLab.snp.makeConstraints {
            $0.centerY.equalTo(postCodeLab)
            $0.right.equalTo(statusLab)
        }

        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 135, height: 20))
            $0.top.equalToSuperview().offset(65)
        }

        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(65)
            $0.right.equalToSuperview().offset(-170)
        }

//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview()
//            $0.top.equalToSuperview().offset(20)
//            $0.height.equalTo(45)
//            $0.width.equalTo(5)
//        }
        
//        contentView.addSubview(coLab)
//        coLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(15)
//            $0.top.equalToSuperview().offset(50)
//        }
        
    }
    
    
    func setCellData(model: OrderModel) {
        
        
        self.numberLab.text = "#" + model.dayNum
        
        if model.paymentMethod == "1" {
            //现金
            self.payWayLab.text = "Cash Pay"
        }
        if model.paymentMethod == "2" {
            //ka
            self.payWayLab.text = "Card Pay"
        }
        self.orderLab.text = "#" + model.orderNum
        
        if model.type == "1" {
            self.postCodeLab.text = model.postCode
            self.addressLab.text = model.address

        } else {
            self.postCodeLab.text = model.perName
            self.addressLab.text = model.perPhone
        }
    }

}
