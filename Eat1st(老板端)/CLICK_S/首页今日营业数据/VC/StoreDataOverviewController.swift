//
//  StoreDataOverviewController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/3.
//

import UIKit
import RxSwift
import MJRefresh

class StoreDataOverviewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    ///统计类型（1今日，2本周，3本月，不传默认今日）
    private var queryType: String = "1"
    
    //（1关闭，2开启）
    private var dineStatus: String = "1"
        
    private var sectionNum: Int = 0
    
    private var dataModel = SalesDataModel()
    
    private let bag = DisposeBag()
    
    private lazy var headView: DataOverviewHeaderView = {
        let view = DataOverviewHeaderView()
        
        
        view.selectBlock = { [unowned self] (type) in
            
            if type == "day" {
                queryType = "1"
            }
            if type == "week" {
                queryType = "2"
            }
            if type == "month" {
                queryType = "3"
            }
            loadData_Net()
        }
        
        return view
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        //tableView.register(AddDataCell.self, forCellReuseIdentifier: "AddDataCell")
        tableView.register(TakeOutDataCell.self, forCellReuseIdentifier: "TakeOutDataCell")
        tableView.register(DineInDataCell.self, forCellReuseIdentifier: "DineInDataCell")
        tableView.register(OtherDataCell.self, forCellReuseIdentifier: "OtherDataCell")
        return tableView
    }()


    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadData_Net()
    }
    
    
    
    private func setUpUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(headView.snp.bottom).offset(10)
            $0.height.equalTo(S_H - statusBarH - bottomBarH - 130 - 70)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 520
        }
        if indexPath.section == 1 {
            return  305//215
        }
        if indexPath.section == 2 || indexPath.section == 3 {
            return 215
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0  {
            if dineStatus == "1" {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DineInDataCell") as! DineInDataCell
            cell.setCellData(model: dataModel)
            return cell
        }

        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TakeOutDataCell") as! TakeOutDataCell
            cell.setCellData(titStr: "Takeaway".local, model: dataModel)
            return cell
        }
        
        if indexPath.section == 2 || indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherDataCell") as! OtherDataCell
            
            var titStr = ""
            if indexPath.section == 2 {
                titStr = "Uber Eats"
            }
            if indexPath.section == 3 {
                titStr = "Deliveroo"
            }
            
            cell.setCellData(titStr: titStr, model: dataModel)
            return cell
        }
        
        
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    private func loadData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        //请求店铺外卖和堂食的状态
        HTTPTOOl.getStoreInfo().subscribe(onNext: { [unowned self] (json) in
            //堂食状态  （1关闭，2开启）
            dineStatus = json["data"]["dineInType"]["id"].stringValue
            
            if dineStatus == "1" {
                //直接请求外卖的数据
                //外卖
                HTTPTOOl.getStoreSales(queryType: queryType, deliveryType: "1").subscribe(onNext: { [unowned self] (json) in
                    
                    HUD_MB.dissmiss(onView: view)
                    dataModel = SalesDataModel.deserialize(from: json.dictionaryObject!, designatedPath: "data") ?? SalesDataModel()
                    dataModel.updateModel_de(json: json["data"])
                    headView.setDate(date: dataModel.date, time: Date().getString("HH:mm:ss"))
                    table.mj_header?.endRefreshing()
                    sectionNum = 4
                    table.reloadData()
                
                }, onError: { [unowned self] (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                    table.mj_header?.endRefreshing()
                }).disposed(by: bag)
                
            }
            if dineStatus == "2" {
                //要请求外卖的和堂食的数据
                //堂食
                HTTPTOOl.getStoreSales(queryType: queryType, deliveryType: "2").subscribe(onNext: { [unowned self] (json) in
                    
                    dataModel = SalesDataModel.deserialize(from: json.dictionaryObject!, designatedPath: "data") ?? SalesDataModel()
                    dataModel.updateModel_dine()
                    headView.setDate(date: dataModel.date, time: Date().getString("HH:mm:ss"))
                    //外卖
                    HTTPTOOl.getStoreSales(queryType: queryType, deliveryType: "1").subscribe(onNext: { [unowned self] (json) in
                        
                        HUD_MB.dissmiss(onView: view)
                        dataModel.updateModel_de(json: json["data"])
                        
                        table.mj_header?.endRefreshing()
                        sectionNum = 4
                        table.reloadData()
                    
                    }, onError: { [unowned self] (error) in
                        HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                        table.mj_header?.endRefreshing()
                    }).disposed(by: bag)
                    
                }, onError: { [unowned self] (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                    table.mj_header?.endRefreshing()
                }).disposed(by: bag)

            }
            
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
}




