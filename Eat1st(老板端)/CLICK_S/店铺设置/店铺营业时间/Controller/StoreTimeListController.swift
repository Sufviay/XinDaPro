//
//  StoreTimeListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit
import RxSwift


class StoreTimeListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {


    private let bag = DisposeBag()
    
    private var timeArr: [DayTimeModel] = []
    
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
                
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        tableView.register(OpeningTimeListCell.self, forCellReuseIdentifier: "OpeningTimeListCell")
        
        return tableView
        
    }()

    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
    }

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Opening hours"
        loadData_Net()
    }

    
    private func setUpUI() {
        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }

    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 1
        }
        return timeArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 150
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! AddItemCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningTimeListCell") as! OpeningTimeListCell
        cell.setCellData(model: timeArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            if type == "detail" {
                //详情
                let detailVC = StoreTimeDetailController()
                detailVC.timeModel = self.timeArr[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            if type == "edit" {
                //编辑
                let editVC = AddStoreTimeController()
                editVC.timeModel = self.timeArr[indexPath.row]
                self.navigationController?.pushViewController(editVC, animated: true)
            }
            
            if type == "edit dish" {
                //编辑菜品
                let editDishVC = StoreTimeBindingDishController()
                editDishVC.timeID = self.timeArr[indexPath.row].timeId
                self.navigationController?.pushViewController(editDishVC, animated: true)
            }

            if type == "canUse" {
                //禁用启用
                self.canUseAction_Net(timeID: self.timeArr[indexPath.row].timeId)
            }
            
            if type == "delete" {
                //删除
                self.showSystemChooseAlert("Tip", "Delete or not", "Delete", "Cancel") {
                    self.deleteAction_Net(timeID: self.timeArr[indexPath.row].timeId)
                }
                
            }
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            //添加
            let nextVC = AddStoreTimeController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 0 {
            let detailVC = StoreTimeDetailController()
            detailVC.timeModel = timeArr[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreOpeningHours().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var tArr: [DayTimeModel] = []
            for jsondata in json["data"]["openTimeValList"].arrayValue {
                let model = DayTimeModel()
                model.updateModel(json: jsondata)
                model.updateTimeListModel(relationJsonArr: json["data"]["openTimeWeekList"].arrayValue)
                tArr.append(model)
            }
            self.timeArr = tArr
            self.table.reloadData()
        
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    private func deleteAction_Net(timeID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteOpeningHours(timeID: timeID).subscribe(onNext: { json in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func canUseAction_Net(timeID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.openingHoursCanUse(timeID: timeID).subscribe(onNext: { json in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

}
