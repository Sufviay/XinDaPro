//
//  OrderNumberInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class OrderNumberInfoCell: BaseTableViewCell {
    
    
    private var callPhone: String = ""
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let numberlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .left)
        lab.text = "#099"
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .left)
        lab.text = "Pending"
        return lab
    }()
    
    private let orderNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "The order number: 0000000"
        return lab
    }()
    
    private let orderTime: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Order time: 0000000"
        return lab
    }()
    
    
    private let infoLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Ms Zhang  13874774747"
        return lab

    }()
    
    private let phonebut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("phone"), for: .normal)
        return but
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Immediate delivery /15:35 delivery"
        return lab
    }()
    
    
    
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        
        contentView.addSubview(numberlab)
        numberlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(numberlab)
        }
        
        contentView.addSubview(orderTime)
        orderTime.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(45)
        }
        

        contentView.addSubview(orderNum)
        orderNum.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(orderTime.snp.bottom).offset(8)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.5)
            $0.top.equalTo(orderNum.snp.bottom).offset(8)
        }
        
        contentView.addSubview(infoLab)
        infoLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }
        
        contentView.addSubview(phonebut)
        phonebut.snp.makeConstraints {
            $0.centerY.equalTo(infoLab)
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }

        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(infoLab.snp.bottom).offset(8)
        }
        
        phonebut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        
    }

    func setCellData(model: OrderModel) {
        
        self.callPhone = model.perPhone
        
        self.numberlab.text = "#\(model.dayNum)"
        self.statusLab.text = model.statusStr
        self.orderNum.text = "Order code:  \(model.orderNum)"
        self.orderTime.text = "Order time:  \(model.createTime)"
        self.infoLab.text = "\(model.perName)  \(model.perPhone)"
        self.timeLab.text = "\(model.hopeTime)"
    }
    
    
    @objc func clickPhoneAction() {
        PJCUtil.callPhone(phone: callPhone)
    }
    
}
