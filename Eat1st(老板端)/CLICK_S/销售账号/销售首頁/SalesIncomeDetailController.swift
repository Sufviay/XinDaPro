//
//  SalesIncomeDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/6.
//

import UIKit
import RxSwift

class SalesIncomeDetailController: XSBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let bag = DisposeBag()
    
    var beginTime: String = ""
    var endTime: String = ""
    var dataArr: [IncomeDetailModel] = []
    
    
    var needLoad: Bool = false
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.setCommonShadow()
        return view
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 15
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
        tableView.register(SalesIncomeDetailHeadCell.self, forCellReuseIdentifier: "SalesIncomeDetailHeadCell")
        tableView.register(SalesIncomePlatformCell.self, forCellReuseIdentifier: "SalesIncomePlatformCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()



    override func setNavi() {
        leftBut.setImage(LOIMG("xs_nav_back"), for: .normal)
        biaoTiLab.text = beginTime + " - " + endTime
    }
    
    
    override func setViews() {
        setUpUI()
        
        if !needLoad {
            table.reloadData()
            if dataArr.count == 0 {
                table.layoutIfNeeded()
                table.addSubview(noDataView)
            }
        } else {
            table.mj_header = CustomRefreshHeader() { [unowned self] in
                loadData_Net(true)
            }

            loadData_Net()
        }

    }
    
    func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(statusBarH + 70)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 5)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
    }
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].platform.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 70
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let model = dataArr[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalesIncomeDetailHeadCell") as! SalesIncomeDetailHeadCell
            cell.setCellData(name: model.storeName, money: D_2_STR(model.storeCommission))
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesIncomePlatformCell") as! SalesIncomePlatformCell
        let model = dataArr[indexPath.section].platform[indexPath.row - 1]
        cell.setCellData(model: model)
        return cell
    }
    
    
    
    private func loadData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }

        HTTPTOOl.salseGetCommissionSumDetail(bTime: beginTime, eTime: endTime).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tarr: [IncomeDetailModel] = []
            for jsonData in json["data"].arrayValue {
                let model = IncomeDetailModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            dataArr = tarr
            
            if dataArr.count == 0 {
                table.layoutIfNeeded()
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            table.reloadData()
            table.mj_header?.endRefreshing()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
        
        
        
    }
    
    
        
}
