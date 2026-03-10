//
//  SalesIncomeListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/4.
//

import UIKit
import RxSwift
import SwiftyJSON

class SalesIncomeListController: XSBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    private var dataArr: [IncomeRecordModel] = []
    private var page: Int = 1
    
    var storeId: String = ""
    var storeName: String = "" {
        didSet {
            storeLab.text = storeName
        }
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.setCommonShadow()
        return view
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#2968FE")
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let storeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_16, .left)
        lab.adjustsFontSizeToFitWidth = true
        return lab
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
        tableView.register(SalesIncomeCell.self, forCellReuseIdentifier: "SalesIncomeCell")
        return tableView
    }()

    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()


    override func setNavi() {
        leftBut.setImage(LOIMG("xs_nav_back"), for: .normal)
        biaoTiLab.text = "Commission Record"
    }

    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(statusBarH + 70)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 5)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.size.equalTo(CGSize(width: 4, height: 15))
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(storeLab)
        storeLab.snp.makeConstraints {
            $0.centerY.equalTo(line)
            $0.left.equalTo(line.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            if storeId == "" {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalToSuperview().offset(50)
            }
            
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }

        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesIncomeCell") as! SalesIncomeCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = SalesIncomeDetailController()
        let model = dataArr[indexPath.row]
        nextVC.beginTime = model.beginTime.changeDateStr()
        nextVC.endTime = model.endTime.changeDateStr()

        if storeId == "" {
            nextVC.needLoad = true
        } else {
            if model.detailList.count != 0 {
                let detailModel = IncomeDetailModel()
                detailModel.updateModel(recordModel: model)
                nextVC.dataArr = [detailModel]
            }
            
            nextVC.needLoad = false
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }

    
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }

        if storeId != "" {
            HTTPTOOl.salesGetCommissionRecordListByStore(storeId: storeId, page: 1).subscribe(onNext:{ [unowned self] (json) in
                updateData(json: json)
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_header?.endRefreshing()
            }).disposed(by: bag)
        } else {
            
            HTTPTOOl.salseGetCommissionRecordSumList(page: 1).subscribe(onNext: { [unowned self] (json) in
                updateData(json: json)
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_header?.endRefreshing()
            }).disposed(by: bag)
            
        }
        
    }
    
    private func updateData(json: JSON) {
        HUD_MB.dissmiss(onView: view)
        page = 2
        
        var tarr: [IncomeRecordModel] = []
        for jsonData in json["data"].arrayValue {
            let model = IncomeRecordModel()
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
        table.mj_footer?.resetNoMoreData()
    }
    
     
    
    private func loadDataMore_Net() {
        
        if storeId != "" {
            HTTPTOOl.salesGetCommissionRecordListByStore(storeId: storeId, page: page).subscribe(onNext: { [unowned self] (json) in
                updateDataMore(json: json)
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_footer?.endRefreshing()
            }).disposed(by: bag)

        } else {
            HTTPTOOl.salseGetCommissionRecordSumList(page: page).subscribe(onNext: { [unowned self] (json) in
                updateDataMore(json: json)
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_footer?.endRefreshing()
            }).disposed(by: bag)

        }
        
    }
    
    private func updateDataMore(json: JSON) {
        if json["data"].arrayValue.count == 0 {
            table.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            self.page += 1
            for jsonData in json["data"].arrayValue {
                let model = IncomeRecordModel()
                model.updateModel(json: jsonData)
                dataArr.append(model)
            }
            table.reloadData()
            table.mj_footer?.endRefreshing()
        }

    }
    
}
