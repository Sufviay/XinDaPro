//
//  CustomerTagInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/23.
//

import UIKit

class CustomerTagInfoCell: BaseTableViewCell {
    
    var clickMoreBlock: VoidBlock?

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "name"
        return lab
    }()

    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Tag-linked user count:".local
        return lab
    }()
    
    private let countlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "100"
        return lab
    }()
    
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TXT_3, .center)
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 3
        lab.backgroundColor = HCOLOR("#3BC772")
        lab.text = "Enable"
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
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-80)
        }

        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(countlab)
        countlab.snp.makeConstraints {
            $0.centerY.equalTo(tlab)
            $0.left.equalTo(tlab.snp.right).offset(10)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 20))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(60)
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
        
    }
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        editeAlert.alertType = .tag
        editeAlert.tap_H = cret.minY
        self.editeAlert.appearAction()
    }
    
    
    func setCellData(model: CustomerTagModel) {
        nameLab.text = model.name1
        countlab.text = model.userNum
        
        if model.status == "1" {
            //啟用
            statusLab.text = "Enable".local
            statusLab.backgroundColor = HCOLOR("3BC772")
        } else {
            statusLab.text = "Disable".local
            statusLab.backgroundColor = HCOLOR("#F75E5E")

        }
    }
    
    
}
