//
//  TableInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/1.
//

import UIKit

class TableInfoCell: BaseTableViewCell {
    
    
    var clickMoreBlock: VoidBlock?
    
    private lazy var editeAlert: TableMoreAlert = {
        let alert = TableMoreAlert()
        
        alert.clickBlock = { [unowned self] (type) in
            clickMoreBlock?(type)
        }
        
        return alert
    }()
    
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(17), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let numberImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("number")
        return img
    }()
    
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FEC501"), BFONT(14), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(14), .left)
        lab.text = "On"
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

        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
        }
        
        
        contentView.addSubview(numberImg)
        numberImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 13, height: 15))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(10)
        }
        
        contentView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalTo(numberImg.snp.right).offset(5)
            $0.centerY.equalTo(numberImg)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.top.equalTo(numberImg.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
    
        }
        
//        contentView.addSubview(remarkLab)
//        remarkLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-80)
//            $0.top.equalTo(nameLab.snp.bottom).offset(15)
//        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
        
    }
    
    
    
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        self.editeAlert.tap_H = cret.minY
        self.editeAlert.appearAction()
    }
    
    
    func setCellData(model: TableModel) {
        editeAlert.status = model.status
        nameLab.text = model.deskName
        numberLab.text = model.dinersNum
        if model.status == "1" {
            //启用
            statusLab.textColor = HCOLOR("#2AD389")
            statusLab.text = "On"
        } else {
            statusLab.textColor = HCOLOR("#FC7050")
            statusLab.text = "Off"
        }
    }
    
    
    
    
}
