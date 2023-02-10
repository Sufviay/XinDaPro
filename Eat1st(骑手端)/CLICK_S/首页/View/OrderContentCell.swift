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
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(17), .left)
        lab.text = "#99"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(10), .right)
        lab.text = "Estimated time"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .right)
        lab.text = "11:03-12:05"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(10), .center)
        lab.text = "#1234567891234567891"
        return lab
    }()

    
    
    private let cardWayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .right)
        lab.text = "Card"
        return lab
    }()
    
    private let posWayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .right)
        lab.text = "POS"
        return lab
    }()

    
    private let gitImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        return img
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
    
        
    
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(23)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalTo(tlab.snp.left).offset(-5)
            $0.bottom.equalTo(tlab.snp.bottom).offset(2)
        }
        
        contentView.addSubview(postCodeLab)
        postCodeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(50)
        }
        
        contentView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-170)
        }

        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 135, height: 20))
            $0.top.equalToSuperview().offset(75)
        }
        
        contentView.addSubview(gitImg)
        gitImg.snp.makeConstraints {
            $0.bottom.equalTo(orderLab.snp.top).offset(0)
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 60, height: 30))
        }
        
        contentView.addSubview(cardWayLab)
        cardWayLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 30))
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(orderLab.snp.top).offset(0)
        }
        
        
        contentView.addSubview(posWayLab)
        posWayLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 30))
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(orderLab.snp.top).offset(0)
        }

        
    }
    
    
    func setCellData(model: OrderModel) {
        
        
        self.numberLab.text = "#" + model.dayNum
        self.gitImg.image = PJCUtil.getGifImg(name: "闪动")
        self.timeLab.text = model.startTime + "-" + model.endTime
        
        if model.paymentMethod == "1" {
            //现金
            self.gitImg.isHidden = false
            self.cardWayLab.isHidden = true
            self.posWayLab.isHidden = true
        }
        if model.paymentMethod == "2" {
            //ka
            self.gitImg.isHidden = true
            self.cardWayLab.isHidden = false
            self.posWayLab.isHidden = true
        }
        
        if model.paymentMethod == "3" {
            //pos
            self.gitImg.isHidden = true
            self.cardWayLab.isHidden = true
            self.posWayLab.isHidden = false
        }
        
        self.orderLab.text = "#" + model.orderNum        
        self.postCodeLab.text = model.postCode
        self.addressLab.text = model.address

    }
    
}
