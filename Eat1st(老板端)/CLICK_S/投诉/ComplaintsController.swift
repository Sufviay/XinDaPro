//
//  ComplaintsController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/16.
//

import UIKit
import RxSwift
import MJRefresh


class ComplaintsController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
        
    private var page: Int = 1
    
    private var dataArr: [ComplaintsModel] = []
    
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
        tableView.register(ComplaintsCell.self, forCellReuseIdentifier: "ComplaintsCell")

        return tableView
    }()
    
    

    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Complaints"
        table.reloadData()
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
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            self.loadData_Net(true)
        }

        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            self.loadDataMore_Net()
        }


        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension ComplaintsController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cell_H //(S_W - 60) / 5 + 10 + 355
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsCell") as! ComplaintsCell
        
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickDealBlock = { [unowned self] (_) in
            //处理投诉
            let nextVC = ComplaintsReplyController()
            nextVC.complaintsData = dataArr[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    
        cell.clickDetailBlock = { [unowned self] (_) in
            //订单详情
            let detailVC = OrderDetailController()
            detailVC.orderID = dataArr[indexPath.row].orderId
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }
        
        cell.clickShowBlock = { [unowned self] (_) in
            //展开
            getComplaintsDetail_Net(idx: indexPath.row)
        }
        
        return cell
    }
    
}


extension ComplaintsController {
    
    //MARK: - 加载数据
    private func loadData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getComplatinsList(page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            var tArr: [ComplaintsModel] = []
            for jsonData in json["data"].arrayValue {
                let model = ComplaintsModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
            self.table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getComplatinsList(page: page).subscribe(onNext: { [unowned self] (json) in        
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = ComplaintsModel()
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
    
    
    func getComplaintsDetail_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getComplatinsDetail(id: dataArr[idx].plaintId).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            dataArr[idx].isShow = true
            dataArr[idx].updateModel_Detail(json: json["data"])
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
}
