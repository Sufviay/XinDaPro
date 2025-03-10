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

    
    private var printerID: String = "" {
        didSet {
            if printerID == "" {
                titlab.text = "Add"
            } else {
                titlab.text = "Edite"
            }
        }
    }
    
    
    
    
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
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = ""
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
        
        return tableView
    }()

    
    
    
    
    
    
    private lazy var nameView: InputView = {
        let view = InputView()
        view.setStyle(titStr: "Printer name", holderStr: "")
        view.editBlock = { [unowned self] (str) in
            printerName = str
        }
        return view
    }()
    
    private lazy var ipView: InputView = {
        let view = InputView()
        view.setStyle(titStr: "Printer IP", holderStr: "")
        view.editBlock = { [unowned self] (str) in
            printerIP = str
        }
        return view
    }()
    
    private lazy var copyView: SelectBut_4 = {
        let view = SelectBut_4()
        view.setStyle(titStr: "Print copies", str1: "Print one copy", str2: "Print two copies", str3: "Print three copies", str4: "Print four copies")
        view.clickBlock = { [unowned self] (str) in
            printNum = str
        }
        return view
    }()
    
    
    private lazy var printTypeView: SelectBut = {
        let view = SelectBut()
        view.setStyle(titStr: "Whether to print separately", l_Str: "YES", r_Str: "NO")
        view.clickBlock = { [unowned self] (str) in
            if str == "1" {
                splitType = "2"
            } else {
                splitType = "1"
            }
        }
        return view
    }()

    private lazy var printerTypeView: SelectBut_3 = {
        let view = SelectBut_3()
        view.setStyle(titStr: "Printer type", str1: "Thermal printer", str2: "Dot matrix printer", str3: "Label printer")
        view.clickBlock = { [unowned self] (str) in
            printerType = str
        }
        return view
    }()

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        //addNotification()
        
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
        
        
//        backView.addSubview(nameView)
//        nameView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.height.equalTo(70)
//            $0.top.equalTo(line.snp.bottom).offset(25)
//        }
//        
//        
//        backView.addSubview(ipView)
//        ipView.snp.makeConstraints {
//            $0.left.right.height.equalTo(nameView)
//            $0.top.equalTo(nameView.snp.bottom).offset(15)
//        }
//        
//        backView.addSubview(copyView)
//        copyView.snp.makeConstraints {
//            $0.left.right.equalTo(nameView)
//            $0.height.equalTo(105)
//            $0.top.equalTo(ipView.snp.bottom).offset(15)
//        }
//        
//        backView.addSubview(printTypeView)
//        printTypeView.snp.makeConstraints {
//            $0.left.right.height.equalTo(nameView)
//            $0.top.equalTo(copyView.snp.bottom).offset(15)
//        }
//        
//        backView.addSubview(printerTypeView)
//        printerTypeView.snp.makeConstraints {
//            $0.left.right.equalTo(nameView)
//            $0.height.equalTo(105)
//            $0.top.equalTo(printTypeView.snp.bottom).offset(15)
//        }
//              
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
    
    
//    //添加监听
//    func addNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        //获取键盘高度
//        let userInfo: Dictionary = notification.userInfo!
//        let value = userInfo["UIKeyboardFrameEndUserInfoKey"]
//        let keyboardRec = (value as AnyObject).cgRectValue
//        let height = keyboardRec?.size.height ?? 0
//        
//        self.backView.snp.updateConstraints {
//            $0.bottom.equalToSuperview().offset(-(height - 115 - 200))
//        }
//    }
//    
//    @objc func keyboardWillHiden(notification: NSNotification) {
//        self.backView.snp.updateConstraints {
//            $0.bottom.equalToSuperview()
//        }
//    }
    
    
    func setData(model: PrinterModel) {
        
        dataModel = model
        if model.printerId == "" {
            titlab.text = "Add"
        } else {
            titlab.text = "Edit"
        }

        table.reloadData()
        
//        printerID = model.printerId
//    
//        status = model.status
//        //printerName = model.name
//        printerIP = model.ip
//        printNum = model.printNum
//        printerType = model.printType
//        splitType = model.splitType
//        
//        //nameView.inputTF.text = model.name
//        ipView.inputTF.text = model.ip
//        copyView.selectIdx = model.printNum
//        printerTypeView.selectIdx = model.printType
//        
//        var type: String = ""
//        if model.splitType == "2" {
//            type = "1"
//        }
//        if model.splitType == "1" {
//            type = "2"
//        }
//        
//        printTypeView.selectIdx = type
//        
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
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 {
            return 80
        }
        
        if indexPath.row == 3 || indexPath.row == 6 {
            return 105
        }
        
        if indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 {
            return 90
        }
        
        if indexPath.row == 7 {
            return 105
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            
            if indexPath.row == 0 {
                cell.setCellData(titStr: "Simplified Chinese name", msgStr: dataModel.nameCn)
            }
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Traditional Chinese name", msgStr: dataModel.nameHk)
            }
            if indexPath.row == 2 {
                cell.setCellData(titStr: "English name", msgStr: dataModel.nameEn)
            }
            if indexPath.row == 4 {
                cell.setCellData(titStr: "Printer IP", msgStr: dataModel.ip)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.row == 0 {
                    self.dataModel.nameCn = text
                }
                if indexPath.row == 1 {
                    self.dataModel.nameHk = text
                }
                if indexPath.row == 2 {
                    self.dataModel.nameEn = text
                }
                if indexPath.row == 4 {
                    dataModel.ip = text
                }
            }
            
            return cell
        }
        
        if indexPath.row == 3 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectThreeButCell") as! SelectThreeButCell
            
            if indexPath.row == 3 {
                cell.setCellData(titStr: "Printer type", str1: "Thermal printer", str2: "Dot matrix printer", str3: "Label printer", selectType: dataModel.printType)
            }
            if indexPath.row == 6 {
                cell.setCellData(titStr: "Print language", str1: "Chinese", str2: "English", str3: "Chinese and English", selectType: dataModel.langType)

            }
            
            cell.clickBlock = { [unowned self] (str) in
                
                if indexPath.row == 3 {
                    dataModel.printType = str
                }
                if indexPath.row == 6 {
                    dataModel.langType = str
                }
                
            }

            return cell
        }
        
        if indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            if indexPath.row == 5 {
                cell.setChooseCellData(titStr: "Main printer", l_str: "Enable", r_Str: "Disable", statusID: dataModel.printMain)
            }
            if indexPath.row == 8 {
                cell.setChooseCellData(titStr: "Print separately", l_str: "Enable", r_Str: "Disable", statusID: dataModel.splitType)
            }
            if indexPath.row == 9 {
                cell.setChooseCellData(titStr: "Dim Sum", l_str: "Enable", r_Str: "Diable", statusID: dataModel.dimType)

            }
            if indexPath.row == 10 {
                cell.setChooseCellData(titStr: "Status", l_str: "Enable", r_Str: "Disable", statusID: dataModel.status)
            }

            cell.selectBlock = { [unowned self] (str) in
                if indexPath.row == 5 {
                    dataModel.printMain = str
                }
                if indexPath.row == 8 {
                    dataModel.splitType = str
                }
                if indexPath.row == 9 {
                    dataModel.dimType = str
                }
                if indexPath.row == 10 {
                    dataModel.status = str
                }
                table.reloadData()
                
            }
            return cell
        }
        
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFourButCell") as! SelectFourButCell
            cell.setCellData(titStr: "Print copies", str1: "Print one copy", str2: "Print two copies", str3: "Print three copies", str4: "Print four copies", selectType: dataModel.printNum)
            cell.clickBlock = { [unowned self] (str) in
                dataModel.printNum = str
            }

            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }

}
