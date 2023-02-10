//
//  FirstController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit
import RxSwift
import MJRefresh

class FirstController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    private var dataArr: [OrderModel] = []
    
    ///分页
    private var page: Int = 1
    
    ///当前选择的状态下标
    private var statusIdx: Int = 0
    
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
    
    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("time"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    private let psyBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("psy"), for: .normal)
        but.isHidden = true
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

    ///类型TagView
//    private lazy var typeTagView: FirstHeaderTagView = {
//        let view = FirstHeaderTagView()
//        view.clickblock = { [unowned self] (str) in
//
//            HUD_MB.loading("", onView: self.view)
//            if str as! String == "de" {
//                self.buyType = "1"
//            }
//
//            if str as! String == "co" {
//                self.buyType = "2"
//            }
//
//            self.loadData_Net()
//        }
//        return view
//    }()
    
    ///状态TagView
    private lazy var statusTagView: OrderTagView = {
        let view = OrderTagView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.selectIdx = self.statusIdx
        
        view.clickBlock = { [unowned self] (idx) in
            self.statusIdx = idx as! Int
            HUD_MB.loading("", onView: self.view)
            loadData_Net()
        }
        
        return view
    }()

    
    
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
        tableView.register(OrderListCell.self, forCellReuseIdentifier: "OrderListCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()
    

    
    
    override func setNavi() {
        
        loadTag_Net()
    }
    
    override func setViews() {
        
        self.naviBar.isHidden = true
        view.backgroundColor = HCOLOR("#F7F7F7")
        
        addNotificationCenter()
        if UserDefaults.standard.userType == "2" {
            startTimer()
        }
        self.setUpUI()
                
    }
    
    private func setUpUI() {
        
        
        view.addSubview(leftBut)
        leftBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.size.equalTo(CGSize(width: 50, height: 44))
            $0.top.equalToSuperview().offset(statusBarH)
        }
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 30, height: 44))
            $0.top.equalToSuperview().offset(statusBarH)
        }
        
        view.addSubview(psyBut)
        psyBut.snp.makeConstraints {
            $0.right.equalTo(rightBut.snp.left).offset(0)
            $0.size.equalTo(CGSize(width: 30, height: 44))
            $0.centerY.equalTo(rightBut)
        }
        
        view.addSubview(headLab)
        headLab.snp.makeConstraints {
            $0.centerY.equalTo(leftBut)
            $0.centerX.equalToSuperview()
        }
        
//        view.addSubview(typeTagView)
//        typeTagView.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 220, height: 30))
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(leftBut)
//        }
//
        view.addSubview(statusTagView)
        statusTagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(statusBarH + 44)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(statusTagView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
        
        
        leftBut.addTarget(self, action: #selector(clickCBLAction), for: .touchUpInside)
        rightBut.addTarget(self, action: #selector(clickTimeAction), for: .touchUpInside)
        psyBut.addTarget(self, action: #selector(clickPSYAction), for: .touchUpInside)
        
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadTag_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }
        
    }
    
    
    
    @objc private func clickCBLAction() {

        sideBar.appearAction()
    
    }
    
    
    
    @objc private func clickTimeAction() {
        let nextVC = StoreTimeSettingController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @objc func clickPSYAction() {
        let nextVC = DeliveryInfoListController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }


    
    //MARK: - 网络请求
    
    private func loadTag_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderStatusTag().subscribe(onNext: { (json) in
            
            
            var tArr: [StatusTagModel] = []
            for jsonData in json["data"].arrayValue {
                let model = StatusTagModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.statusArr = tArr
            self.statusTagView.tagArr = self.statusArr
            self.loadData_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    

    
    private func loadData_Net() {
        
        if statusArr.count == 0 {
            HUD_MB.dissmiss(onView: self.view)
            return
        }
        
        HTTPTOOl.getOrderList(page: 1, tag: self.statusArr[statusIdx].id, type: "0").subscribe(onNext: { (json) in
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
        HTTPTOOl.getOrderList(page: page, tag: self.statusArr[statusIdx].id, type: self.buyType).subscribe(onNext: { (json) in
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
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()

        }).disposed(by: self.bag)
    }
    
    
    ///接单
    private func jiedanAction_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.jiedanAction(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadTag_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    ///出餐
    func chuCanAciton_Net(orderID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.chuCanAciton(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadTag_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //开始配送
    func kaiShiPeiSongAction_Net(orderID: String)  {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.kaiShiPeiSongAction(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            self.loadTag_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    ///确认收货
    func shouHuoAction_Net(orderID: String) {
        
        self.showSystemChooseAlert("Alert", "Are you sure you want to confirm the order?", "YES", "NO") {
            HUD_MB.loading("", onView: self.view)
            HTTPTOOl.shouHuoAction(orderID: orderID).subscribe(onNext: { (json) in
                HUD_MB.showSuccess("", onView: self.view)
                self.loadTag_Net()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        } _: {}
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
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (_) in
            //获取当前位置
            
            
            LocationManager.shared.doLocation { place in
                //上传当前位置
                print("开始上传位置")
                HTTPTOOl.uploadUserLocation(lat: place.lat, lng: place.lng).subscribe(onNext: { (json) in
                    print("上传成功！")
                }, onError: { (error) in
                    print(ErrorTool.errorMessage(error))
                }).disposed(by: self.bag)

            } fail: {}
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    
    private func invalidateTimer() {
        
        print("结束上传！")
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
            print("invalidateTimer")
        }
    }

}


extension FirstController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return dataArr[indexPath.row].cellHeight + 10
    }
    
    
    // 7待接单。 接单、拒接单
    // 6拒接单  拒接原因
    // 8已接单  已出餐按钮
    // 9已出餐 配货员开始配送按钮
    // 10配送中  无按钮
    // 11 完成。 没有评价 没有投诉 没有按钮
    // 评价展示评价内容 时间 星级
    // 投诉了 展示查看投诉按钮

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell") as! OrderListCell
        cell.setCelllData(model: dataArr[indexPath.row])
        
        cell.clickBlock = { [unowned self] (arr) in
            let type = (arr as! [String])[0]
            let orderID = (arr as! [String])[1]
            
            if type == "jujie" {
                ///拒接
                let nextVC = JuJieReasonController()
                nextVC.orderID = orderID
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            if type == "jiedan" {
                ///接单
                self.jiedanAction_Net(orderID: orderID)
            }
            
            if type == "chucan" {
                ///出餐
                self.chuCanAciton_Net(orderID: orderID)
            }
            
            if type == "peisong" {
                ///开始配送
                self.kaiShiPeiSongAction_Net(orderID: orderID)
            }

            if type == "qucan" {
                //取餐
                self.shouHuoAction_Net(orderID: orderID)
            }
            
            if type == "songda" {
                ///送达
                
                self.shouHuoAction_Net(orderID: orderID)
            }
            
            if type == "ts" {
                ///投诉处理
                let nextVC = DealComplaintController()
                nextVC.orderID = orderID
                nextVC.tsName = dataArr[indexPath.row].perName
                nextVC.tsPhone = dataArr[indexPath.row].perPhone
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
//            if type == "dh" {
//                //PJCUtil.goDaohang(lat: self.lat, lng: self.lng)
//            }
            
        }
        return cell
    }
    

}
