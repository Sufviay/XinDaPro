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
    
    private let remarkLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
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
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.top.equalTo(nameLab.snp.bottom).offset(15)
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
