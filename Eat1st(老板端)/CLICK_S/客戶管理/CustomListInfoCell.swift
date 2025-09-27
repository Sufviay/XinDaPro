//
//  CustomListInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/25.
//

import UIKit

class CustomListInfoCell: BaseTableViewCell {

    
    var clickMoreBlock: VoidStringBlock?
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "Name"
        lab.numberOfLines = 1
        return lab
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        lab.text = "+8536789678"
        return lab
    }()
    
    private let tagLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        lab.text = "標籤1, 標籤2"
        return lab
    }()

    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()
    
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .center)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "10"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .center)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "£ 5000.00"
        return lab
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.numberOfLines = 2
        lab.text = "2025-09-25 10:10:10"
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()



    

    private lazy var editeAlert: MoreAlert = {
        let alert = MoreAlert()
        
        alert.clickBlock = { [unowned self] (type) in
            clickMoreBlock?(type)
        }
        
        return alert
    }()


    
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-20)
        }

        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(S_W / 4)
            $0.top.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(orderLab)
            $0.top.equalTo(orderLab.snp.bottom).offset(5)
        }
        
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(orderLab.snp.left).offset(-5)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(orderLab)
        }
        
        contentView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(numberLab.snp.bottom).offset(0)
        }
        
        contentView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.left.equalTo(orderLab.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(orderLab)
        }
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
        
    }
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        editeAlert.alertType = .customer
        editeAlert.tap_H = cret.minY
        self.editeAlert.appearAction()
    }


    
    
    func setCellData(model: UserModel) {
        nameLab.text = model.nickName
        numberLab.text = model.numberStr
        orderLab.text = model.orderNum
        moneyLab.text = "£\(D_2_STR(model.orderAmount))"
        dateLab.text = model.lastOrderTime
        tagLab.text = model.tagStr
    }
    
    
    
    
    
    
}
