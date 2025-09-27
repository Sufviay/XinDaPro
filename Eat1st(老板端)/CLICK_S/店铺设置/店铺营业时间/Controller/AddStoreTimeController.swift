//
//  AddStoreTimeController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit
import RxSwift

class AddStoreTimeController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    var timeModel = DayTimeModel() {
        didSet {

            dataModel.storeTimeId = timeModel.timeId
            dataModel.nameCn = timeModel.nameCn
            dataModel.nameHk = timeModel.nameHk
            dataModel.nameEn = timeModel.nameEn
            
            dataModel.startTime = timeModel.startTime
            dataModel.endTime = timeModel.endTime
            
            dataModel.collectStatus = timeModel.coStatus
            dataModel.collectMin = timeModel.coMin
            dataModel.collectMax = timeModel.coMax
            
            dataModel.deliverStatus = timeModel.deStatus
            dataModel.deliverMax = timeModel.deMax
            dataModel.deliverMin = timeModel.deMin
            
            dataModel.status = timeModel.status
        
            dataModel.weekTypeList.removeAll()
            for type in timeModel.timeSelectWeek {
                let dic = ["weekType": type]
                dataModel.weekTypeList.append(dic)
            }
            self.table.reloadData()
        }
    }
    
    
    private var dataModel = AddTimeSubmitModel()
    
    
    ///选择时间
    private lazy var selectTimeAlert: TimeSelectView = {
        let view = TimeSelectView()
        
        view.clickBlock = { [unowned self] (par) in
            
            let typeStr = (par as! [Any])[0] as! String
            let time = (par as! [Any])[1] as! String

            if typeStr == "start" {
                self.dataModel.startTime = time
            }
            if typeStr == "end" {
                self.dataModel.endTime = time
            }
            self.table.reloadData()
        }
        return view
    }()

    ///填写时间
    private lazy var inputTimeAlert: InPutAlert = {
        let view = InPutAlert()
        
        view.enterBlock = { [unowned self] (par) in
            let deOrCo = (par as! [Any])[0] as! String
            let minOrMax = (par as! [Any])[1] as! String
            let time = (par as! [Any])[2] as! String
            
            if deOrCo == "de" {
                if minOrMax == "min" {
                    self.dataModel.deliverMin = time
                }
                if minOrMax == "max" {
                    self.dataModel.deliverMax = time
                }
            }
            if deOrCo == "co" {
                if minOrMax == "min" {
                    self.dataModel.collectMin = time
                }
                if minOrMax == "max" {
                    self.dataModel.collectMax = time
                }
            }
            self.table.reloadData()
        }
        
        return view
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
                
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(OpeningHoursInputCell.self, forCellReuseIdentifier: "OpeningHoursInputCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(OpeningHoursInputTimeCell.self, forCellReuseIdentifier: "OpeningHoursInputTimeCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(SelectWeekCell.self, forCellReuseIdentifier: "SelectWeekCell")
        return tableView
        
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, MAINCOLOR, TIT_2, .clear)
        but.clipsToBounds = true
        but.layer.cornerRadius = 14
        but.layer.borderWidth = 2
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.clipsToBounds = true
        but.layer.cornerRadius = 14
        return but
    }()


    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
    }

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Opening hours".local

    }


    private func setUpUI() {
    
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo((S_W - 60) / 2)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.size.bottom.height.equalTo(cancelBut)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
        }
        
        leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickCancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSaveAction() {
        
        //保存
        if dataModel.nameCn == "" {
            HUD_MB.showWarnig("Please fill in the simplified Chinese name!".local, onView: self.view)
            return
        }
        
        if dataModel.nameHk == "" {
            HUD_MB.showWarnig("Please fill in the traditional Chinese name!".local, onView: self.view)
            return
        }
        
        if dataModel.nameEn == "" {
            HUD_MB.showWarnig("Please fill in the English name!".local, onView: self.view)
            return
        }
        
        if dataModel.startTime == "" || dataModel.endTime == "" {
            HUD_MB.showWarnig("Please fill in the business hours!".local, onView: self.view)
            return
        }
        
        if dataModel.deliverStatus == "" {
            HUD_MB.showWarnig("Please select delivery status!".local, onView: self.view)
            return
        }
        if dataModel.deliverStatus == "1" {
            if dataModel.deliverMin == "" || dataModel.deliverMax == "" {
                HUD_MB.showWarnig("Please fill in the delivery time!".local, onView: self.view)
                return
            }
        }
        
        if dataModel.collectStatus == "" {
            HUD_MB.showWarnig("Please select collection status!".local, onView: self.view)
            return
        }
        if dataModel.collectStatus == "1" {
            if dataModel.collectMin == "" || dataModel.collectMax == ""  {
                HUD_MB.showWarnig("Please fill in the collection time!".local, onView: self.view)
                return
            }
        }
        
        if dataModel.status == "" {
            HUD_MB.showWarnig("Select whether to enable it!".local, onView: self.view)
            return
        }
        if dataModel.weekTypeList.count == 0 {
            HUD_MB.showWarnig("Please select the week!".local, onView: self.view)
            return
        }

        addAction_Net()
        
    }

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 4 {
            if dataModel.deliverStatus == "1" {
                return 2
            } else {
                return 1
            }
        }
        
        if section == 5 {
            if dataModel.collectStatus == "1" {
                return 2
            } else {
                return 1
            }
        }
        if section == 8 {
            return 7
        }
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
            return 80
        }
        if indexPath.section == 3 {
            return 90
        }
        if indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 {
            if indexPath.row == 0 {
                return 90
            } else {
                return 35
            }
        }
        if indexPath.section == 7 {
            return 50
        }
        if indexPath.section == 8 {
            return 45
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            if indexPath.section == 0 {
                cell.setCellData(titStr: "Simplified Chinese name".local, msgStr: dataModel.nameCn)
            }
            if indexPath.section == 1 {
                cell.setCellData(titStr: "Traditional Chinese name".local, msgStr: dataModel.nameHk)
            }
            if indexPath.section == 2 {
                cell.setCellData(titStr: "English name".local, msgStr: dataModel.nameEn)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.section == 0 {
                    self.dataModel.nameCn = text
                }
                if indexPath.section == 1 {
                    self.dataModel.nameHk = text
                }
                if indexPath.section == 2 {
                    self.dataModel.nameEn = text
                }
            }
            
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursInputCell") as! OpeningHoursInputCell
            cell.setCellData(titStr: "Opening time".local, star: dataModel.startTime, end: dataModel.endTime)
            
            cell.clickBlock = { [unowned self] (type) in
                self.selectTimeAlert.type = type
                self.selectTimeAlert.appearAction()
            }
            
            return cell
        }
        
        if indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                
                if indexPath.section == 4 {
                    cell.setChooseCellData(titStr: "Delivery".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.deliverStatus)
                }
                if indexPath.section == 5 {
                    cell.setChooseCellData(titStr: "Collection".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.collectStatus)
                }
                if indexPath.section == 6 {
                    cell.setChooseCellData(titStr: "Status".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.status)
                }
                
                cell.selectBlock = { [unowned self] (status) in
                    if indexPath.section == 4 {
                        self.dataModel.deliverStatus = status
                        if status == "2" {
                            self.dataModel.deliverMin = "0"
                            self.dataModel.deliverMax = "0"
                        }
                    }
                    
                    if indexPath.section == 5 {
                        self.dataModel.collectStatus = status
                        if status == "2" {
                            self.dataModel.collectMin = "0"
                            self.dataModel.collectMax = "0"
                        }
                    }
                    
                    if indexPath.section == 6 {
                        self.dataModel.status = status
                    }
                    self.table.reloadData()
                }
            
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursInputTimeCell") as! OpeningHoursInputTimeCell
                if indexPath.section == 4 {
                    cell.setCellData(titStr: "Delivery".local + ":", maxStr: dataModel.deliverMax, minStr: dataModel.deliverMin)
                }
                if indexPath.section == 5 {
                    cell.setCellData(titStr: "Collection".local + ":", maxStr: dataModel.collectMax, minStr: dataModel.collectMin)
                }
                
                cell.clickBlock = { [unowned self] (type) in
                    self.inputTimeAlert.minOrMax = type
                    if indexPath.section == 4 {
                        self.inputTimeAlert.deOrCo = "de"
                    }
                    if indexPath.section == 5 {
                        self.inputTimeAlert.deOrCo = "co"
                    }
                    self.inputTimeAlert.appearAction()
                }
            
                return cell
            }
        }
        
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            return cell
        }
        
        if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWeekCell") as! SelectWeekCell
            
            var isSelect: Bool = false
            for dic in dataModel.weekTypeList {
                let weekType = dic["weekType"]
                if weekType == indexPath.row + 1 {
                    isSelect = true
                    break
                }
            }
            
            cell.setCellData(idx: indexPath.row, select: isSelect)
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 8 {
            
            //是否已经选择
            var isSelect: Bool = false
            for dic in dataModel.weekTypeList {
                let weekType = dic["weekType"]
                if weekType == indexPath.row + 1 {
                    isSelect = true
                    break
                }
            }
            
            if isSelect {
                dataModel.weekTypeList = dataModel.weekTypeList.filter { $0["weekType"] != indexPath.row + 1 }
            } else {
                dataModel.weekTypeList.append(["weekType": indexPath.row + 1])
            }
            self.table.reloadData()
        }
    }
    
    
    
    ///保存添加
    private func addAction_Net() {
        HUD_MB.loading("", onView: view)
        
        if dataModel.storeTimeId == "" {
            ///添加
            HTTPTOOl.addOpeningHours(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.showSuccess("Success", onView: self.view)
                DispatchQueue.main.after(time: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        } else {
            ///编辑
            HTTPTOOl.editOpeningHours(model: dataModel).subscribe(onNext: { json in
                HUD_MB.showSuccess("Success", onView: self.view)
                DispatchQueue.main.after(time: .now() + 1.5) {
                
                    for vc in self.navigationController!.viewControllers {
                        if vc.isKind(of: StoreTimeListController.self) {
                            self.navigationController?.popToViewController(vc, animated: true)
                            break
                        }
                    }
                }

            }, onError: { error in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        

        
    }
    

}
