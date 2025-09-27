//
//  EditPrintAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit
import RxSwift

class EditPrintAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    

    private let bag = DisposeBag()
    
    
    private var dataModel = PrinterModel()
    
    var savedBlock: VoidBlock?
    
    
    private var printNum: String = ""
    ///打印机类型（1热敏，2针式, 3标签）
    private var printerType: String = ""
    ///打印机状态
    private var status: String = ""
    ///打印机名称
    private var printerName: String = ""
    ///是否分开打印 1否，2是
    private var splitType: String = ""
    ///打印机IP
    private var printerIP: String = ""

    
//    private var printerID: String = "" {
//        didSet {
//            if printerID == "" {
//                titlab.text = "Add"
//            } else {
//                titlab.text = "Edite"
//            }
//        }
//    }
    

    
    private var H: CGFloat = S_H - 200

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - 200), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_4, .left)
        lab.text = "Printer".local
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(SelectThreeButCell.self, forCellReuseIdentifier: "SelectThreeButCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(SelectFourButCell.self, forCellReuseIdentifier: "SelectFourButCell")
        tableView.register(PrinterSouceCell.self, forCellReuseIdentifier: "PrinterSouceCell")
        return tableView
    }()


    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 15)
            $0.height.equalTo(50)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab.snp.bottom).offset(7)
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(10)
            $0.bottom.equalTo(saveBut.snp.top).offset(-15)
        }
        
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickCloseAction() {
        self.disAppearAction()
     }
        
    @objc private func clickSaveAction() {

        if dataModel.printerId == "" {
            add_Net()
        } else {
            edite_Net()
        }
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(self.H)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    func appearAction() {
        
        
        addWindow()
    }
    
    func disAppearAction() {
               
        UIApplication.shared.keyWindow?.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func setData(model: PrinterModel) {
        
        dataModel = model
//        if model.printerId == "" {
//            titlab.text = "Add"
//        } else {
//            titlab.text = "Edit"
//        }
        table.reloadData()
        
    }

    
    
    //MARK: - 网络请求
    private func add_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.addPrinter(model: dataModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            savedBlock?("")
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
    
    private func edite_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.editPrinter(model: dataModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            savedBlock?("")
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 || section == 2 {
            return 0
        }
        
        if section == 5 {
            return 0
        }
        
        if section == 11 {
            if dataModel.printerId == "" {
                return 1
            } else {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 4 {
            return 80
        }
        
        if indexPath.section == 3 || indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 10 {
            return 105
        }
        
        if indexPath.section == 5 || indexPath.section == 8 || indexPath.section == 9 || indexPath.section == 11 {
            return 90
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            
            if indexPath.section == 0 {
                cell.setCellData(titStr: "Printer name".local, msgStr: dataModel.nameCn)
            }
            if indexPath.section == 1 {
                cell.setCellData(titStr: "Traditional Chinese name".local, msgStr: dataModel.nameHk)
            }
            if indexPath.section == 2 {
                cell.setCellData(titStr: "English name".local, msgStr: dataModel.nameEn)
            }
            if indexPath.section == 4 {
                cell.setCellData(titStr: "Printer IP".local, msgStr: dataModel.ip)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.section == 0 {
                    self.dataModel.nameCn = text
                    self.dataModel.nameHk = text
                    self.dataModel.nameEn = text
                }
                if indexPath.section == 1 {
                    self.dataModel.nameHk = text
                }
                if indexPath.section == 2 {
                    self.dataModel.nameEn = text
                }
                if indexPath.section == 4 {
                    dataModel.ip = text
                }
            }
            
            return cell
        }
        
        if indexPath.section == 3 || indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectThreeButCell") as! SelectThreeButCell
            
            if indexPath.section == 3 {
                cell.setCellData(titStr: "Printer type".local, str1: "Thermal printer".local, str2: "Dot matrix printer".local, str3: "Label printer".local, selectType: dataModel.printType)
            }
            if indexPath.section == 6 {
                cell.setCellData(titStr: "Print language".local, str1: "Chinese".local, str2: "English".local, str3: "Chinese and English".local, selectType: dataModel.langType)

            }
            
            cell.clickBlock = { [unowned self] (str) in
                
                if indexPath.section == 3 {
                    dataModel.printType = str
                }
                if indexPath.section == 6 {
                    dataModel.langType = str
                }
                
            }

            return cell
        }
        
        if indexPath.section == 5 || indexPath.section == 8 || indexPath.section == 9 || indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            if indexPath.section == 5 {
                cell.setChooseCellData(titStr: "Main printer".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.printMain)
            }
            if indexPath.section == 8 {
                cell.setChooseCellData(titStr: "Print separately".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.splitType)
            }
            if indexPath.section == 9 {
                cell.setChooseCellData(titStr: "Dim Sum".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.dimType)

            }
            if indexPath.section == 11 {
                cell.setChooseCellData(titStr: "Status".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.status)
            }

            cell.selectBlock = { [unowned self] (str) in
                if indexPath.section == 5 {
                    dataModel.printMain = str
                }
                if indexPath.section == 8 {
                    dataModel.splitType = str
                }
                if indexPath.section == 9 {
                    dataModel.dimType = str
                }
                if indexPath.section == 11 {
                    dataModel.status = str
                }
                table.reloadData()
                
            }
            return cell
        }
        
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFourButCell") as! SelectFourButCell
            cell.setCellData(titStr: "Print copies".local, str1: "Print one copy".local, str2: "Print two copies".local, str3: "Print three copies".local, str4: "Print four copies".local, selectType: dataModel.printNum)
            cell.clickBlock = { [unowned self] (str) in
                dataModel.printNum = str
            }

            return cell
        }
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterSouceCell") as! PrinterSouceCell
            cell.setCellData(printSouce: dataModel.printSource)
            cell.clickBlock =  { [unowned self] (str) in
                dataModel.printSource = str
            }
            return cell
        }
        
        
        let cell = UITableViewCell()
        return cell
        
        
    }

}
