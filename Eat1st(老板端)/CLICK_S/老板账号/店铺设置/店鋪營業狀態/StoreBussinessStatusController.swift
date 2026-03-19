//
//  StoreBussinessStatusController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/3/17.
//

import UIKit
import RxSwift


class StoreBussinessStatusController: LBBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    private let bag = DisposeBag()
    
    private var timeArr: [BusyTimeModel] = []
    private var selectTime = BusyTimeModel()
    
    private var ubArr: [platformStatusModel] = []
    private var deArr: [platformStatusModel] = []
    
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
        tableView.register(PlatformNameCell.self, forCellReuseIdentifier: "PlatformNameCell")
        tableView.register(PlatformSelectCell.self, forCellReuseIdentifier: "PlatformSelectCell")
        tableView.register(PlatformSwitchCell.self, forCellReuseIdentifier: "PlatformSwitchCell")
        return tableView
    }()

    
    private lazy var timeAlert: BusyTimSelectAlert = {
        let view = BusyTimSelectAlert()
        view.clickSaveBlock = { [unowned self] (_) in
            loadEat1stData_Net()
        }
        return view
    }()
    

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Business status".local
    
    }

    
    override func setViews() {
        setUpUI()
        loadEat1stData_Net()
        loadDeliverooData_Net()
        loadUberData_Net()
    }
    
    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backView).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return 55
            }
        }
        
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        
        if section == 1 {
            if deArr.count == 0 {
                return 0
            } else {
                return deArr.count + 1
            }
        }

        
        if section == 2 {
            if ubArr.count == 0 {
                return 0
            } else {
                return ubArr.count + 1
            }
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformNameCell") as! PlatformNameCell
            
            if indexPath.section == 0 {
                cell.titLab.text = "Eat1st"
            }
            if indexPath.section == 1 {
                cell.titLab.text = "Deliveroo"
            }
            if indexPath.section == 2 {
                cell.titLab.text = "UberEat"
            }
            
            return cell

        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformSelectCell") as! PlatformSelectCell
            cell.selectLab.text = selectTime.busyName
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformSwitchCell") as! PlatformSwitchCell
        
        if indexPath.section == 2 {
            cell.setCellData(model: ubArr[indexPath.row - 1])
            cell.clickBlock = { [unowned self] _ in
                var msg = ""
                if ubArr[indexPath.row - 1].onLine {
                    msg = "Are you sure you want to close it?".local
                } else {
                    msg = "Are you sure you want to open it?".local
                }
                
                showSystemChooseAlert("Alert".local, msg, "Confirm".local, "Cancel".local) { [unowned self] in
                    //改變狀態
                    setUber_Net(selModel: ubArr[indexPath.row - 1])
                }
            }
            
        }
        
        
        if indexPath.section == 1 {
            cell.setCellData(model: deArr[indexPath.row - 1])
            cell.clickBlock = { [unowned self] _ in
                var msg = ""
                if deArr[indexPath.row - 1].onLine {
                    msg = "Are you sure you want to close it?".local
                } else {
                    msg = "Are you sure you want to open it?".local
                }
                
                showSystemChooseAlert("Alert".local, msg, "Confirm".local, "Cancel".local) { [unowned self] in
                    //改變狀態
                    setDeliveroo_Net(selModel: deArr[indexPath.row - 1])
                }
            }

        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            timeAlert.setAlertData(data: timeArr, idx_s: selectTime.idx)
            timeAlert.appearAction()
        }
    }
    
    
    
    private func loadEat1stData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreBusyTimeList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            var tarr: [BusyTimeModel] = []
            for (idx, jsondata) in json["data"].arrayValue.enumerated() {
                let model = BusyTimeModel()
                model.updateModel(json: jsondata)
                
                if model.select == "1" {
                    selectTime = model
                }
                model.idx = idx
                tarr.append(model)
            }
            timeArr = tarr
            table.reloadData()

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    private func loadDeliverooData_Net() {
        HTTPTOOl.getDeliverooStatus().subscribe(onNext: { [unowned self] (json) in
            var tarr: [platformStatusModel] = []
            for jsondata in json["data"]["siteStatusList"].arrayValue {
                let model = platformStatusModel()
                model.updateDeliverooModel(json: jsondata)
                tarr.append(model)
            }
            deArr = tarr
            table.reloadData()
            

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    private func loadUberData_Net() {
        HTTPTOOl.getUberStatus().subscribe(onNext: { [unowned self] (json) in
            var tarr: [platformStatusModel] = []
            for jsondata in json["data"].arrayValue {
                let model = platformStatusModel()
                model.updateUberModel(json: jsondata)
                tarr.append(model)
            }
            ubArr = tarr
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    private func setUber_Net(selModel: platformStatusModel)  {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setUberStatus(model: selModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            loadUberData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
        
    }
    
    private func setDeliveroo_Net(selModel: platformStatusModel)  {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setDeliverooStatus(model: selModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            loadDeliverooData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
        
    }

    
}
