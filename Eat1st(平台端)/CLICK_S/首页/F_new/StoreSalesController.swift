//
//  StoreSalesController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/11/15.
//

import UIKit
import RxSwift
import MJRefresh

class StoreSalesController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    private let bag = DisposeBag()

    var titStr: String = ""
    ///店铺ID
    var storeID: String = ""
    ///日期
    var dateStr: String = ""
    ///区间截止日期  默认“”
    private var endDateStr: String = ""

    ///分类ID
    private var classID: String = ""
    ///分类名字
    private var className: String = ""
    
    private var page: Int = 1
    
    private var salesModelArr: [DishesSalesModel] = []
    
    
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
        tableView.register(SelectClassCell.self, forCellReuseIdentifier: "SelectClassCell")
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
            self.loadData_Net()
        }
        
        return view
    }()

    
    //选择分类
    private lazy var classifyView: DishSelectClassifyView = {
        let view = DishSelectClassifyView()
        
        view.confirmBlock = { [unowned self] (par) in
            let strArr = par as! [String]
            self.classID = strArr[0]
            self.className = strArr[1]
            self.loadData_Net()
        }

        return view
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = titStr
    }


    override func setViews() {
        
        self.view.backgroundColor = .white
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        setUpUI()
        loadData_Net()
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
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

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }

    }
    
}


extension StoreSalesController {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        if indexPath.section == 1 {
            return 50
        }
        if indexPath.section == 2 {
            return 65
        }
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 {
            return 1
        }
        return salesModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            cell.titlab.text = "Dishes ranking"
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDateCell") as! SelectDateCell
            cell.setCellData(dateStr: dateStr, endDateStr: "")
            
            cell.clickBlock = { [unowned self] (_) in
                //弹出日历
                self.calendarView.appearAction()
            }

            return cell

        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectClassCell") as! SelectClassCell
            cell.setCellData(className: self.className)
            cell.clickBlock = { [unowned self] (_) in
                self.classifyView.storeID = self.storeID
                self.classifyView.appearAction()

            }
            return cell
        }
            
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreSalesCell") as! StoreSalesCell
            cell.setDishesCellData(model: salesModelArr[indexPath.row])
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    

}

extension StoreSalesController {
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreDishesSales(cId: classID, sId: storeID, date: dateStr, page: 1).subscribe( onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            
            var tArr: [DishesSalesModel] = []
            for jsonData in json["data"].arrayValue {
                let model = DishesSalesModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            self.salesModelArr = tArr
            self.table.reloadData()
            
            self.table.mj_header?.endRefreshing()
            self.table.mj_footer?.resetNoMoreData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
        
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getStoreDishesSales(cId: classID, sId: storeID, date: dateStr, page: page).subscribe(onNext: { (json) in
            
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = DishesSalesModel()
                    model.updateModel(json: jsonData)
                    self.salesModelArr.append(model)
                }
                self.table.reloadData()
                self.table.mj_footer?.endRefreshing()
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
}
