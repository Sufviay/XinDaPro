//
//  CustomerHeaderView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/25.
//

import UIKit

class CustomerHeaderView: UIView {
    
    var clickBlock: VoidBlock?
    
    
    ///1：下单数量 2：下单金额 3：最后下单日期
    private var sortBy: String = ""
    ///排序顺序 1：正序 2：倒序
    private var sortAsc: String = ""
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Name".local
        return lab
    }()
    
    
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Orders".local
        return lab
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .right)
        lab.text = "Last Date".local
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    
    private let orderBut: UIButton = {
        let but = UIButton()
        return but
    }()

    private let dateBut: UIButton = {
        let but = UIButton()
        return but
    }()

    
    private let dateImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("up_g")
        return img
    }()
    private let dateImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("down_g")
        return img
    }()

    private let orderImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("up_g")
        return img
    }()

    private let orderImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("down_g")
        return img
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = BACKCOLOR_3
        
        addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        addSubview(orderBut)
        orderBut.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.width.equalTo(S_W / 4)
        }
        
        addSubview(dateBut)
        dateBut.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(orderBut.snp.right).offset(0)
        }
        
        orderBut.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        orderBut.addSubview(orderImg1)
        orderImg1.snp.makeConstraints {
            $0.bottom.equalTo(orderBut.snp.centerY).offset(-2)
            $0.left.equalTo(orderLab.snp.right).offset(5)
        }
        
        orderBut.addSubview(orderImg2)
        orderImg2.snp.makeConstraints {
            $0.top.equalTo(orderBut.snp.centerY).offset(2)
            $0.left.equalTo(orderLab.snp.right).offset(5)
        }

        
        
        
        dateBut.addSubview(dateImg1)
        dateImg1.snp.makeConstraints {
            $0.bottom.equalTo(dateBut.snp.centerY).offset(-2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        dateBut.addSubview(dateImg2)
        dateImg2.snp.makeConstraints {
            $0.top.equalTo(dateBut.snp.centerY).offset(2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        dateBut.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-35)
            $0.left.equalToSuperview()
        }
        
        dateBut.addTarget(self, action: #selector(clickDateAction), for: .touchUpInside)
        orderBut.addTarget(self, action: #selector(clickOrderAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickOrderAction() {
        
        dateLab.textColor = TXTCOLOR_1
        dateImg1.image = LOIMG("up_g")
        dateImg2.image = LOIMG("down_g")
        
        if sortBy == "3" {
            sortAsc = ""
        }
        
        
        if sortAsc == "" {
            //變為正
            sortAsc = "1"
            sortBy = "1"
            orderLab.textColor = MAINCOLOR
            orderImg1.image = LOIMG("up_b")
            orderImg2.image = LOIMG("down_g")
        } else if sortAsc == "1" {
            //變為倒
            sortAsc = "2"
            sortBy = "1"
            orderLab.textColor = MAINCOLOR
            orderImg1.image = LOIMG("up_g")
            orderImg2.image = LOIMG("down_b")
        } else {
            //變為默認
            sortAsc = ""
            sortBy = ""
            orderLab.textColor = TXTCOLOR_1
            orderImg1.image = LOIMG("up_g")
            orderImg2.image = LOIMG("down_g")
            
        }
        
        clickBlock?(["sortBy": sortBy, "sortAsc": sortAsc])
    }
    
    @objc private func clickDateAction() {
        orderLab.textColor = TXTCOLOR_1
        orderImg1.image = LOIMG("up_g")
        orderImg2.image = LOIMG("down_g")
        
        if sortBy == "1" {
            sortAsc = ""
        }


        if sortAsc == "" {
            //變為正
            sortAsc = "1"
            sortBy = "3"
            dateLab.textColor = MAINCOLOR
            dateImg1.image = LOIMG("up_b")
            dateImg2.image = LOIMG("down_g")
        } else if sortAsc == "1" {
            //變為倒
            sortAsc = "2"
            sortBy = "3"
            dateLab.textColor = MAINCOLOR
            dateImg1.image = LOIMG("up_g")
            dateImg2.image = LOIMG("down_b")
        } else {
            //變為默認
            sortAsc = ""
            sortBy = ""
            dateLab.textColor = TXTCOLOR_1
            dateImg1.image = LOIMG("up_g")
            dateImg2.image = LOIMG("down_g")
        }
        clickBlock?(["sortBy": sortBy, "sortAsc": sortAsc])
        
    }
    

    
}
