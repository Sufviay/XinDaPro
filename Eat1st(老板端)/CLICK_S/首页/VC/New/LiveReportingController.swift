//
//  LiveReportingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit
import RxSwift
import MJRefresh


class LiveReportingController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    //数据model
    private var dataModel = ReportModel()
    
    ///订单数量的数据
    private var numModel = OrderNumModel()
    
    
    //选择的日期 默认是当天
    private var dateStr: String = Date().getString("yyyy-MM-dd")
    
    ///区间截止日期  默认“”
    private var endDateStr: String = ""
    
    //控制展开和收起
    private var showOrNot: [Bool] = [false, false, false, false, false]
    
    //营业状态
    private var onLineStatus: Bool = false
    
    
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
            self.getReportingData_Net()
            
        }
        
        return view
    }()
    

    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(OnlineStatusCell.self, forCellReuseIdentifier: "OnlineStatusCell")
        tableView.register(LiveRepotingCell.self, forCellReuseIdentifier: "LiveRepotingCell")
        tableView.register(DateHeaderCell.self, forCellReuseIdentifier: "DateHeaderCell")
        tableView.register(SelectDateCell.self, forCellReuseIdentifier: "SelectDateCell")
        tableView.register(StatisticalHeaderCell.self, forCellReuseIdentifier: "StatisticalHeaderCell")
        tableView.register(StatisticalDataCell.self, forCellReuseIdentifier: "StatisticalDataCell")
        tableView.register(StatisticalChartsCell.self, forCellReuseIdentifier: "StatisticalChartsCell")
        tableView.register(StatisticalBottomCell.self, forCellReuseIdentifier: "StatisticalBottomCell")
        tableView.register(StatisticalOrderNumCell.self, forCellReuseIdentifier: "StatisticalOrderNumCell")
        tableView.register(StatisticalUnfulfilledDateCell.self, forCellReuseIdentifier: "StatisticalUnfulfilledDateCell")
        tableView.register(StatisticalFeeCell.self, forCellReuseIdentifier: "StatisticalFeeCell")
        tableView.register(StatisticalRefundHeaderCell.self, forCellReuseIdentifier: "StatisticalRefundHeaderCell")
        tableView.register(StatisticalRefundCell.self, forCellReuseIdentifier: "StatisticalRefundCell")
        return tableView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        getReportingData_Net()
    }
    
    private func setUpUI() {
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(S_H - bottomBarH - statusBarH - 130)
        }
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.getReportingData_Net()
        }
    }
    
    
    
    
    //MARK: - delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if UserDefaults.standard.userAuth == "2" {
                //有设置权限
                return 1
            } else {
                return 0
            }
        }
        
        if section == 1 {
            return 7
        }
        
        if section == 4 {
            if dateStr == Date().getString("YYYY-MM-dd") {
                return 0
            }
        }
        
        if section == 5 || section == 7 || section == 8 || section == 9 {
             
            if showOrNot[section - 5] {
                return 2
            }
        }
        
        
        if section == 6 {
            if showOrNot[section - 5] {
                return 3
            }
        }
        
        if section == 10 {
            //取消饼状图
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }
        
        if indexPath.section == 1 {
            return 50
        }
        
        if indexPath.section == 2 {
            return 50
        }
        if indexPath.section == 3 {
            return 40
        }
        if indexPath.section == 4 {
                        
            return 35
        }
        if indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 8 || indexPath.section == 9 {
            if indexPath.row == 0 {
                return 55
            }
            if indexPath.row == 1 {
                return 240
            }
            if indexPath.row == 2 {
                return 75
            }
        }
       
        if indexPath.section == 7 {
            if indexPath.row == 0 {
                return 55
            }
            if indexPath.row == 1 {
                return 75
            }
        }
        
        if indexPath.section == 10 {
            return 570
        }
        
        if indexPath.section == 11 {
            return 60
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineStatusCell") as! OnlineStatusCell
            cell.setCellData(isOnLine: self.onLineStatus)
            return cell
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRepotingCell") as! LiveRepotingCell
                cell.setCellData(titStr: "Real time order")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalOrderNumCell") as! StatisticalOrderNumCell
                cell.setCellData(idx: indexPath.row, model: numModel)
                return cell
            }
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRepotingCell") as! LiveRepotingCell
            cell.setCellData(titStr: "Live Reporting")
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateHeaderCell") as! DateHeaderCell
            cell.setCellData(dateStr: dateStr)
            
            cell.clickBlock = { [unowned self] (str) in
                
                if str == "other" {
                    //弹出日历选择
                    self.calendarView.appearAction()
                }
                if str == "today" {
                    //切换回当天
                    self.dateStr = Date().getString("yyyy-MM-dd")
                    self.endDateStr = ""
                    self.table.reloadData()
                    self.getReportingData_Net()
                }
            }
            
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDateCell") as! SelectDateCell
            cell.setCellData(dateStr: dateStr, endDateStr: endDateStr)
            
            cell.clickBlock = { [unowned self] (_) in
                //弹出日历
                self.calendarView.appearAction()
            }
            return cell
        }
        
        if indexPath.section == 5 || indexPath.section == 6  {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalHeaderCell") as! StatisticalHeaderCell
                cell.setCellData(section: indexPath.section, isShow: self.showOrNot[indexPath.section - 5], model: dataModel)
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalDataCell") as! StatisticalDataCell
                cell.setCellData(section: indexPath.section, model: dataModel)
                return cell
            }
            
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalFeeCell") as! StatisticalFeeCell
                cell.setCellData(de_fee: dataModel.deliveryFee, ser_fee: dataModel.serviceFee, bag_fee: dataModel.packFee)
                return cell
            }
        }
        
        if indexPath.section == 7 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalRefundHeaderCell") as! StatisticalRefundHeaderCell
                cell.setCellData(isShow: self.showOrNot[indexPath.section - 5])
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalRefundCell") as! StatisticalRefundCell
                cell.setCellData(money: dataModel.refundSum, num: dataModel.refundNum)
                return cell
            }
            
        }
        
        
        if indexPath.section == 8 || indexPath.section == 9 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalHeaderCell") as! StatisticalHeaderCell
                cell.setCellData(section: indexPath.section, isShow: self.showOrNot[indexPath.section - 5], model: dataModel)
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalUnfulfilledDateCell") as! StatisticalUnfulfilledDateCell
                cell.setCellData(section: indexPath.section, model: dataModel)
                return cell
            }

        }
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalChartsCell") as! StatisticalChartsCell
            //cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalBottomCell") as! StatisticalBottomCell
            
            cell.clickBlock = { [unowned self] (_) in
                self.table.setContentOffset(.zero, animated: true)
            }
            
            return cell
        }
        
        
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 8 || indexPath.section == 9 {
            if indexPath.row == 0 {
                showOrNot[indexPath.section - 5] = !showOrNot[indexPath.section - 5]
                self.table.reloadData()
            }
        }
    }
    

}


extension LiveReportingController {
    
    
    //MARK: - 网络请求
    
    ///请求数据
    private func getReportingData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getLiveReportingData(date: dateStr, end: endDateStr).subscribe(onNext: { (json) in
            self.dataModel.updateModel(json: json["data"])
            self.getOnlineStatus_Net()

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
        
    }
    
    
    //获取店铺营业状态
    private func getOnlineStatus_Net() {
        HTTPTOOl.getStoreOnlineStatus().subscribe(onNext: { (json) in
            
            self.onLineStatus = json["data"]["statusId"].stringValue == "1" ? true : false
            self.getOrderNum_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    //获取实时订单数量
    private func getOrderNum_Net() {
        HTTPTOOl.getOrderNumber().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.numModel.updateModel(json: json["data"])
            self.table.reloadData()
            self.table.mj_header?.endRefreshing()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
}
