//
//  MessageListController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit
import RxSwift
import MJRefresh

class MessageListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    let bag = DisposeBag()
    
    private var page: Int = 1
    
    private var dataArr: [MessageModel] = []
    
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
        tableView.register(MessageListCell.self, forCellReuseIdentifier: "MessageListCell")
        return tableView
    }()

    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()


    override func setNavi() {
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.headerTitle = "The message centre"
        self.naviBar.rightBut.isHidden = true
    }
    
    override func setViews() {
        setUpUI()
        addNotificationCenter()
        loadData_Net()
    }
    
    
    private func setUpUI() {
        self.view.backgroundColor = HCOLOR("#F7F6F9")
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(naviBar.snp.bottom).offset(5)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
        
        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }

    }
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - 通知中心
    private func addNotificationCenter() {
        //监测消息的变化
        NotificationCenter.default.addObserver(self, selector: #selector(centerAciton_msg), name: NSNotification.Name(rawValue: "message"), object: nil)
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("message"), object: nil)

    }

    @objc private func centerAciton_msg() {
        self.loadData_Net()
    }
}


extension MessageListController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].list_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell") as! MessageListCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        
        if !model.isRead {
            //未读消息
            //消息设为已读
            model.isRead = true
            self.table.reloadRows(at: [indexPath], with: .none)
            self.doRead_Net(id: model.id)
        }
        let nextVC = MessageDetailController()
        nextVC.dataModel = dataArr[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


extension MessageListController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getMessagesList(page: 1).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            self.page = 2
            var tArr: [MessageModel] = []
            for jsonData in json["data"].arrayValue {
                let model = MessageModel()
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
    
    //MARK: - 网络请求
    private func loadDataMore_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getMessagesList(page: page).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = MessageModel()
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
    
    //消息设为已读
    private func doRead_Net(id: String) {
        HTTPTOOl.doReadMessage(id: id).subscribe(onNext: { (_) in }).disposed(by: self.bag)
    }
    
}
