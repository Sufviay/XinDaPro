//
//  SuggestListController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/13.
//

import UIKit
import RxSwift
import MJRefresh





class SuggestListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var page: Int = 1
    
    private var dataArr: [SuggestionModel] = []
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        return view
    }()


    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
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
        tableView.register(SuggestionContentCell.self, forCellReuseIdentifier: "SuggestionContentCell")
        tableView.register(SuggestionReplyCell.self, forCellReuseIdentifier: "SuggestionReplyCell")
        return tableView
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    override func setNavi() {
        self.naviBar.headerTitle = "Suggestion List"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(10)
            $0.top.equalTo(naviBar.snp.bottom)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(line.snp.bottom)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
        
        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }

        
    }
    
    

    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getSuggestList(page: 1).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            var tArr: [SuggestionModel] = []
            for jsonData in json["data"].arrayValue {
                let model = SuggestionModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
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
        HTTPTOOl.getSuggestList(page: page).subscribe(onNext: { (json) in

            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = SuggestionModel()
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

extension SuggestListController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return dataArr[indexPath.section].content_H
        }
        return dataArr[indexPath.section].reply_H
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataArr[section].replyStatus == "1" {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionContentCell") as! SuggestionContentCell
            cell.setCellData(model: dataArr[indexPath.section])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionReplyCell") as! SuggestionReplyCell
        cell.setCellData(model: dataArr[indexPath.section])
        return cell
    }

}
