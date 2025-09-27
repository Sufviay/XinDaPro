//
//  CustomerInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/17.
//

import UIKit

class CustomerInfoCell: BaseTableViewCell {

    var clickMoreBlock: VoidStringBlock?
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Ms zhang"
        return lab
    }()
    
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Phone Number".local + ":"
        return lab
    }()

    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Email".local + ":"
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Latest Order Date".local + ":"
        return lab
    }()

    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "13940159903"
        return lab
    }()
    
    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "939310308@qq.com"
        return lab
    }()

    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "2025-06-01"
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
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
        }

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-70)
        }
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(15)
            let w = ("Phone Number".local + ":").getTextWidth(TXT_1, 15)
            $0.width.equalTo(w + 5)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab1.snp.bottom).offset(10)
            let w = ("Email".local + ":").getTextWidth(TXT_1, 15)
            $0.width.equalTo(w + 5)
        }
        
        contentView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab2.snp.bottom).offset(10)
            let w = ("Latest Order Date".local + ":").getTextWidth(TXT_1, 15)
            $0.width.equalTo(w + 5)
        }
        
        contentView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.right.equalToSuperview().offset(-50)
            $0.left.equalTo(tlab1.snp.right).offset(5)
        }
        
        contentView.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-50)
            $0.left.equalTo(tlab2.snp.right).offset(5)
        }
        
        
        contentView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab3)
            $0.right.equalToSuperview().offset(-50)
            $0.left.equalTo(tlab3.snp.right).offset(5)
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
        phoneLab.text = model.phone
        emailLab.text = model.email
        dateLab.text = model.lastOrderTime
    }
    
}
