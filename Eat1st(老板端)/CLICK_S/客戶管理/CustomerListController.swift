//
//  CustomerListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/17.
//

import UIKit
import RxSwift

class CustomerListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    private var dataArr: [UserModel] = []
    
    private var page: Int = 1
    
    ///1：下单数量 2：下单金额 3：最后下单日期
    private var sortBy: String = ""
    ///排序顺序 1：正序 2：倒序
    private var sortAsc: String = ""
    
    private var dateType: String = "3"
    
    
    //默認當前月
    private var startDate: String = Date().getString("yyyy-MM") + "-01"
    private var endDate: String = DateTool.getMonthLastDate(monthStr: Date().getString("yyyy-MM"))
    

    
    
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
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(CustomListInfoCell.self, forCellReuseIdentifier: "CustomListInfoCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()
    
    //篩選框
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        view.initFiltrateViewDateType(dateType: "3")
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
        
            if str == "Week".local {
                dateType = "2"
            }
            if str == "Day".local {
                dateType = "1"
            }
            if str == "Month".local {
                dateType = "3"
            }
        }
        
        
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (arr) in
            let dateArr = arr as! [String]
            print(dateArr[0])
            print(dateArr[1])
            
            if dateType == "3" {
                //月
                startDate = dateArr[0] + "-01"
                endDate = DateTool.getMonthLastDate(monthStr: dateArr[0])
            } else if dateType == "1" {
                startDate = dateArr[0]
                endDate = dateArr[0]

            } else {
                startDate = dateArr[0]
                endDate = dateArr[1]
            }
            
            loadData_Net()
        }
        
        return view
    }()

    
    private lazy var headerView: CustomerHeaderView = {
        let view = CustomerHeaderView()
        
        view.clickBlock = { [unowned self] (info) in
            
            sortBy = (info as! [String: String])["sortBy"]!
            sortAsc = (info as! [String: String])["sortAsc"]!
            
            print("sortBy:" + sortBy)
            print("sortAsc:" + sortAsc)
            loadData_Net()
        }
        
        return view
    }()



    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Customer Management".local
        loadData_Net()
    }

    
    override func setViews() {
        setUpUI()
    }

    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(filtrateView.snp.bottom).offset(15)
        }
        
        

        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }
    }

    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].listCell_H
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CustomListInfoCell") as! CustomListInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        cell.clickMoreBlock = { [unowned self] (type) in
            if type == "detail" {
                //進入詳情
                let vc = CustomerDetailController()
                vc.customerData = dataArr[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
            if type == "order" {
                //訂單
                let orderVC = OrderListController()
                orderVC.userID = dataArr[indexPath.row].userId
                navigationController?.pushViewController(orderVC, animated: true)

            }
            
            if type == "tag" {
                //编辑标签
                let tagVC = LinkTagsContorller()
                tagVC.selectTags = dataArr[indexPath.row].tagList
                tagVC.userID = dataArr[indexPath.row].userId
                navigationController?.pushViewController(tagVC, animated: true)
            }
        }
        
        return cell
    }
    

    
    
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HTTPTOOl.getCustomerList(page: 1, start: startDate, end: endDate, sortAsc: sortAsc, sortBy: sortBy).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            var tArr: [UserModel] = []
            for jsonData in json["data"].arrayValue {
                let model = UserModel()
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
        HTTPTOOl.getCustomerList(page: page, start: startDate, end: endDate, sortAsc: sortAsc, sortBy: sortBy).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                page += 1
                for jsonData in json["data"].arrayValue {
                    let model = UserModel()
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

    
        
}
