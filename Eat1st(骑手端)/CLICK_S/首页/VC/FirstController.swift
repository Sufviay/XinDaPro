//
//  FirstController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import RxSwift
import MJRefresh
import CoreMIDI

class FirstController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    private var dataArr: [OrderModel] = []
    
    private var otherArr: [OtherOrderModel] = []
    
    ///分页
    private var page: Int = 1
    
    ///工作状态
    private var workStatus: String = "" {
        didSet {
            if workStatus == "1" {
                //工作中
                self.sliderBut.setImage(LOIMG("slider_c"), for: .normal)
            } else {
                //休息
                self.sliderBut.setImage(LOIMG("slider_o"), for: .normal)
            }
        }
    }
    
    ///当前选择的状态下标
    private var statusIdx: Int = 0
    
    ///设置工作状态
    private lazy var workAlert: WorkAlertView = {
        let alert = WorkAlertView()
        
        alert.clickBlock = { [unowned self] (_) in
            self.setWorkStatus_Net()
        }
        return alert
    }()
    
    ///状态列表
    private var statusArr: [StatusTagModel] = []
    
    var timer: Timer?
    
    ///购买类型 1外卖。2自取
    private var buyType: String = "1"
    
    
    private let leftBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_cbl"), for: .normal)
        return but
    }()
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
        return view
    }()
    
    private let headLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .center)
        lab.text = "ORDER"
        return lab
    }()
    

    //骑手工作状态按钮
    private let sliderBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_c"), for: .normal)
        return but
    }()
    
    //状态
    private let t_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .right)
        lab.text = "ON"
        return lab
    }()
    

    
    ///状态TagView
    private lazy var statusTagView: OrderTagView = {
        let view = OrderTagView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.selectIdx = self.statusIdx
        
        view.clickBlock = { [unowned self] (idx) in
            statusIdx = idx as! Int
            
            updateBottonAndView()
        
            
//            //只有待配送才显示底部配送按钮
//            if self.statusIdx == 0 {
//                HUD_MB.loading("", onView: self.view)
//                getOtherOrders_Net {
//                    HUD_MB.dissmiss(onView: self.view)
//                }
//            }
            
            if statusArr[statusIdx].id == "3" {
                //已完成
                loadCurentDayMoney()
                
            } else {
                HUD_MB.loading("", onView: self.view)
                loadData_Net()
            }
        }
        return view
    }()

    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.tag = 100
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
        tableView.register(OrderListCell.self, forCellReuseIdentifier: "OrderListCell")
        return tableView
    }()
    
    
//    private lazy var Other_table: UITableView = {
//        let tableView = UITableView()
//        tableView.isHidden = true
//        tableView.tag = 200
//        tableView.backgroundColor = .clear
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        //回弹效果
//        tableView.bounces = true
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.register(OtherOderCell.self, forCellReuseIdentifier: "OtherOderCell")
//        return tableView
//    }()

    
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        //view.frame = self.table.bounds
        return view
    }()
    
    
    //骑手接单按钮
    private let PSBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery", .white, SFONT(16), MAINCOLOR)
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    //骑手取消按钮
    private let QXBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", .white, SFONT(16), MAINCOLOR)
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    //订单统计
    private let TJView: CurentDayMoneyView = {
        let view = CurentDayMoneyView()
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()

    
    override func setNavi() {
        loadTag_Net()
    }
    
    override func setViews() {
        
        self.naviBar.isHidden = true
        view.backgroundColor = HCOLOR("#F7F7F7")
        
        addNotificationCenter()
        startTimer()
        self.setUpUI()
        self.updateBottonAndView()
        getWorkStatus_Net()
                        
    }
    
    private func setUpUI() {
        
        
        view.addSubview(leftBut)
        leftBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.size.equalTo(CGSize(width: 50, height: 44))
            $0.top.equalToSuperview().offset(statusBarH)
        }
        
        view.addSubview(sliderBut)
        sliderBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 40, height: 44))
            $0.top.equalToSuperview().offset(statusBarH)
        }
        
        view.addSubview(t_lab)
        t_lab.snp.makeConstraints {
            $0.centerY.equalTo(sliderBut)
            $0.right.equalTo(sliderBut.snp.left).offset(-5)
        }

        
        view.addSubview(headLab)
        headLab.snp.makeConstraints {
            $0.centerY.equalTo(leftBut)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(statusTagView)
        statusTagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(statusBarH + 44)
        }
        
        view.addSubview(PSBut)
        PSBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.height.equalTo(40)
        }
        
        view.addSubview(QXBut)
        QXBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.height.equalTo(40)

        }

        view.addSubview(TJView)
        TJView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(95)
            $0.top.equalTo(statusTagView.snp.bottom).offset(10)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(statusTagView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
//
//        view.addSubview(Other_table)
//        Other_table.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalTo(statusTagView.snp.bottom).offset(10)
//            $0.bottom.equalToSuperview().offset(-bottomBarH)
//        }

    
        
        
        leftBut.addTarget(self, action: #selector(clickCBLAction), for: .touchUpInside)
        sliderBut.addTarget(self, action: #selector(clickSliderAction), for: .touchUpInside)
        PSBut.addTarget(self, action: #selector(clickJieDanAction), for: .touchUpInside)
        QXBut.addTarget(self, action: #selector(clickAllCancelAction), for: .touchUpInside)
        
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadTag_Net()
        }
        
//        Other_table.mj_header = MJRefreshNormalHeader() { [unowned self] in
//            self.loadTag_Net()
//        }


        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }
        
    }
    
    
    //MARK: - 点击侧拉栏
    @objc private func clickCBLAction() {
        sideBar.appearAction()
    }
    
    //MARK: - 点击工作状态
    @objc private func clickSliderAction() {
        self.workAlert.setWorkStatus(type: workStatus)
        self.workAlert.appearAction()

    }

    //MARK: - 点击接单
    @objc func clickJieDanAction() {

        HUD_MB.loading("", onView: view)
        HTTPTOOl.riderJieDan().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            //记录接单数量
            UserDefaults.standard.JDCount = self.dataArr.count
            self.loadTag_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - 批量取消
    @objc func clickAllCancelAction() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.riderCancelAllOrder().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            //记录接单数量
            UserDefaults.standard.JDCount = 0
            self.loadTag_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    

    
    //MARK: - 网络请求
    
    private func loadTag_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderStatusTag().subscribe(onNext: { [unowned self] (json) in
            var tArr: [StatusTagModel] = []
            for jsonData in json["data"].arrayValue {
                let model = StatusTagModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            statusArr = tArr
            statusTagView.tagArr = statusArr
            loadData_Net()
//            self.getOtherOrders_Net {
//                if self.statusIdx != 0 {
//
//                } else {
//                    HUD_MB.dissmiss(onView: self.view)
//                }
//            }

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
//    //MARK: - 获取外部订单
//    func getOtherOrders_Net(success: @escaping () -> ()) {
//        HTTPTOOl.getOtherOders(status: "2").subscribe(onNext: { (json) in
//            var tArr: [OtherOrderModel] = []
//            for jsonData in json["data"].arrayValue {
//                let model = OtherOrderModel()
//                model.updateModel(json: jsonData)
//                tArr.append(model)
//            }
//            self.otherArr = tArr
//
//            let tagModel = StatusTagModel()
//            tagModel.name = "Other Order"
//            tagModel.num = self.otherArr.count
//
//            if self.statusArr.count != 0 {
//                if self.statusArr[0].name == "Other Order" {
//                    self.statusArr[0] = tagModel
//                } else {
//                    self.statusArr.insert(tagModel, at: 0)
//                }
//            }
//            self.statusTagView.tagArr = self.statusArr
//
//            if self.statusIdx == 0 {
//                if self.otherArr.count == 0 {
//                    self.noDataView.frame = self.Other_table.bounds
//                    self.Other_table.addSubview(self.noDataView)
//                } else {
//                    self.noDataView.removeFromSuperview()
//                }
//            }
//
//            self.Other_table.mj_header?.endRefreshing()
//            self.Other_table.reloadData()
//            success()
//
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//            self.Other_table.mj_header?.endRefreshing()
//        }).disposed(by: self.bag)
//    }
    
    
    //MARK: - 获取当前
    private func loadCurentDayMoney() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getCurentDayCashAndDeFee().subscribe(onNext: { [unowned self] (json) in
            let cashMoney = json["data"]["cashAmount"].doubleValue
            let deMoney = json["data"]["deliveryAmount"].doubleValue
            self.TJView.updateData(cashMoney: D_2_STR(cashMoney), deFeeMoney: D_2_STR(deMoney))
            self.loadData_Net()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    
    private func loadData_Net() {
        
        if statusArr.count == 0 {
            HUD_MB.dissmiss(onView: self.view)
            return
        }
        
        HTTPTOOl.getOrderList(page: 1, tag: self.statusArr[statusIdx].id).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            
            var tArr: [OrderModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OrderModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
                    
            if self.dataArr.count == 0 {
                self.noDataView.frame = self.table.bounds
                self.table.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
                    
            self.table.reloadData()
            self.table.mj_header?.endRefreshing()
            self.table.mj_footer?.resetNoMoreData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getOrderList(page: page, tag: self.statusArr[statusIdx].id).subscribe(onNext: { [unowned self] (json) in
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = OrderModel()
                    model.updateModel(json: jsonData)
                    self.dataArr.append(model)
                }
                self.table.reloadData()
                self.table.mj_footer?.endRefreshing()
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()

        }).disposed(by: self.bag)
    }
    
    
    //请求工作状态
    private func getWorkStatus_Net() {
        HTTPTOOl.getRiderWorkStatus().subscribe(onNext: { [unowned self] (json) in
            self.workStatus = json["data"]["workStatus"].stringValue
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //设置工作状态
    private func setWorkStatus_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setRiderWorkStatus().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.workStatus = json["data"]["workStatus"].stringValue
//            if self.workStatus == "1" {
//                self.workStatus = "2"
//            } else {
//                self.workStatus = "1"
//            }

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    

    
    ///开始送单
    private func startAction_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderStart(orderID: orderID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadTag_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    ///外部订单开始送单
    private func Other_startAction_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.otherOdersStart(id: orderID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadTag_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    ///外部订单点击完成
    private func Other_completeAction_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.otherOdersComplete(id: orderID).subscribe(onNext: {[unowned self] (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadTag_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }


    
    ///确认收货
    func shouHuoAction_Net(orderID: String) {
        
        self.showSystemChooseAlert("Alert", "Are you sure you want to confirm the order?", "YES", "NO") {
            HUD_MB.loading("", onView: self.view)
            HTTPTOOl.riderDoReceiveOrder(orderID: orderID).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.showSuccess("", onView: self.view)
                self.loadTag_Net()
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        } _: {}
    }
    
    

    
    //MARK: - 判断底部操作按钮的显示 与 统计试图的显示
    private func updateBottonAndView() {
        if self.statusIdx == 0 {
            self.TJView.isHidden = true
            self.QXBut.isHidden = true
            self.PSBut.isHidden = false
            self.table.isHidden = false
            //self.Other_table.isHidden = true

            
            self.table.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
                $0.top.equalTo(statusTagView.snp.bottom).offset(10)
            }
        }
        
        if self.statusIdx == 1 {
            self.TJView.isHidden = true
            self.PSBut.isHidden = true
            self.table.isHidden = false
            //self.Other_table.isHidden = true

            
            
            //获取当前批量接单的单数
            let jdCount = UserDefaults.standard.JDCount ?? 0
            
            if dataArr.count == 0 {
                self.QXBut.isHidden = true
                self.table.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-bottomBarH)
                    $0.top.equalTo(statusTagView.snp.bottom).offset(10)
                }
            } else {
                
                if jdCount == dataArr.count {
                    //每一个订单状态都不是12（配送中） 则可以批量取消
                    var isCanCancel: Bool = true
                    for model in dataArr {
                        if model.status == .delivery_ing {
                            isCanCancel = false
                            break
                        }
                    }
                    if isCanCancel {
                        self.QXBut.isHidden = false
                        self.table.snp.updateConstraints {
                            $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
                            $0.top.equalTo(statusTagView.snp.bottom).offset(10)
                        }
                    } else {
                        self.QXBut.isHidden = true
                        self.table.snp.updateConstraints {
                            $0.bottom.equalToSuperview().offset(-bottomBarH)
                            $0.top.equalTo(statusTagView.snp.bottom).offset(10)
                        }
                    }
                    
                } else {
                    self.QXBut.isHidden = true
                    self.table.snp.updateConstraints {
                        $0.bottom.equalToSuperview().offset(-bottomBarH)
                        $0.top.equalTo(statusTagView.snp.bottom).offset(10)
                    }
                }
            }
            
        }
        
        if self.statusIdx == 2 {
            self.TJView.isHidden = false
            self.QXBut.isHidden = true
            self.PSBut.isHidden = true
            self.table.isHidden = false
            //self.Other_table.isHidden = true

            
            self.table.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-bottomBarH)
                $0.top.equalTo(statusTagView.snp.bottom).offset(95 + 20)
            }
        }
        
//        if self.statusIdx == 0 {
//            self.TJView.isHidden = true
//            self.QXBut.isHidden = true
//            self.PSBut.isHidden = true
//            self.table.isHidden = true
//            self.Other_table.isHidden = false
//        }
        
    }
    
    
    //MARK: - 注册通知中心
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(orderRefresh), name: NSNotification.Name(rawValue: "orderList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutAction), name: NSNotification.Name(rawValue: "logOut"), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("orderList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("logOut"), object: nil)
    }
    
    @objc func orderRefresh() {
        loadTag_Net()
    }
    
    @objc func logOutAction() {
        invalidateTimer()
    }

    
    //MARK: - 定时相关
    private func startTimer() {
        print("startTimer")
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (_) in
            //获取当前位置
            
            
            print("计时器跑着吗？")
            
            LocationManager.shared.initialize()
            LocationManager.shared.doLocation()
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    
    private func invalidateTimer() {
        
        print("结束上传！")
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
            LocationManager.shared.l_manager?.stopUpdatingLocation()
            print("invalidateTimer")
        }
    }

}


extension FirstController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 100 {
            return dataArr.count
        } else {
            return otherArr.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 100 {
            let model = dataArr[indexPath.row]
            
            if statusIdx == 1 {
                
                if model.paymentMethod == "1" {
                    //现金
                    return model.content_H + 10 + 50 + 30
                } else {
                    //卡
                    return model.content_H + 10 + 50
                }
                
            } else {
                
                if model.paymentMethod == "1" {
                    return model.content_H + 10 + 30
                } else {
                    return model.content_H + 10
                }
            }
        }
        
        return otherArr[indexPath.row].cell_H

    }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell") as! OrderListCell
            cell.tag = indexPath.row
            cell.setCelllData(model: dataArr[indexPath.row], tabKey: statusArr[statusIdx].key)
            
            
            cell.clickBlock = { [unowned self] (arr) in
                let type = (arr as! [String])[0]
                let orderID = (arr as! [String])[1]
                
                if type == "start" {
                    ///开始送单
                    self.startAction_Net(orderID: orderID)
                    
                }
                if type == "unsuccessful" {
                    ///无法送单
                    let nextVC = JuJieReasonController()
                    nextVC.orderID = orderID
                    self.navigationController?.pushViewController(nextVC, animated: true)

                }
                
                if type == "complete" {
                    ///送达
                    self.shouHuoAction_Net(orderID: orderID)
                }
            }
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherOderCell") as! OtherOderCell
        cell.setCellData(model: otherArr[indexPath.row])
        cell.clickBlock = { [unowned self] (type) in
            
            if type == "start" {
                ///开始送单
                self.Other_startAction_Net(orderID: self.otherArr[indexPath.row].orderId)
                
            }
            if type == "complete" {
                ///送达
                self.Other_completeAction_Net(orderID: self.otherArr[indexPath.row].orderId)
            }
        }
        return cell
    }
}
