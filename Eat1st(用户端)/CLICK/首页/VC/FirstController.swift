//
//  FirstController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

/***
 
 首页页面梳理：
 
 
 根据地理位置显示店铺列表，
 
 
 
 */



import UIKit
import RxSwift
import MJRefresh
import GooglePlaces


class FirstController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    ///分页
    private var page: Int = 1
    
    
    ///是否显示全部店铺
    private var isShowAll: Bool = false
    ///是否显示全部的按钮
    private var isShowAllBut: Bool = false
    
    
    
    
    ///是否有优惠券可使用
    private var haveCoupon: Bool = false
    
    ///是否有可抽奖的订单
    private var havePrize: Bool = false
    
    
    private let bag = DisposeBag()
    
    ///附近
    private var nearestArr: [StoreInfoModel] = []

    
    ///有首单优惠的店铺ID
    private var firstDiscountStoreIDArr: [String] = []
    
    private lazy var moreView: SystemMoreView = {
        let but = SystemMoreView()
        
        but.clickBlock = { [unowned self] (_) in
            //MARK: - 左侧滑动栏
            if PJCUtil.checkLoginStatus() {
                self.sideBar.haveMsg = self.moreView.isHave
                self.sideBar.appearAction()
            }
        }
        return but
    }()
        
    private let homeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(20), .center)
        lab.text = "Eat1st"
        return lab
    }()
    
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
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
        tableView.register(FirstSearchTableCell.self, forCellReuseIdentifier: "FirstSearchTableCell")
        tableView.register(StoreTableCell.self, forCellReuseIdentifier: "StoreTableCell")
        tableView.register(FirstStoreFLCell.self, forCellReuseIdentifier: "FirstStoreFLCell")
        tableView.register(FirstAllStoreCell.self, forCellReuseIdentifier: "FirstAllStoreCell")
        tableView.register(FirstHaveCouponCell.self, forCellReuseIdentifier: "FirstHaveCouponCell")
        tableView.register(FirstHavePrizeDrawCell.self, forCellReuseIdentifier: "FirstHavePrizeDrawCell")
        
        return tableView
    }()
    
    
    
    //空数据
    private lazy var noDataView: NOStoreView = {
        let view = NOStoreView()
    
        view.clickBlock = { [unowned self] (_) in
            self.isShowAll = true
            self.loadData_Net()
        }
        
        return view
    }()

    
//
//    ///钱包
//    private let walletView: WalletView = {
//        let view = WalletView()
//        return view
//    }()
    
    
    ///积分
    private let jifenView: JiFenView = {
        let view = JiFenView()
        return view
    }()
    
    //过期积分
    private let jifen_GQ_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#F1370B"), SFONT(8), .right)
        lab.text = "1000 to expire"
        lab.isHidden = true
        return lab
        
    }()
    
    
//    ///消息提醒
//    private let systemAlertView: SystemMsgView = {
//        let view = SystemMsgView()
//        return view
//    }()

        
    
    override func setViews() {
        self.naviBar.isHidden = true
        
        //判断是否有地理位置
        if UserDefaults.standard.local_lat != nil {
            self.setUpUI()
            addNotificationCenter()
            loadData_Net()
        } else {
            self.navigationController?.setViewControllers([LocationController()], animated: false)
        }
    }

    
    override func setNavi() {
        //getWalletMoney_Net()
        checkVerison_Net()
        ///获取是否有未读消息
        checkMessage_Net()
        ///是否有优惠券
        checkHaveCoupon_Net()
        ///是否有未抽奖的订单
        checkHavePrizeDraw_Net()
        ///更新积分
        getJiFen_Net()
    }
    
    
    
    private func setUpUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(moreView)
        moreView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.size.equalTo(CGSize(width: 50, height: 44))
            $0.top.equalToSuperview().offset(statusBarH)
        }

            
        view.addSubview(homeLab)
        homeLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(moreView)
        }
        
//        view.addSubview(systemAlertView)
//        systemAlertView.snp.makeConstraints {
//            $0.centerY.size.equalTo(leftBut)
//            $0.right.equalToSuperview().offset(-5)
//        }
        
        view.addSubview(jifenView)
        jifenView.snp.makeConstraints {
            $0.centerY.equalTo(moreView)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 70, height: 24))
        }
        
        view.addSubview(jifen_GQ_lab)
        jifen_GQ_lab.snp.makeConstraints {
            $0.top.equalTo(jifenView.snp.bottom)
            $0.right.equalToSuperview().offset(-10)
        }
        
        let line = UIView()
        line.backgroundColor = HCOLOR("#F7F7F7")
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(7)
            $0.top.equalToSuperview().offset(statusBarH + 44)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        

        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.checkHavePrizeDraw_Net()
            self.checkHaveCoupon_Net()
            self.loadData_Net()
        }
        
        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadMoreData_Net()
        }
    }

    
    
    //MARK: - 扫一扫
    private func clickSaoYiSaoAction() {
        //绑定店铺
        
        if PJCUtil.checkLoginStatus() {
            let scanVC = ScanViewController()
            
            scanVC.scanFinshBlock = { [unowned self] (str) in
                let scanStr = str as! String
                if scanStr != "" {
                    let arr = scanStr.components(separatedBy: "storeId=")
                    if arr.count != 0 {
                        let storeID = arr.last!
                        var type = ""
                        
                        var urlStr = arr.first!
                        urlStr = urlStr.filter { $0 != "&"}
    
                        let arr1 = urlStr.components(separatedBy: "type=")
                        if arr1.count != 0 {
                            
                            if arr1.count == 2 {
                                type = arr1.last!
                            } else {
                                type = "1"
                            }
                        }
                        //进入店铺主页
                        let nextVC = StoreMainController()
                        nextVC.storeID = storeID
                        nextVC.type = type
                        self.navigationController?.pushViewController(nextVC, animated: true)

                    }
                }
            }
            self.present(scanVC, animated: true, completion: nil)
        }
    }
    


    

    
   
    //MARK: - 搜索
    func clickSearchAction() {
        print("search")
        SearchPlaceManager.shared.doSearchPlace { (model) in
            UserDefaults.standard.address = model.address
            UserDefaults.standard.postCode = model.postCode
            UserDefaults.standard.local_lng = model.lng
            UserDefaults.standard.local_lat = model.lat
            self.loadData_Net()
        }
    }
    
    //MARK: - 定位
    func clickLocalAction() {
        SearchPlaceManager.shared.doLocationCurrentPlace { [unowned self] (arr) in
            
            let nextVC = PostCodeSearchController()
            nextVC.placeArr = arr
            nextVC.selectedBlock = { [unowned self] (_) in
                self.loadData_Net()
            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //MARK: - 通知中心
    private func addNotificationCenter() {
        //监测消息的变化
        NotificationCenter.default.addObserver(self, selector: #selector(centerAciton_msg), name: NSNotification.Name(rawValue: "message"), object: nil)
        //监测登录的变化
        NotificationCenter.default.addObserver(self, selector: #selector(centerAction_login), name: NSNotification.Name(rawValue: "login"), object: nil)

    }
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("message"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("login"), object: nil)
    }

    @objc private func centerAciton_msg() {
        self.checkMessage_Net()
    }
    
    @objc private func centerAction_login() {
        self.loadData_Net()
        self.checkHaveCoupon_Net()
        self.checkMessage_Net()
        self.checkHavePrizeDraw_Net()
        self.getJiFen_Net()
    }


}


extension FirstController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if haveCoupon {
                return 1
            } else {
                return 0
            }
            
        }
        
        if section == 1 {
            if havePrize {
                return 1
            } else {
                return 0
            }
        }
        
        else if section == 2 {
            return 1
        }
        else if section == 3 {
            return nearestArr.count
        }
        else {
            if isShowAllBut {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return SET_H(110, 350) + 10
        }
        
        else if indexPath.section == 1 {
            return SET_H(70, 353) + 10
        }
        
        else if indexPath.section == 2 {
            return (UserDefaults.standard.address ?? "").getTextHeigh(SFONT(11), S_W - 150) + 33 + 15 + 10
        }
        else if indexPath.section == 3 {
            
            //根据店铺图片大小来显示高度
            let imgUrl = nearestArr[indexPath.row].coverImg
            //从缓存中查找图片
            let img = SDImageCache.shared.imageFromCache(forKey: imgUrl)

            if img == nil {
                return (R_W(355) * (9/16)) + 105 + 15
            }
            //根据图片计算高度
            return img!.size.height * (S_W - 20) / img!.size.width + 105 + 15
            
        } else {
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstHaveCouponCell") as! FirstHaveCouponCell
            cell.setCellData()
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstHavePrizeDrawCell") as! FirstHavePrizeDrawCell
            return cell
        }
        
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSearchTableCell") as! FirstSearchTableCell
            cell.setCellData(addressStr: UserDefaults.standard.address ?? "", postCode: UserDefaults.standard.postCode ?? "")
            cell.clickBlock = { [unowned self] (type) in
                if type == "search" {
                    //MARK: - 搜索
                    self.clickSearchAction()
                }
                
                if type == "local" {
                    //MARK: - 定位
                    self.clickLocalAction()
                }
                
                if type == "scan" {
                    //MARK: - 扫一扫
                    self.clickSaoYiSaoAction()
                }
            }
            return cell
            
        }
        else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableCell") as! StoreTableCell
            cell.setCellData(model: nearestArr[indexPath.row])
            //赋值图片
            let img = SDImageCache.shared.imageFromCache(forKey: nearestArr[indexPath.row].coverImg)
            if img == nil {
                //下载图片
                cell.picImg.image = LOIMG("Please wait …")
                self.downLoadImgage(url: nearestArr[indexPath.row].coverImg)
            } else {
                cell.picImg.image = img!
                
            }
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstAllStoreCell") as! FirstAllStoreCell
            cell.clickBlock = { [unowned self] (_) in
                self.isShowAll = true
                self.loadData_Net()
            }
            return cell
        }
    }
    
    //下载图片
    private func downLoadImgage(url: String) {
        SDWebImageDownloader.shared.downloadImage(with: URL(string: url)) { image, data, error, finished in
            
            SDImageCache.shared.store(image, forKey: url, toDisk: true)
            
            //判断图片
            if image != nil {
                
                //主线程刷新UI
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            //进入优惠券列表
            let couponVC = CouponListController()
            self.navigationController?.pushViewController(couponVC, animated: true)
        }
        
        if indexPath.section == 1 {
            //订单列表
            let listVC = OrderListController()
            self.navigationController?.pushViewController(listVC, animated: true)
        }
        
        
        if indexPath.section == 3 {
            //店铺菜单
            let nextVC = StoreMenuOrderController()
            nextVC.storeID = nearestArr[indexPath.row].storeID
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)

        }
        
    }
    
    //MARK: - 网络请求
    
    //获取首单优惠的店铺
    private func loadStoreListFirstDiscount_Net() {
        
        if UserDefaults.standard.isLogin {
            
            HTTPTOOl.getStoreListFirstDiscount().subscribe(onNext: { (json) in
                //获取存在首单优惠的店铺ID
                var storeIDArr: [String] = []
                for jsondata in json["data"].arrayValue {
                    if jsondata["firstType"].stringValue  == "2" && jsondata["storeId"] != "0" {
                        storeIDArr.append(jsondata["storeId"].stringValue)
                    }
                }
                self.firstDiscountStoreIDArr = storeIDArr
                //为数据model 赋值
                self.nearestArr.forEach { model in
                    if storeIDArr.contains(model.storeID) {
                        model.isFirstDiscount = true
                    } else {
                        model.isFirstDiscount = false
                    }
                }
                self.table.reloadSections([3], with: .none)
            }).disposed(by: self.bag)
        }
    }
    

    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        let isAll = isShowAll ? "1" : "2"
        
        HTTPTOOl.storeList_Nearby(tag: "", lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, allStore: isAll, page: 1).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            //热门的店铺
            var n_Arr: [StoreInfoModel] = []
            for jsonData in json["data"].arrayValue {
                let model = StoreInfoModel()
                model.updateModel(json: jsonData)
                n_Arr.append(model)
            }
            self.nearestArr = n_Arr
    
            //处理页面
            if self.nearestArr.count == 0 {
                //没有数据
                self.isShowAllBut = false
                self.noDataView.isAll = self.isShowAll
                let h = (UserDefaults.standard.address ?? "").getTextHeigh(SFONT(11), S_W - 150) + 33 + 15 + 10
                self.noDataView.frame = CGRect(x: 0, y: h, width: self.table.frame.width, height: self.table.frame.height - h)
    
                self.table.addSubview(self.noDataView)
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else if self.nearestArr.count < 10 {
                //已经加载完毕了
                if !self.isShowAll {
                    self.isShowAllBut = true
                } else {
                    self.isShowAllBut = false
                }
                self.noDataView.removeFromSuperview()
                self.table.mj_footer?.endRefreshingWithNoMoreData()
                
            } else {
                //可以继续加载
                self.isShowAllBut = false
                self.noDataView.removeFromSuperview()
                self.table.mj_footer?.resetNoMoreData()
            }

            self.table.reloadData()
            self.table.mj_header?.endRefreshing()
            
            self.loadStoreListFirstDiscount_Net()
    
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    private func loadMoreData_Net() {
    
        let isAll = isShowAll ? "1" : "2"
        
        HTTPTOOl.storeList_Nearby(tag: "", lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, allStore: isAll, page: self.page).subscribe(onNext: { (json) in
            
            for jsonData in json["data"].arrayValue {
                let model = StoreInfoModel()
                model.updateModel(json: jsonData)
                if self.firstDiscountStoreIDArr.contains(model.storeID) {
                    model.isFirstDiscount = true
                } else {
                    model.isFirstDiscount = false
                }
                
                self.nearestArr.append(model)
            }
            
            //处理页面
            if json["data"].arrayValue.count < 10 {
                if !self.isShowAll {
                    self.isShowAllBut = true
                }
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                self.table.mj_footer?.endRefreshing()
            }
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()
        }).disposed(by: bag)

    }
    
    //检查是否有优惠券
    private func checkHaveCoupon_Net() {
        
        if UserDefaults.standard.isLogin {
            HTTPTOOl.getMyCouponList().subscribe(onNext: { (json) in
                if json["data"].arrayValue.count == 0 {
                    self.haveCoupon = false
                } else {
                    self.haveCoupon = true
                }
                //self.table.reloadData()
                self.table.reloadSections([0], with: .none)
                    
            }).disposed(by: self.bag)

        }
    }
    
    //检查是否有未抽奖的订单
    func checkHavePrizeDraw_Net() {
        
        if UserDefaults.standard.isLogin {
            HTTPTOOl.isHaveDrawPrize().subscribe(onNext: { (json) in
                
                if json["data"]["status"].stringValue == "1" {
                    self.havePrize = true
                } else {
                    self.havePrize = false
                }
                //self.table.reloadData()
                self.table.reloadSections([1], with: .none)
            }).disposed(by: self.bag)

        }
    }
    
    
    
    //版本检查
    private func checkVerison_Net() {
        //检查版本
        HTTPTOOl.CheckAppVer().subscribe(onNext: { (json) in
            if json["data"]["verId"].stringValue != "" {
                let alert = VersionAlert()
                alert.appUrlStr = json["data"]["url"].stringValue
                alert.isMust = json["data"]["updateType"].stringValue == "1" ? true : false
                alert.appearAction()
            }
        }, onError: { (error) in
        }).disposed(by: self.bag)
    }
    
    
    
    //查看是否有未读消息
    private func checkMessage_Net() {
        
        print("-----------------检查未读消息")
        
        if UserDefaults.standard.isLogin {
            HTTPTOOl.isHaveMessage().subscribe(onNext: { (json) in
                if json["data"]["status"].stringValue == "1" {
                    self.moreView.isHave = true
                } else {
                    self.moreView.isHave = false
                }
                
            }, onError: { (error) in
            }).disposed(by: self.bag)
            
        } else {
            moreView.isHave = false
        }
    }
    
    //获取积分
    private func getJiFen_Net() {
        if UserDefaults.standard.isLogin {
            HTTPTOOl.getJiFenCount().subscribe(onNext: { (json) in
                
                //积分
                let jfStr = json["data"]["pointsNum"].stringValue
                //过期积分
                let gq_jf = json["data"]["expireNum"].intValue
                
                if gq_jf != 0 {
                    self.jifen_GQ_lab.isHidden = false
                } else {
                    self.jifen_GQ_lab.isHidden = true
                }
                self.jifen_GQ_lab.text = "\(gq_jf) to expire"
                
                
                self.jifenView.setData(number: jfStr)
                let w = jfStr.getTextWidth(BFONT(14), 24)
    
                self.jifenView.snp.updateConstraints {
                    $0.size.equalTo(CGSize(width: w + 10 + 26, height: 24))
                }
                self.jifenView.isHidden = false
                
                
            }).disposed(by: self.bag)
        }
    }
    
}


