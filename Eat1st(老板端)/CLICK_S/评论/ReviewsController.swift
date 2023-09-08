//
//  ReviewsController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/16.
//

import UIKit
import RxSwift
import MJRefresh

class ReviewsController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private let dataModel = ReviewsModel()

    private var page: Int = 1
    
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
        tableView.register(ReviewsHeaderCell.self, forCellReuseIdentifier: "ReviewsHeaderCell")
        tableView.register(ReviewsCell.self, forCellReuseIdentifier: "ReviewsCell")
        return tableView
    }()

    
    private lazy var replyAlert: ReviewsReplyAlert = {
        let view = ReviewsReplyAlert()
        view.clickConfirmBlock = { [unowned self] _ in
            table.reloadData()
        }
        return view
    }()

    

    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Reviews"
    }

    
    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalToSuperview().offset(20)
        }
        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }

        
    }
    

    @objc private func backAction() {
        
        self.navigationController?.popViewController(animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return dataModel.evaluateList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 260
        }
        
        return dataModel.evaluateList[indexPath.row].cell_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsHeaderCell") as! ReviewsHeaderCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell") as! ReviewsCell
            cell.setCellData(model: dataModel.evaluateList[indexPath.row])
            
            cell.clickDealBlock = { [unowned self] (_) in
                replyAlert.reviewModel = dataModel.evaluateList[indexPath.row]
                replyAlert.appearAction()
            }
            
            cell.clickDetailBlock = { [unowned self] (_) in
                //订单详情
                let detailVC = OrderDetailController()
                detailVC.orderID = dataModel.evaluateList[indexPath.row].orderId
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
}


extension ReviewsController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getReviewsList(page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            dataModel.updateModel(json: json["data"])
            
            table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getReviewsList(page: page).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            if json["data"]["evaluateList"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"]["evaluateList"].arrayValue {
                    let model = ReviewListModel()
                    model.updateModel(json: jsonData)
                    dataModel.evaluateList.append(model)
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
