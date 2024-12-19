//
//  StoreMenuOrderController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/6.
//

import UIKit
import RxSwift


class StoreMenuOrderController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let bag = DisposeBag()
    
    ///店铺ID
    var storeID: String = ""
    

    ///店铺信息模型
    private let storeInfo = StoreInfoModel()
    
    ///店铺菜品模型
    private var menuInfo = MenuModel()
    
    ///购物车的数据模型
    private var cartModel = CartDataModel()
        
    ///tableview是否可以滑动
    private var canScroll: Bool = true
    
    
    
    ///自定义的导航栏
    private lazy var headerView: MenuNavBarView = {
        let view = MenuNavBarView()
        
        view.backBlock = { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        view.searchBlock = { [unowned self] _ in
            print("Search")
            if PJCUtil.checkLoginStatus() {
                let searchVC = OrderSearchController()
                searchVC.cartModel = cartModel
                searchVC.storeInfo = storeInfo
                searchVC.storeID = storeID
                searchVC.menuInfo = menuInfo
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
        }
        
        return view
    }()
    
    
    
    ///底部价格栏
    private lazy var b_view: MenuBottomToolView = {
        let view = MenuBottomToolView()
        view.isHidden = true
        view.clickCheckBlock = { [unowned self] (_) in
            
            //判断购物车中是否有实效的商品
            var isHaveFailure: Bool = false
            for model in self.cartModel.dishesList {
                if model.isOn != "1" {
                    isHaveFailure = true
                    break
                }
            }
            
            if isHaveFailure {
                HUD_MB.showWarnig("Please delete unavailable items!", onView: self.view)
            } else {
                self.cartView.disAppearAction()
                let nextVC = ConfirmOrderController()
                nextVC.storeID = self.storeID
                nextVC.type = self.menuInfo.buyType
                nextVC.curentTimeModel = self.menuInfo.curentTime
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
        
        view.clickCartBlock = { [unowned self] (_) in
            //弹出购购物车
            if self.cartModel.dishesList.count != 0 {
                if self.cartView.isHidden {
                    //self.cartView.cartDataArr = self.cartModel.dishesList
                    self.cartView.appearAction()
                } else {
                    self.cartView.disAppearAction()
                }
            }
        }
        
        return view
    }()
    
    
    ///显示信息的TableView
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
        tableView.bounces = false
        
        tableView.register(MenuStoreContentCell.self, forCellReuseIdentifier: "MenuStoreContentCell")
        tableView.register(MenuTimeTabCell.self, forCellReuseIdentifier: "MenuTimeTabCell")
        tableView.register(MenuContentCell.self, forCellReuseIdentifier: "MenuContentCell")
        tableView.isHidden = true
        
        return tableView
    }()
    
    ///购物车弹窗
    private lazy var cartView: MenuCartView = {
        let view = MenuCartView()
        view.storeID = self.storeID
        return view
    }()

    
        
    override func setNavi() {
        getJiFen_Net()
    }
    
    override func setViews() {
        
        print("++++++++++", S_W - 230)
        
        
        self.naviBar.isHidden = true
        setUpUI()
        setUpDishesDataView()
        loadStoreDetail_Net()
        loadCanBookingStatus_Net()
        addNotificationCenter()
    }
    
    func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        
    }
    
    func setUpDishesDataView() {
        

        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50 - 15 - 10)
        }
        
        view.addSubview(cartView)
        
        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(10))
            $0.right.equalToSuperview().offset(-R_W(10))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 15)
            $0.height.equalTo(50)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("cartRefresh"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("login"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("botTable"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("classify"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pageRefresh"), object: nil)
        
        print("\(self.classForCoder)销毁了")
        
    }
}


extension StoreMenuOrderController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            if menuInfo.openTimeArr.count == 0 {
                return 0
            } else {
                return 1
            }
            
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return storeInfo.storeContent_H
        }
        if indexPath.section == 1 {
            return 40
        }
        if indexPath.section == 2 {
            
            if menuInfo.openTimeArr.count == 0 {
                return S_H - statusBarH - 44 - bottomBarH - 50 - 15 - 10 + 1
            } else {
                return S_H - statusBarH - 44 - bottomBarH - 50 - 15 - 10 - 40 + 1
            }

            
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuStoreContentCell") as! MenuStoreContentCell
            cell.setCellData(model: storeInfo, timeModel: menuInfo.curentTime, buyType: menuInfo.buyType)
            
            //点击切换购买方式
            cell.clickBuyTypeBlock = { [unowned self] (type) in
                self.menuInfo.buyType = type
                self.mainTable.reloadSections([0], with: .none)
                if UserDefaults.standard.isLogin {
                    HUD_MB.loading("", onView: view)
                    loadCartData_Net()
                    //loadData_Net()
                }
            }
            
            return cell
            
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTimeTabCell") as! MenuTimeTabCell
            cell.setCellData(timeArr: menuInfo.openTimeArr, selectIdx: menuInfo.curTimeIdx)
            cell.selectBlock = { [unowned self] (idx) in
                self.menuInfo.curTimeIdx = idx as! Int
                self.menuInfo.classifyIdx = 0
                self.menuInfo.isChangeSelectTime = true
                ///刷新午餐晚餐的列表
                self.mainTable.reloadData()
                
                /**
                 这样写回崩溃  数组越界 很神奇 不知道为什么
                 */
                //self.mainTable.reloadSections([1, 2], with: .none)
            }
            return cell
        }

        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuContentCell") as! MenuContentCell
            cell.setCellData(model: menuInfo, isHaveVip: storeInfo.isVip)
            
            //弹出购物车
            cell.showCartBlock = { [unowned self] (_) in
                //self.cartView.cartDataArr = self.cartModel.dishesList
                self.cartView.appearAction()
            }
            
            //添加购物车
            cell.addCartBlock = { [unowned self] (par) in
                let info = par as! [String : Any]
                let count = info["num"] as! Int
                let dishID = info["id"] as! String
                self.addCart_Net(dishesID: dishID, buyNum: count)
            }
            
            //更新购物车
            cell.updateCartBlock = { [unowned self] (par) in
                let info = par as! [String : Any]
                let count = info["num"] as! Int
                let cartID = info["id"] as! String
                self.updateCart_Net(cartID: cartID, buyNum: count)

            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }

}



extension StoreMenuOrderController {
    
    //请求是否可预定
    private func loadCanBookingStatus_Net() {
        
        if UserDefaults.standard.isLogin {
            HTTPTOOl.isCanBooking(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
                if json["data"]["reserveStatus"].stringValue == "2" {
                    //是
                    storeInfo.isOpenBooking = true
                }
                if json["data"]["reserveStatus"].stringValue == "1" {
                    //否
                    storeInfo.isOpenBooking = false
                }
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showMessage(ErrorTool.errorMessage(error), self.view)
            }).disposed(by: bag)
        }
    }

    
    
    //获取积分
    private func getJiFen_Net() {
        if UserDefaults.standard.isLogin {
            HTTPTOOl.getJiFenCount().subscribe(onNext: {[unowned self] (json) in
                //积分
                let jfStr = json["data"]["pointsNum"].stringValue
                headerView.setData(amount: jfStr)
            }, onError: {[unowned self] _ in
                headerView.setData(amount: "0")
            }).disposed(by: self.bag)
        } else {
            headerView.setData(amount: "0")
        }
    }


    //MARK: - 请求是否有首单优惠和用户的Vip
    private func loadFirstDiscountAndVip_Net() {
        if UserDefaults.standard.isLogin {
            HTTPTOOl.getUserVip(storeID: storeID).subscribe(onNext: { [unowned self] (json1) in
                storeInfo.isVip = json1["data"]["vipType"].stringValue == "2" ? true: false
                storeInfo.vipAmount = D_2_STR(json1["data"]["amount"].doubleValue) 
                cartView.isVip = storeInfo.isVip
                HTTPTOOl.getStoreDetailFirstDiscount(storeID: storeID).subscribe(onNext: { [unowned self] json1 in
                    storeInfo.isFirstDiscount = json1["data"]["firstType"].stringValue == "2" ? true : false
                    storeInfo.updateStoreInfo_H()
                    mainTable.reloadData()
                }).disposed(by: self.bag)
            }).disposed(by: bag)
        }
    }
    
    
    //MARK: - 请求店铺详情
    private func loadStoreDetail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.Store_MainPageData(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
            
            self.storeInfo.updateModel(json: json["data"])
            //是否有首单优惠
            self.loadFirstDiscountAndVip_Net()
            //请求菜品信息
            self.loadData_Net()

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    //MARK: - 请求分类和菜品和购物车的数据
    private func loadData_Net() {
        
        ///获取所有分类和所有菜品
        HTTPTOOl.getClassifyAndDishesList(storeID: storeID, deliveryType: "").subscribe(onNext: { [unowned self] (json) in

            ///初始化菜单页面的数据
            self.menuInfo.updateModel(json: json)

            ///如果登录就请求购物车的信息
            if UserDefaults.standard.isLogin {
                ///请求购物车中的菜品信息
                self.loadCartData_Net()
            } else {
                
                self.b_view.setValue(dishMoney: "0", buyCount: 0, discountType: "2", discountMoney: "0", minOrder: D_2_STR(self.storeInfo.minOrder), type: "9")
                self.b_view.isHidden = false
                self.mainTable.isHidden = false
                HUD_MB.dissmiss(onView: self.view)
                self.mainTable.reloadData()
            }
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 已添加购物车的菜品
    func loadCartData_Net() {
        
        let buyType = menuInfo.buyType == "" ? "1" : menuInfo.buyType
        HTTPTOOl.getAddedCartDishes(storeID: storeID, psType: buyType).subscribe(onNext: { [unowned self] (json) in
            
            self.cartModel.updateModel(json: json)
            
            ///赋值购物车弹窗
            self.cartView.cartDataArr = self.cartModel.dishesList
    
            ///根据购物车 处理页面数据
            self.menuInfo.dealWithMenuDishesByCartData(cart_arr: self.cartModel.dishesList)
                        
            ///更新底部购物车栏
            self.b_view.setValue(dishMoney: D_2_STR(self.cartModel.allPrice), buyCount: self.cartModel.dishesNum, discountType: self.cartModel.discountType, discountMoney: D_2_STR(self.cartModel.discountAmount), minOrder: D_2_STR(self.storeInfo.minOrder), type: self.cartModel.deliveryType)

            self.b_view.isHidden = false
            self.mainTable.isHidden = false
            HUD_MB.dissmiss(onView: self.view)
            self.mainTable.reloadData()

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - 添加购物车
    private func addCart_Net(dishesID: String, buyNum: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.addShoppingCart(dishesID: dishesID, buyNum: "1", type: "2", optionList: [], deskID: "").subscribe(onNext: { [unowned self] (json) in
            self.loadCartData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 修改购物车
    private func updateCart_Net(cartID: String, buyNum: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.updateCartNum(buyNum: buyNum, cartID: cartID).subscribe(onNext: { [unowned self] (json) in
            self.loadCartData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}

extension StoreMenuOrderController {
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartDataRefresh(info:)), name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pageDataRefresh), name: NSNotification.Name(rawValue: "pageRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name(rawValue: "login"), object: nil)
        
        //MARK: - 页面的嵌套滑动
        //注册通知中心 等待下层tabel发来状态改变
        NotificationCenter.default.addObserver(self, selector: #selector(slideAction), name: NSNotification.Name(rawValue: "botTable"), object: nil)
        
        //当点击分类时 店铺信息页面自动置顶
        NotificationCenter.default.addObserver(self, selector: #selector(classifyAction), name: NSNotification.Name(rawValue: "classify"), object: nil)

    }
    
    
    //点击了分类
    @objc private func classifyAction() {
        let h = storeInfo.storeSellLunchOrDinner == "2" ? storeInfo.storeContent_H + 50 : storeInfo.storeContent_H
        self.mainTable.contentOffset = CGPoint(x: 0, y: h)
    }
    

    //页面嵌套滑动 收到下层table的通知，上层table可以开始滑动
    @objc private func slideAction() {
        self.canScroll = true
    }
    
    
    
    //数据刷新
    @objc private func cartDataRefresh(info: Notification) {
        let type = info.object as? String
        
        //如果接收到的type == "1" 不需要请求接口
        if type ?? "" == "1" {
            mainTable.reloadData()
            ///赋值购物车弹窗
            cartView.cartDataArr = self.cartModel.dishesList
            ///更新底部购物车栏
            b_view.setValue(dishMoney: D_2_STR(self.cartModel.allPrice), buyCount: self.cartModel.dishesNum, discountType: self.cartModel.discountType, discountMoney: D_2_STR(self.cartModel.discountAmount), minOrder: D_2_STR(self.storeInfo.minOrder), type: self.cartModel.deliveryType)
            
        } else {
            loadCartData_Net()
        }
    }
    
    //整个页面进行数据刷新
    @objc private func pageDataRefresh() {
        loadStoreDetail_Net()
    }
    
    
    //登录刷新
    @objc private func loginRefresh() {
        loadStoreDetail_Net()
        loadCanBookingStatus_Net()
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let h = storeInfo.storeSellLunchOrDinner == "2" ? storeInfo.storeContent_H + 50 : storeInfo.storeContent_H
        print("+++++++++++++++++++", y)
        if !canScroll {
            //上层table保持不动
            scrollView.contentOffset = CGPoint(x: 0, y: h)
        }
        
        /**
         当contentOffset.y大于200时
         上层的Table保持不动
         并发送通知让下层table动
         */

        if y >= h {
            //发送通知 让下层tabelView滑动
            let cellArr = mainTable.visibleCells
            let cell = cellArr.last
            if cell != nil {
                if cell!.isKind(of: MenuContentCell.self) {
                    let frame_H = (cell as! MenuContentCell).r_table.frame.size.height
                    let content_H = (cell as! MenuContentCell).r_table.contentSize.height
                    if frame_H > content_H {
                        canScroll = true
                    } else {
                        self.canScroll = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topTable"), object: nil)
                    }
                }
            }
        }
    }
}

