//
//  OtherPlatformOrdersController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/27.
//

import UIKit
import RxSwift

class OtherPlatformOrdersController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    ///1:deliveroo,2:UberEats,3:justEat
    var platformType: String = ""
    
    private var dataArr: [OrderDetailModel] = []
    
    private let bag = DisposeBag()
    
    
    private var page: Int = 1
    
//    private var dateType: String = "3"
    
    //默認當前月
    var startDate: String = Date().getString("yyyy-MM") + "-01"
    var endDate: String = DateTool.getMonthLastDate(monthStr: Date().getString("yyyy-MM"))

    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    

    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        //tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OrderListCell.self, forCellReuseIdentifier: "OrderListCell")
        return tableView
    }()


    

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationCenter()
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(S_H - statusBarH - bottomBarH - 250)
        }
        
        loadData_Net()
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].orderListCell_H
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell") as! OrderListCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = OrderDetailController()
        nextVC.orderID = dataArr[indexPath.row].id
        nextVC.souceType = dataArr[indexPath.row].source
        navigationController?.pushViewController(nextVC, animated: true)
    }
    

    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HTTPTOOl.getAllOrderList(start: startDate, end: endDate, source: platformType, userID: "", payType: "", status: "", page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            var tArr: [OrderDetailModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OrderDetailModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            dataArr = tArr
            if dataArr.count == 0 {
                table.layoutIfNeeded()
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            
            table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getAllOrderList(start: startDate, end: endDate, source: platformType, userID: "", payType: "", status: "", page: page).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = OrderDetailModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_footer?.endRefreshing()
        }).disposed(by: bag)
    }


    

    
    //添加通知
    private func addNotificationCenter() {
        //监测消息的变化
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: NSNotification.Name(rawValue: "TimeChange"), object: nil)
    }
    
    
    @objc private func receiveNotification() {
        
//        if let info = notification.userInfo, let typeMsg = info["type"] as? String , let startMsg = info["start"] as? String, let endMsg = info["end"] as? String {
//            dateType = typeMsg
//            
//            if dateType == "3" {
//                //月
//                startDate = startMsg + "-01"
//                endDate = DateTool.getMonthLastDate(monthStr: startMsg)
//            } else if dateType == "1" {
//                startDate = startMsg
//                endDate = startMsg
//
//            } else {
//                startDate = startMsg
//                endDate = endMsg
//            }
            loadData_Net()
 //       }
    }
    
    
    deinit {
        print("\(self.classForCoder)销毁")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TimeChange"), object: nil)
    }

    
    
}
