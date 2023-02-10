//
//  CouponListController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/22.
//

import UIKit
import RxSwift
import MJRefresh

class CouponListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()    
    private var dataArr: [CouponModel] = []

    
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
        tableView.register(CouponContentCell.self, forCellReuseIdentifier: "CouponContentCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    

    override func setNavi() {
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.headerTitle = "Coupon"
        self.naviBar.rightBut.isHidden = true
        loadData_Net()
    }
    
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func setViews() {
        
        setUpUI()
        
    }
    
    private func setUpUI() {
        self.view.backgroundColor = HCOLOR("#F7F7F7")
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
    }

}

extension CouponListController {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cell_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponContentCell") as! CouponContentCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickRuleBlock = { (_) in
            self.dataArr[indexPath.row].ruleIsOpen = !self.dataArr[indexPath.row].ruleIsOpen
            self.table.reloadData()
        }
        
        
        return cell
    }

}

extension CouponListController {
    
    private func loadData_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getMyCouponList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var tarr: [CouponModel] = []
            for jsonData in json["data"].arrayValue {
                
                let model = CouponModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            
            self.dataArr = tarr
            if self.dataArr.count == 0 {
                self.table.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            self.table.reloadData()
            self.table.mj_header?.endRefreshing()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
}
