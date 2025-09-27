//
//  HolidayInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/6/26.
//

import UIKit

class HolidayInfoCell: BaseTableViewCell {
    
    
    var clickMoreBlock: VoidBlock?
    
    private lazy var editeAlert: MoreAlert = {
        let alert = MoreAlert()
        
        alert.clickBlock = { [unowned self] (type) in
            clickMoreBlock?(type)
        }
        
        return alert
    }()

    
    
    private var dataModel = HolidayModel()

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    ///节假日名字
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "name"
        return lab
    }()
    
    
    ///日期
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "04-05"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()

    
    ///时间段
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "07:00 - 15:00"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()

    
    ///状态
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), TIT_3, .left)
        lab.text = "Enable"
        return lab
    }()
    
    
    ///备注
    private let remarkLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "remark: ---"
        return lab
    }()


    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()
    


    
    

    override func setViews() {
        
        
        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-80)
            
        }

        contentView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(nameLab.snp.bottom).offset(10)
        }

        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(dateLab.snp.bottom).offset(5)
        }
        
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(timeLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(remarkLab)
        remarkLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(statusLab.snp.bottom).offset(5)
        }


                
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
        
    }
    
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        editeAlert.alertType = .holiday
        editeAlert.tap_H = cret.minY
        self.editeAlert.appearAction()
    }
    
    
    
    func setCellData(model: HolidayModel) {
        
        
        dataModel = model
        
        nameLab.text = model.holiday
        
        if model.status == "1" {
            //启用
            statusLab.textColor = HCOLOR("#2AD389")
            statusLab.text = "Enable".local
        } else {
            statusLab.textColor = HCOLOR("#FC7050")
            statusLab.text = "Disable".local
        }
        
        dateLab.text = model.date
        timeLab.text = model.startTime + " - " + model.endTime
        
        if model.remark != "" {
            remarkLab.text = "\("Remark".local): \(model.remark)"
        } else {
            remarkLab.text = ""
        }
        
        
    }
    

    
}
