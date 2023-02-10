//
//  FirstController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import RxSwift
import MJRefresh



class FirstController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    ///店铺Model
    private var salesModelArr: [StoreSalesModel] = []
    ///销售金额
    private var salesMoney: String = "0.00"
    ///销售数量
    private var orderNum: String = "0"
    
    
    //选择的日期 默认是当天
    private var dateStr: String = Date().getString("yyyy-MM-dd")
    
    ///区间截止日期  默认“”
    private var endDateStr: String = ""
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
        return view
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(SelectDateCell.self, forCellReuseIdentifier: "SelectDateCell")
        tableView.register(SalesOrderCell.self, forCellReuseIdentifier: "SalesOrderCell")
        tableView.register(StoreSalesCell.self, forCellReuseIdentifier: "StoreSalesCell")
        
        return tableView
    }()
    
    
    //日历弹窗
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        
        view.clickDateBlock = { [unowned self] (par) in
            
            let dateArr: [String] = par as! [String]
            
            if dateArr.count > 1 {
                self.dateStr = dateArr[0]
                self.endDateStr = dateArr[1]
            } else {
                self.dateStr =  dateArr[0]
                self.endDateStr = ""
            }
            self.table.reloadData()
            self.loadData_Net()
        }
        
        return view
    }()

    

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_leftbut"), for: .normal)
        self.biaoTiLab.text = "Eat1st\nManagement center"
        
    }

    
    override func setViews() {
        
        self.view.backgroundColor = .white
        leftBut.addTarget(self, action: #selector(clickSideBarAction), for: .touchUpInside)
        setUpUI()
        self.loadData_Net()
    }
    
    
    @objc private func clickSideBarAction() {
        sideBar.appearAction()
        
    }
    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 90)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        
    }



}


extension FirstController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return salesModelArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        if indexPath.section == 1 {
            return 50
        }
        if indexPath.section == 2 {
            return 90
        }
        
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDateCell") as! SelectDateCell
            cell.setCellData(dateStr: dateStr, endDateStr: endDateStr)
            
            cell.clickBlock = { [unowned self] (_) in
                //弹出日历
                self.calendarView.appearAction()
            }

            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderCell") as! SalesOrderCell
            cell.setCellData(money: salesMoney, order: orderNum)
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreSalesCell") as! StoreSalesCell
            cell.setCellData(model: salesModelArr[indexPath.row])
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let model = salesModelArr[indexPath.row]
            let nextVC = StoreSalesController()
            nextVC.titStr = model.storeName
            nextVC.storeID = model.storeID
            nextVC.dateStr = self.dateStr
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}

extension FirstController {
    
    //网络请求
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getAllStoreSales(date: dateStr).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.salesMoney = D_2_STR(json["data"]["salesAmount"].doubleValue)
            self.orderNum = json["data"]["salesNum"].stringValue == "" ? "0": json["data"]["salesNum"].stringValue
            var tArr: [StoreSalesModel] = []
            for jsonData in json["data"]["salesStoreList"].arrayValue {
                
                let model = StoreSalesModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.salesModelArr = tArr
            self.table.mj_header?.endRefreshing()
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
}


