//
//  OrderListController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/28.
//

import UIKit
import RxSwift
import MJRefresh



class OrderListController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private var dataArr: [OrderListModel] = []
    
    ///分页
    private var page: Int = 1
    
    ///类型 1配送 2自取
    private var orderType: String = "1"

    
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("head_img_1")
        return img
    }()

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
        lab.text = "Your orders"
        return lab
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
//    private lazy var tagView: OrderSelectTagView = {
//        let view = OrderSelectTagView()
//        view.clickTypeBlock = { [unowned self] (type) in
//            self.orderType = type as! String
//            self.loadData_Net()
//        }
//
//        return view
//    }()
    
    
    private lazy var mainTable: UITableView = {
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
        tableView.register(NoButtonOrderCell.self, forCellReuseIdentifier: "NoButtonOrderCell")
        tableView.register(HaveButtonOrderCell.self, forCellReuseIdentifier: "HaveButtonOrderCell")
        
        //tableView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: S_H - statusBarH - 64), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        
        return tableView
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 15), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    

    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.mainTable.bounds
        return view
    }()

    override func setViews() {
        self.naviBar.isHidden = true
        view.backgroundColor = HCOLOR("#F7F7F7")
        addNotificationCenter()
        setUpUI()
    }
    override func setNavi() {
        loadData_Net()
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
     
    
    private func setUpUI() {
        
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(R_H(380))
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        view.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBut)
        }
        
//        view.addSubview(tagView)
//        tagView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalToSuperview().offset(statusBarH + 44)
//            $0.height.equalTo(55)
//        }
        
        
        view.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 64)
            $0.height.equalTo(15)
        }
        
        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 79)
            $0.bottom.equalToSuperview()
        }

        mainTable.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        mainTable.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)

        
    }
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderList(page: 1).subscribe(onNext: {[unowned self] (json) in

            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            

            var tArr: [OrderListModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OrderListModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
            if self.dataArr.count == 0 {
                self.mainTable.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            self.mainTable.reloadData()
            self.mainTable.mj_header?.endRefreshing()
            self.mainTable.mj_footer?.resetNoMoreData()
            
            
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.mainTable.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    private func loadDataMore_Net() {
        HTTPTOOl.getOrderList(page: self.page).subscribe(onNext: {[unowned self] (json) in

            if json["data"].arrayValue.count == 0 {
                self.mainTable.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = OrderListModel()
                    model.updateModel(json: jsonData)
                    self.dataArr.append(model)
                }
                self.mainTable.reloadData()
                self.mainTable.mj_footer?.endRefreshing()
            }
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.mainTable.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    
    ///取消订单
    private func cancelOrder_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderCancelAction(orderID: orderID).subscribe(onNext: {[unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    ///确认订单
    func confiromOrder_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderConfirmAction(orderID: orderID).subscribe(onNext: {[unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //再来一单
    func orderAgain_Net(orderID: String, storeID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderAgain(orderID: orderID).subscribe(onNext: {[unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            //跳转到点餐页面
            let nextVC = StoreMenuOrderController()
            nextVC.storeID = storeID
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 注册通知中心
    private func addNotificationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(orderRefresh), name: NSNotification.Name(rawValue: "orderList"), object: nil)
    }
    
    deinit {
        print("\(self.classForCoder)销毁")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("orderList"), object: nil)
    }
    
    @objc func orderRefresh() {
        loadData_Net()
    }

}



extension OrderListController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ///（1待支付,2支付中,3用户取消,4系统取消,5商家拒单,6支付成功,7已接单,8已出餐,9配送中,10已完成
    
        let model = dataArr[indexPath.row]
        
        if model.isHaveBotton {
            return (S_W - 125 - 15) / 4 + 125  + 30 + 20
        }
        return (S_W - 125 - 15) / 4 + 80 + 30 + 20
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArr[indexPath.row]
        
        if model.isHaveBotton {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HaveButtonOrderCell") as! HaveButtonOrderCell
            cell.setCellData(model: dataArr[indexPath.row])
            cell.clickBlock = { [unowned self] (type) in
                if (type as! String) == "qx" {
                    self.showSystemChooseAlert("Alert", "Are you sure you want to cancel the order?", "YES", "NO") { [unowned self] in
                        self.cancelOrder_Net(orderID: model.orderID)
                    } _: {}
                }
                
                if type as! String == "qr" {
                    self.showSystemChooseAlert("Alert", "Confirm receipt of goods?", "YES", "NO") { [unowned self] in
                        self.confiromOrder_Net(orderID: model.orderID)
                    } _: {}
                }
                if type as! String == "pj" {
                    let nextVC = EvaluateController()
                    nextVC.orderID = model.orderID
                    nextVC.orderType = model.type
                    nextVC.islist = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                if type as! String == "zf" {
                    let nextVC = OderListConfirmController()
                    nextVC.orderID = model.orderID
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                if type as! String == "zlyd" {
                    //再来一单
                    self.orderAgain_Net(orderID: model.orderID, storeID: model.storeID)
                }
                
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoButtonOrderCell") as! NoButtonOrderCell
            cell.setCellData(model: dataArr[indexPath.row])
            return cell

        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let nextVC = OderListConfirmController()
//        nextVC.orderID = dataArr[indexPath.row].orderID
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let nextVC = OrderDetailController()
        nextVC.orderID = dataArr[indexPath.row].orderID
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
