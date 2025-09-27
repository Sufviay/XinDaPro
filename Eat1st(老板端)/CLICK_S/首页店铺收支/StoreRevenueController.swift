//
//  StoreRevenueController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/8/6.
//

import UIKit
import RxSwift
import MJRefresh


class StoreRevenueController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let bag = DisposeBag()
    
    
    //查询方式 1天，2周，3月
    private var dataType: String = "1"

    ///查询日期
    private var dateStr: String = Date().getString("yyyy-MM-dd") //DateTool.getDateComponents(date: Date()).month! >= 10 ? "\(DateTool.getDateComponents(date: Date()).year!)-\(DateTool.getDateComponents(date: Date()).month!)" : "\(DateTool.getDateComponents(date: Date()).year!)-0\(DateTool.getDateComponents(date: Date()).month!)"

    ///查询截止日期
    private var endDateStr: String = ""
    
    private var dataModel = StoreSummaryModel()
    
    
    
    private let titArr1: [String] = ["Tatal Sales", "Dine-in Sales", "Takeaway Sales", "Top Up", "Tips", "Dine-in Customer", "Takeaway Customer", "Reservation"]
    
    private let titArr2: [String] = ["Total Expenditure", "Food Cost", "Staff Wages", "Water Bill", "Electricity Bill", "Gas Bill", "Licenses Fee", "Rent", "Tax", "Misc"]
    
    
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        view.initFiltrateViewDateType(dateType: self.dataType)
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
        
            if str == "Week".local {
                self.dataType = "2"
            }
            if str == "Day".local {
                self.dataType = "1"
            }
            if str == "Month".local {
                self.dataType = "3"
            }
        }
        
        
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (arr) in
            let dateArr = arr as! [String]
            print(dateArr[0])
            print(dateArr[1])
            self.dateStr = dateArr[0]
            self.endDateStr = dateArr[1]
            self.loadData_Net()
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
        tableView.register(StoreTotalAmountCell.self, forCellReuseIdentifier: "StoreTotalAmountCell")
        tableView.register(LiveRepotingCell.self, forCellReuseIdentifier: "LiveRepotingCell")
        tableView.register(StoreAmountChartCell.self, forCellReuseIdentifier: "StoreAmountChartCell")
        tableView.register(StoreAmountDataCell.self, forCellReuseIdentifier: "StoreAmountDataCell")
        tableView.register(StoreOutChartCell.self, forCellReuseIdentifier: "StoreOutChartCell")
        tableView.register(StoreSalesDataCell.self, forCellReuseIdentifier: "StoreSalesDataCell")
        tableView.register(SalesHeaderCell.self, forCellReuseIdentifier: "SalesHeaderCell")
        return tableView
    }()

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
            
        view.backgroundColor = .white
        
        view.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(filtrateView.snp.bottom).offset(10)
            $0.height.equalTo(S_H - bottomBarH - statusBarH - 130 - 55)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
    }

}


extension StoreRevenueController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 0
        }
        
        if section == 1 {
            return 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 75
        }
        
        if indexPath.section == 1 {
            return 50
        }
        
//        if indexPath.section == 2 {
//            return 260
//        }
        
        if indexPath.section == 2 {
            return 50 * CGFloat(dataModel.numberLine) + 60
        }
        
//        if indexPath.section = 4 {
//            return 50
//        }
//        
//        
//        if indexPath.section == 6 {
//            return 45
//        }
//        
//        if indexPath.section == 5 {
//            return 300
//        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTotalAmountCell") as! StoreTotalAmountCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalesHeaderCell") as! SalesHeaderCell
            
            cell.clickBlock = { [unowned self] (_) in
                dataType = "1"
                dateStr = Date().getString("yyyy-MM-dd")
                endDateStr = ""
                filtrateView.reSetDateToToday()
                loadData_Net()
            }
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreSalesDataCell") as! StoreSalesDataCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
//        if indexPath.section == 4 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRepotingCell") as! LiveRepotingCell
//            cell.setCellData(titStr: "Expenditure")
//            return cell
//        }
//        
//        if indexPath.section == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreAmountChartCell") as! StoreAmountChartCell
//            //cell.setCellData(model: dataModel)
//            return cell
//        }
//        
//
//        
//        
//        if  indexPath.section == 6 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreAmountDataCell") as! StoreAmountDataCell
//            //cell.setCellData(titStr: titArr2[indexPath.row], number: dataModel.outArr[indexPath.row])
//            return cell
//        }
//        
//        
//        if indexPath.section == 5 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreOutChartCell") as! StoreOutChartCell
//            //cell.setCellData(model: dataModel)
//            return cell
//        }
        
        let cell = UITableViewCell()
        return cell
    }
    
}


extension StoreRevenueController {
    
    
    //MARK: - 网络请求
    func loadData_Net(_ isLoading: Bool = false) {
        
        if dateStr == "" {
            HUD_MB.showWarnig("Please select a date", onView: view)
            return
        }

        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getPrintSummary(type: dataType, start: dateStr, end: endDateStr).subscribe(onNext: { [unowned self] (json) in
            
            
            dataModel = StoreSummaryModel.deserialize(from: json.dictionaryObject!, designatedPath: "data") ?? StoreSummaryModel()
            HUD_MB.dissmiss(onView: view)
            dataModel.dealModel()
            table.mj_header?.endRefreshing()
            table.reloadData()

            
            
//            HTTPTOOl.getUberSummary(dateType: dataType, start: dateStr, end: endDateStr).subscribe(onNext: { [unowned self] (json) in
//                HUD_MB.dissmiss(onView: view)
//                dataModel.updateModelByUber(json: json)
//                table.mj_header?.endRefreshing()
//                table.reloadData()
//                
//            }, onError: { [unowned self] (error) in
//                table.mj_header?.endRefreshing()
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
//            }).disposed(by: bag)
            
        }, onError: { [unowned self] (error) in
            table.mj_header?.endRefreshing()
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            
        }).disposed(by: bag)
        
    }
    
}
