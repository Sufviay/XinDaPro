//
//  FullGiftInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/12/17.
//

import UIKit

class FullGiftInfoCell: BaseTableViewCell {
    
    private var dataModel = FullGiftModel()
    
    var clickMoreBlock: VoidStringBlock?

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()

    let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_18, .left)
        lab.text = "測試測試測試測試"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()

    
    private let t_countlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_14, .left)
        lab.text = "Dishes count".local + ":"
        return lab
    }()
    
    
    private let t_amountlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_14, .left)
        lab.text = "Amount".local + ":"
        return lab
    }()
    

    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = HCOLOR("#3BC772")
        return view
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TXT_10, .center)
        lab.text = "Enable".local
        return lab
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "2"
        return lab
    }()

    private let amountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_14, .left)
        lab.text = "￡40.00"
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
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)

        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-80)
        }
        
        contentView.addSubview(t_countlab)
        t_countlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(t_amountlab)
        t_amountlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerY.equalTo(t_countlab)
            $0.left.equalTo(t_countlab.snp.right).offset(5)
        }
        
        contentView.addSubview(amountLab)
        amountLab.snp.makeConstraints {
            $0.centerY.equalTo(t_amountlab)
            $0.left.equalTo(t_amountlab.snp.right).offset(5)
        }

        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-50)
            $0.size.equalTo(CGSize(width: 50, height: 20))
        }
        
        
        backView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickMoreAction(sender: UIButton) {
        
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        
        editeAlert.alertType = .fullGift
        editeAlert.statusType = dataModel.status
        editeAlert.tap_H = cret.minY
        editeAlert.appearAction()
    }

    
    func setCellData(model: FullGiftModel) {
        
        dataModel = model
        countLab.text = model.giftNum
        amountLab.text = "￡" + model.price
        nameLab.text = model.name
        if model.status == "1" {
            //进行中
            backView.backgroundColor = HCOLOR("#3BC772")
            statusLab.text = "Enable".local
            
        }
        if model.status == "2" {
            //结束
            backView.backgroundColor = HCOLOR("#F75E5E")
            statusLab.text = "Disable".local
        }
        
        
        
    }
    
    
    
}
