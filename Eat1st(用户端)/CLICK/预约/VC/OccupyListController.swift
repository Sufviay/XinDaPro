//
//  OccupyListController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/12.
//

import UIKit
import RxSwift
import MJRefresh

class OccupyListController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    private var dataArr: [OccupyListModel] = []
    
    ///分页
    private var page: Int = 1
    
    override func setNavi() {
        naviBar.headerTitle = "Reservations"
        naviBar.rightBut.isHidden = true
        naviBar.leftImg = LOIMG("nav_back")
    }
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = true
        tableView.register(OccupyListCell.self, forCellReuseIdentifier: "OccupyListCell")

        return tableView
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F6F9")
        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            loadDataMore_Net()
        }

        
    }
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OccupyListCell") as! OccupyListCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.cancelBlock = { [unowned self] (_) in
            
            showSystemChooseAlert("Alert", "Are you sure you want to cancel?", "YES", "NO") { [unowned self] in
                cancelAction_Net(idx: indexPath.row)
            } _: {}
        }
        
        return cell
    }
    

}

extension OccupyListController {
    
    //MARK: - 网络请求
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getUserOccupyList(page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            var tArr: [OccupyListModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OccupyListModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            if dataArr.count == 0 {
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
        HTTPTOOl.getUserOccupyList(page: page).subscribe(onNext: {[unowned self] (json) in

            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                page += 1
                for jsonData in json["data"].arrayValue {
                    let model = OccupyListModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_footer?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    //MARK: - 取消预约
    private func cancelAction_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCancelOccupy(id: dataArr[idx].userReserveId).subscribe(onNext: { [unowned self] (json) in
            dataArr[idx].reserveStatus = "3"
            table.reloadData()
            HUD_MB.showSuccess("Cancelled", onView: view)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
}
