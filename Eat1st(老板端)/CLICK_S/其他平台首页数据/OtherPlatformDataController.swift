//
//  OtherPlatformDataController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/25.
//

import UIKit
import RxSwift
import MJRefresh

class OtherPlatformDataController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    ///1:deliveroo,2:UberEats,3:justEat
    var platformType: String = ""
    
    private var page: Int = 1
    
    private let bag = DisposeBag()
    
    private var dishArr: [OtherPlatformDishModel] = []
    
    //查询方式 1天，2周，3月
    var dataType: String = "3"

    ///查询日期
    var dateStr: String = DateTool.getDateComponents(date: Date()).month! >= 10 ? "\(DateTool.getDateComponents(date: Date()).year!)-\(DateTool.getDateComponents(date: Date()).month!)" : "\(DateTool.getDateComponents(date: Date()).year!)-0\(DateTool.getDateComponents(date: Date()).month!)"

    ///查询截止日期
    var endDateStr: String = ""
        
//    
//    private lazy var filtrateView: SalesFiltrateView = {
//        let view = SalesFiltrateView()
//        view.initFiltrateViewDateType(dateType: dataType)
//        //选择时间类型
//        view.selectTypeBlock = { [unowned self] (str) in
//            
//            if str == "Week".local {
//                self.dataType = "2"
//            }
//            if str == "Day".local {
//                self.dataType = "1"
//            }
//            if str == "Month".local {
//                self.dataType = "3"
//            }
//        }
//        
//        //选择的时间
//        view.selectTimeBlock = { [unowned self] (arr) in
//            let dateArr = arr as! [String]
//            print(dateArr[0])
//            print(dateArr[1])
//            self.dateStr = dateArr[0]
//            self.endDateStr = dateArr[1]
//            loadData_Net()
//        }
//        
//        return view
//    }()
//
    
    
    private let orderDataView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_5, .left)
        lab.text = "Orders:".local
        return lab
    }()
    
    
    private let orderNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = ""
        return lab
    }()
    
    private let rejectLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_5, .left)
        lab.text = "Reject Orders:".local
        return lab
    }()
    
    
    private let rejectNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = ""
        return lab
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
        tableView.register(OtherPlatformDishCell.self, forCellReuseIdentifier: "OtherPlatformDishCell")
        return tableView
    }()

    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationCenter()
        view.backgroundColor = .white
        setUpUI()
        loadData_Net()

    }
    
    
    
    private func setUpUI() {
        
//        view.addSubview(filtrateView)
//        filtrateView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-20)
//            $0.height.equalTo(40)
//        }

        view.addSubview(orderDataView)
        orderDataView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        }
        
        
        orderDataView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(12)
        }
        
        orderDataView.addSubview(orderNum)
        orderNum.snp.makeConstraints {
            $0.bottom.equalTo(orderLab.snp.bottom).offset(1)
            $0.left.equalTo(orderLab.snp.right).offset(5)
        }

        
        
        orderDataView.addSubview(rejectLab)
        rejectLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(orderDataView.snp.centerX).offset(12)
        }
        
        orderDataView.addSubview(rejectNum)
        rejectNum.snp.makeConstraints {
            $0.bottom.equalTo(rejectLab.snp.bottom).offset(1)
            $0.left.equalTo(rejectLab.snp.right).offset(5)
        }

        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(orderDataView.snp.bottom).offset(15)
            //$0.bottom.equalTo(view.snp.bottom).offset(-25 - bottomBarH)
            $0.height.equalTo(S_H - statusBarH - bottomBarH - 305)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }

        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = dishArr[indexPath.row].name.getTextHeigh(TIT_3, S_W - 120)
        return h + 35
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherPlatformDishCell") as! OtherPlatformDishCell
        cell.setCellData(model: dishArr[indexPath.row], idx: indexPath.row)
        return cell
    }
    

    
    
    
    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
       
        HTTPTOOl.getOtherDishesSummary(page: 1, searchType: dataType, start: dateStr, end: endDateStr, ptType: platformType).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            var tArr: [OtherPlatformDishModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OtherPlatformDishModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            dishArr = tArr
        
            if dishArr.count == 0 {
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
        }).disposed(by: self.bag)
        
        loadOrderData_Net()
    }
    
    
    private func loadOrderData_Net() {
        HTTPTOOl.getOtherOrderSummary(searchType: dataType, start: dateStr, end: endDateStr, ptType: platformType).subscribe(onNext: { [unowned self] (json) in
            
            orderNum.text = json["data"]["orderNum"].stringValue
            rejectNum.text = json["data"]["rejectNum"].stringValue
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            orderNum.text = "0"
            rejectLab.text = "0"
        }).disposed(by: bag)

    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getOtherDishesSummary(page: page, searchType: dataType, start: dateStr, end: endDateStr, ptType: platformType).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = OtherPlatformDishModel()
                    model.updateModel(json: jsonData)
                    dishArr.append(model)
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
        loadData_Net()
    }
    
    
    deinit {
        print("\(self.classForCoder)销毁")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TimeChange"), object: nil)
    }

    
    
}



