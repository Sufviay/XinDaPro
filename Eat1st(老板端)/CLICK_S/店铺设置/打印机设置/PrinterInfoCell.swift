//
//  PrinterInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit

class PrinterInfoCell: BaseTableViewCell {

    var clickMoreBlock: VoidBlock?
    
    
    private var dataModel = PrinterModel()
    
    private lazy var editeAlert: MoreAlert = {
        let alert = MoreAlert()
        
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
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "name"
        return lab
    }()
    
    ///打印機類型
    private let printerTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Printer type: Thermal printer"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    ///打印機iP
    private let ipLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "IP:192.168.1.1"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
//    //是否為主打印機
//    private let mainPrinterLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
//        lab.text = "Main printer: YES"
//        lab.lineBreakMode = .byTruncatingTail
//        return lab
//    }()
    
    
    ///打印語言
    private let printLanguageLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Print language: Chinese"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()

    
    
    ///打印份兒數
    private let copiesLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Print copies: 1"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    

    ///打印類型
    private let printTypeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Print separately: YES"
        //"Needle printer"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    //是否點心
    private let printDXLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Print dessert: YES"
        //"Needle printer"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    //是否點心
    private let printSouceLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.text = "Print souce: JustEat"
        //"Needle printer"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    ///打印機狀態
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), TIT_3, .left)
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
        
        
//        contentView.addSubview(mainPrinterLab)
//        mainPrinterLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-80)
//            $0.top.equalTo(ipLab.snp.bottom).offset(5)
//        }
        
        contentView.addSubview(printLanguageLab)
        printLanguageLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(ipLab.snp.bottom).offset(5)
        }


        
        contentView.addSubview(copiesLab)
        copiesLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(printLanguageLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(printTypeLab)
        printTypeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(copiesLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(printDXLab)
        printDXLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(printTypeLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(printSouceLab)
        printSouceLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
            $0.top.equalTo(printDXLab.snp.bottom).offset(5)
        }



        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.top.equalTo(printSouceLab.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
        }
       
        
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)

        
    }
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        editeAlert.alertType = .printer
        editeAlert.statusType = dataModel.status
        editeAlert.tap_H = cret.minY
        self.editeAlert.appearAction()
    }
    
    
    func setCellData(model: PrinterModel) {
        
        
        dataModel = model
        

        if MyLanguageManager.shared.language == .Chinese {
            nameLab.text = model.nameHk
        } else {
            nameLab.text = model.nameEn
        }
        
        
        if model.printType == "1" {
            printerTypeLab.text = "Printer type".local + ": " +  "Thermal printer".local
        } else if model.printType == "2" {
            printerTypeLab.text = "Printer type".local + ": " + "Dot matrix printer".local
        } else {
            printerTypeLab.text = "Printer type".local + ": " + "Label printer".local
        }

        

        ipLab.text = "IP: \(model.ip)"
        
//        if model.printMain == "2" {
//            //是
//            mainPrinterLab.text = "Main printer: Enable"
//        } else {
//            mainPrinterLab.text = "Main printer: Disable"
//        }
        
        
        if model.langType == "1" {
            //中文
            printLanguageLab.text = "Print language".local + ": " + "Chinese".local
        } else if model.langType == "2" {
            //英文
            printLanguageLab.text = "Print language".local + ": " + "English".local
        } else {
            //英文和中文
            printLanguageLab.text = "Print language".local + ": " + "Chinese and English".local
        }
        
        
        copiesLab.text = "Print copies".local + ": \(model.printNum)"
        
        
        if model.splitType == "2" {
            printTypeLab.text = "Print separately".local + ": " + "Enable".local
        } else {
            printTypeLab.text = "Print separately".local + ": " + "Disable".local
        }
        
        
        if model.dimType == "2" {
            printDXLab.text = "Dim Sum".local + ": " + "Enable".local
        } else {
            printDXLab.text = "Dim Sum".local + ": " + "Disable".local
        }
        
        if model.status == "1" {
            //启用
            statusLab.textColor = HCOLOR("#2AD389")
            statusLab.text = "Enable".local
        } else {
            statusLab.textColor = HCOLOR("#FC7050")
            statusLab.text = "Disable".local
        }
        
        var souceStr = ""
        if model.printSource != "" {
            souceStr = model.printSource
            
            let souceArr = model.printSource.components(separatedBy: ",")
            if souceArr.contains("1") {
                souceStr = souceStr.replacingOccurrences(of: "1", with: "Deliveroo")
            }
            if souceArr.contains("2") {
                souceStr = souceStr.replacingOccurrences(of: "2", with: "UberEats")
            }
            if souceArr.contains("3") {
                souceStr = souceStr.replacingOccurrences(of: "3", with: "JustEat")
            }
            printSouceLab.text = "Print souce".local + ": " + souceStr
        } else {
            printSouceLab.text = "Print souce".local + ": " + "--"
        }
                
    }
}
