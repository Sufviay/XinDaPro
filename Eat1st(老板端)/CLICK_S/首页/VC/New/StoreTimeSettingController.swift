//
//  StoreTimeSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit
import RxSwift

class StoreTimeSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {


    private let bag = DisposeBag()
    
    private var sectionCount: Int = 0
    
    private var dataModel = StoreOpeningModel()
    
    private var busyArr: [BusyTimeModel] = []
    
    private var rangeModel = TimeRangeModel()
    
    private var onLineStatus: Bool = false
    
    private lazy var inputTimeAlert: InPutAlert = {
        let view = InPutAlert()
        
        view.enterBlock = { [unowned self] (arr) in
            let typeStr = (arr as! [Any])[0] as! String
            let time = (arr as! [Any])[1] as! String
            
            var type: String = ""
            var minTime: String = ""
            var maxTime: String = ""
            
            if typeStr == "deMin" {
                type = "1"
                minTime = time
                maxTime = self.rangeModel.deMax
            }
            if typeStr == "deMax" {
                type = "1"
                minTime = self.rangeModel.deMin
                maxTime = time
            }
            if typeStr == "coMin" {
                type = "2"
                minTime = time
                maxTime = self.rangeModel.coMax
            }
            if typeStr == "coMax" {
                type = "2"
                minTime = self.rangeModel.coMin
                maxTime = time
            }
            
            self.setRangeTime_Net(type: type, minTime: minTime, maxTime: maxTime)
        }
        
        return view
    }()
    
    private lazy var timeAlert: TimeSelectView = {
        let view = TimeSelectView()
        
        view.clickBlock = { [unowned self] (arr) in
            let typeStr = (arr as! [Any])[0] as! String
            let idx = (arr as! [Any])[1] as! Int
            let time = (arr as! [Any])[2] as! String
            
            var starTime: String = ""
            var endTime: String = ""
            var openID: String = ""
            var type: String = ""
            
            if typeStr == "des" {
                starTime = time
                endTime = self.dataModel.timeArr[idx].deliveryEnd
                openID = self.dataModel.timeArr[idx].id
                type = "1"

            }
            if typeStr == "dee" {
                endTime = time
                starTime = self.dataModel.timeArr[idx].deliveryBegin
                openID = self.dataModel.timeArr[idx].id
                type = "1"

            }
            if typeStr == "cos" {
                starTime = time
                endTime = self.dataModel.timeArr[idx].takeEnd
                openID = self.dataModel.timeArr[idx].id
                type = "2"
            }
            if typeStr == "coe" {
                endTime = time
                starTime = self.dataModel.timeArr[idx].takeBegin
                openID = self.dataModel.timeArr[idx].id
                type = "2"

            }
            self.setTime_Net(starTime: starTime, endTime: endTime, timeID: openID, type: type)
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
                
        tableView.register(SetTimeOnlineStatusCell.self, forCellReuseIdentifier: "SetTimeOnlineStatusCell")
        tableView.register(SetTimeBusyTimeCell.self, forCellReuseIdentifier: "SetTimeBusyTimeCell")
        tableView.register(SetTimeDeCoTimeRangCell.self, forCellReuseIdentifier: "SetTimeDeCoTimeRangCell")
        tableView.register(SetTimeDayTimeCell.self, forCellReuseIdentifier: "SetTimeDayTimeCell")
        
        
        return tableView
        
    }()
    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
        loadData_Net()
    }
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Opening hours"
        
    }
    
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
    }
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreOpeningHours().subscribe(onNext: { (json) in
            
            //self.sectionCount = 4
            self.dataModel.updateModel(json: json["data"])
            self.getBusyTime_Net()
            //self.table.reloadData()
        
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //获取繁忙时间
    private func getBusyTime_Net() {
        HTTPTOOl.getBusyTimeList().subscribe(onNext: { (json) in
            
            var tArr: [BusyTimeModel] = []
            for jsondata in json["data"].arrayValue {
                let model = BusyTimeModel()
                model.updateModel(json: jsondata)
                tArr.append(model)
            }
            self.busyArr = tArr
            self.getTimeRange_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //获取时间范围
    private func getTimeRange_Net() {
        HTTPTOOl.getTimeRange().subscribe(onNext: { (json) in
            
            self.rangeModel.updateModel(json: json["data"])
            HUD_MB.dissmiss(onView: self.view)
            self.getOnlineStatus_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //获取店铺营业状态
    private func getOnlineStatus_Net() {
        HTTPTOOl.getStoreOnlineStatus().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.onLineStatus = json["data"]["statusId"].stringValue == "1" ? true : false
            self.sectionCount = 4
            self.table.reloadData()

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    //设置时间
    private func setTime_Net(starTime: String, endTime: String, timeID: String, type: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setOpeningHours(starTime: starTime, endTime: endTime, timeID: timeID, type: type).subscribe(onNext: { (json) in
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //设置每天的营业状态
    private func setOpenStatusByDay_Net(id: String, coStatus: String, deStatus: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setStoreOpenStatusByDay(timeID: id, coStatus: coStatus, deStatus: deStatus).subscribe(onNext: { (json) in
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //设置总的营业时间
    private func setOpenStatus(cStatus: String, dStatus: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setStoreOpenStatus(coStatuts: cStatus, deStatus: dStatus).subscribe(onNext: { (json) in
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //设置繁忙时间
    private func setBusyTime_Net(busyID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setBusyTime(busyID: busyID).subscribe(onNext: { (json) in
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    //设置范围时间
    private func setRangeTime_Net(type: String, minTime: String, maxTime: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setRangeTime(type: type, minTime: minTime, maxTime: maxTime).subscribe(onNext: { (json) in
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}

extension StoreTimeSettingController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return 1
        }
        
        if section == 2 {
            return 1
        }
        
        if section == 3 {
            return dataModel.timeArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return 110
        }
        
        if indexPath.section == 1 {
            return CGFloat(60 + (35 * busyArr.count))
        }
        
        if indexPath.section == 2 {
            return 155
        }
        
        if indexPath.section == 3 {
            return 135
        }
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTimeOnlineStatusCell") as! SetTimeOnlineStatusCell
            
            cell.setCellData(model: dataModel, onLineStatus: onLineStatus)
            
            cell.clickCSWBlock = { [unowned self] (type) in
                let d_S = self.dataModel.z_de_status ? "1" : "2"
                let c_S = type as! String
                self.setOpenStatus(cStatus: c_S, dStatus: d_S)
            }
            cell.clickDSWBlock = { [unowned self] (type) in
                let c_S = self.dataModel.z_co_status ? "1" : "2"
                let d_S = type as! String
                self.setOpenStatus(cStatus: c_S, dStatus: d_S)
            }

            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTimeBusyTimeCell") as! SetTimeBusyTimeCell
            cell.setCellData(modelArr: busyArr)
            cell.selectBlock = { [unowned self] (busyID) in
                self.setBusyTime_Net(busyID: busyID as! String)
            }

            
            return cell
        }
        
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTimeDeCoTimeRangCell") as! SetTimeDeCoTimeRangCell
            cell.setCellData(model: rangeModel)

            cell.clickBlock = { [unowned self] (type) in
                self.inputTimeAlert.inputTF.text = ""
                self.inputTimeAlert.type = type as! String
                self.inputTimeAlert.appearAction()
            }
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTimeDayTimeCell") as! SetTimeDayTimeCell
            
                cell.setCellData(model: dataModel.timeArr[indexPath.row])
                cell.clickBlock = { [unowned self] (type) in
                    self.timeAlert.idx = indexPath.row
                    self.timeAlert.type = type as! String
                    self.timeAlert.appearAction()
                }
    
                cell.clickDSWBlock = { [unowned self] (type) in
                    let id = self.dataModel.timeArr[indexPath.row].id
                    let cStatus = self.dataModel.timeArr[indexPath.row].takeIsOpen ? "1" : "2"
                    let dStatus = type as! String
                    self.setOpenStatusByDay_Net(id: id, coStatus: cStatus, deStatus: dStatus)
                }
    
                cell.clickCSWBlock = { [unowned self] (type) in
                    let id = self.dataModel.timeArr[indexPath.row].id
                    let dStatus = self.dataModel.timeArr[indexPath.row].deliveryIsOpen ? "1" : "2"
                    let cStatus = type as! String
                    self.setOpenStatusByDay_Net(id: id, coStatus: cStatus, deStatus: dStatus)
                }
    

            return cell
        }
        

    else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetStoreStatusCell") as! SetStoreStatusCell
            cell.setCellData(model: dataModel)
            
            cell.clickCSWBlock = { [unowned self] (type) in
                let d_S = self.dataModel.z_de_status ? "1" : "2"
                let c_S = type as! String
                self.setOpenStatus(cStatus: c_S, dStatus: d_S)
            }
            cell.clickDSWBlock = { [unowned self] (type) in
                let c_S = self.dataModel.z_co_status ? "1" : "2"
                let d_S = type as! String
                self.setOpenStatus(cStatus: c_S, dStatus: d_S)
            }

            return cell
        }
    }
    
}
