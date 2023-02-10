//
//  StoreReviewsController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/25.
//

import UIKit
import MJRefresh
import RxSwift

class StoreReviewsController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    var storeID: String = ""
    
    private var page: Int = 1
    
    private var dataArr: [ReviewsModel] = []
    
    private lazy var table: GestureTableView = {
        let tableView = GestureTableView()
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
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

        tableView.register(StoreReviewsCell.self, forCellReuseIdentifier: "StoreReviewsCell")
        tableView.register(StoreReplyCell.self, forCellReuseIdentifier: "StoreReplyCell")
//        tableView.register(SpecificationsCell.self, forCellReuseIdentifier: "SpecificationsCell")
        
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("F7F7F7")
        view.addSubview(table)
        loadData_Net()
        
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(7)
            $0.bottom.equalToSuperview()
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Reviews"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - 网络请求
    private  func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getReviewsList(storeID: storeID, page: 1).subscribe(onNext: { (json) in
            
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            
            var tempArr: [ReviewsModel] = []
            for jsondata in json["data"].arrayValue {
                let model = ReviewsModel()
                model.updateModel(json: jsondata)
                tempArr.append(model)
            }
            self.dataArr = tempArr
            
            if self.dataArr.count == 0 {
                self.table.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            
            self.table.reloadData()
            self.table.mj_header?.endRefreshing()
            self.table.mj_footer?.resetNoMoreData()

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    private func loadDataMore_Net() {
        HTTPTOOl.getReviewsList(storeID: storeID, page: page).subscribe(onNext: { (json) in
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = ReviewsModel()
                    model.updateModel(json: jsonData)
                    self.dataArr.append(model)
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

extension StoreReviewsController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model = dataArr[section]
        
        if model.isReply {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if dataArr[indexPath.section].plContent == "" {
                return 145
            } else {
                return dataArr[indexPath.section].plContent.getTextHeigh(SFONT(14), S_W - 40) + 60 + 85
            }
            
        } else {
            return dataArr[indexPath.section].replyContent.getTextHeigh(SFONT(13), S_W - 60) + 75
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = table.dequeueReusableCell(withIdentifier: "StoreReviewsCell") as! StoreReviewsCell
            cell.setCellData(model: dataArr[indexPath.section])
            return cell

        }
        
        let cell = table.dequeueReusableCell(withIdentifier: "StoreReplyCell") as! StoreReplyCell
        cell.setCellData(model: dataArr[indexPath.section])
        return cell
    }
    
}

