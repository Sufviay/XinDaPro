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
    
    private let copiesLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.text = "Print copies: 1"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let printerTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.text = "Printer type: Thermal printer"
        //"Needle printer"
        lab.numberOfLines = 0
        return lab
    }()
    


    private let printTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.text = "Whether to print separately: YES"
        //"Needle printer"
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
        
        contentView.addSubview(printerTypeLab)
        printerTypeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(nameLab.snp.bottom).offset(10)
        }

        
        contentView.addSubview(ipLab)
        ipLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(printerTypeLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(copiesLab)
        copiesLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(ipLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(printTypeLab)
        printTypeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(copiesLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.top.equalTo(printTypeLab.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
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
            statusLab.textColor = HCOLOR("#2AD389")
            statusLab.text = "On"
        } else {
            statusLab.textColor = HCOLOR("#FC7050")
            statusLab.text = "Off"
        }

        nameLab.text = model.name
        ipLab.text = "IP: \(model.ip)"
        copiesLab.text = "Print copies: \(model.printNum)"
        
        if model.printType == "1" {
            printerTypeLab.text = "Printer type: Thermal printer"
        } else if model.printType == "2" {
            printerTypeLab.text = "Printer type: Dot matrix printer"
        } else {
            printerTypeLab.text = "Printer type: Label printer"
        }
        
        if model.splitType == "2" {
            printTypeLab.text = "Whether to print separately: YES"
        } else {
            printTypeLab.text = "Whether to print separately: NO"
        }
        
    }
    

}
