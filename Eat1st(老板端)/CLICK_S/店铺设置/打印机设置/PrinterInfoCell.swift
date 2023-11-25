//
//  PrinterInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit

class PrinterInfoCell: BaseTableViewCell {

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
        lab.text = "name"
        return lab
    }()
    
    private let ipLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.text = "IP:192.168.1.1"
        lab.numberOfLines = 0
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
        
        contentView.addSubview(ipLab)
        ipLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
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
    
    
    func setCellData(model: PrinterModel) {
        editeAlert.status = model.status
        if model.status == "1" {
            //启用
            nameLab.textColor = .black
            ipLab.textColor = HCOLOR("#666666")
        } else {
            //禁用
            nameLab.textColor = HCOLOR("#CCCCCC")
            ipLab.textColor = HCOLOR("#CCCCCC")
        }
        
        nameLab.text = model.name
        ipLab.text = "IP:\(model.ip)"
    }
    

}
