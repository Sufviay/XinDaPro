//
//  StroeOrderFoodController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/13.
//

import UIKit
import RxSwift
import SwiftyJSON


//class StroeOrderFoodController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SelectSizeDelegate {
//
//
//
//    private let bag = DisposeBag()
//
//    private let manager = MenuOrderManager()
//
//    ///店铺ID
//    var storeID: String = ""
//
//    ///购买类型  1外卖 2自取
//    var buyType: String = ""
//
//    ///从店铺主页进来的
//    var isStoreMain: Bool = false
//
//
//    ///分类数组
//    private var classifyArr: [ClassiftyModel] = []
//
//    ///菜品数组
//    private var dishArr: [DishModel] = []
//
//    ///店铺信息模型
//    private let storeInfo = StoreInfoModel()
//
//    ///当前的分类下标
//    private var curClassifyIdx: Int = 0
//
//
//    ///当前购物车商品价格
////    private var curCartPrice: Float = 0
//
//    ///当前购物车的商品
//    private var cartDishArr: [CartDishModel] = []
//
//
//    private let backView: UIView = {
//        let view = UIView()
//        view.backgroundColor = MAINCOLOR
//        return view
//    }()
//
//    private let titLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(17), .center)
//        return lab
//    }()
//
//
//    private let backBut: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("nav_back"), for: .normal)
////        but.backgroundColor = .black.withAlphaComponent(0.4)
////        but.layer.cornerRadius = 7
//        return but
//    }()
//
////    private let searchBut: UIButton = {
////        let but = UIButton()
////        but.setImage(LOIMG("nav_search"), for: .normal)
////        but.backgroundColor = .clear
////        but.isHidden = true
////        return but
////    }()
//
//
//    private lazy var infoView: MenuHeadInfoView = {
//        let view = MenuHeadInfoView()
//
//        view.layer.cornerRadius = 10
//        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
//        // 阴影偏移，默认(0, -3)
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        // 阴影透明度，默认0
//        view.layer.shadowOpacity = 1
//        // 阴影半径，默认3
//        view.layer.shadowRadius = 3
//
//        view.clickBlock = { [unowned self] (_) in
//            let nextVC = StoreIntroduceController()
//            nextVC.storeInfoModel = self.storeInfo
//            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
//        }
//
//        view.clickPLBlock = { [unowned self] (_) in
//            let nextVC = StoreReviewsController()
//            nextVC.storeID = self.storeID
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
//
//        view.clickCheckPSBlock = { [unowned self] (_) in
//            let alert = PSFeeDesAlert()
//            alert.feeListArr = self.storeInfo.feeList
//            alert.appearAction()
//        }
//
//        return view
//    }()
//
//    private lazy var b_view: MenuBottomToolView = {
//        let view = MenuBottomToolView()
//        view.clickCheckBlock = { [unowned self] (_) in
//
//            let nextVC = ConfirmOrderController()
//            nextVC.storeID = self.storeID
//            nextVC.type = self.buyType
//            nextVC.storeModel = self.storeInfo
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
//        return view
//    }()
//
//
//
//    private lazy var selectView: MenuSelectWayView = {
//        let view = MenuSelectWayView()
//        view.backgroundColor = .white
//
//        view.clickBlock = { [unowned self] (type) in
//            self.buyType = type as! String
//            self.selectView.setButStyle(type: self.buyType, model: self.storeInfo)
//            self.updateCart_Net()
//        }
//
//
//        return view
//    }()
//
//    //分类列表
//    private lazy var l_table: UITableView = {
//        let tableView = GestureTableView()
//        tableView.backgroundColor = HCOLOR("#F7F7F7")
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.tag = 0
//        tableView.register(MenuTypeCell.self, forCellReuseIdentifier: "MenuTypeCell")
//        return tableView
//    }()
//
//    ///菜品列表
//    private lazy var r_table: UITableView = {
//        let tableView = GestureTableView()
//        tableView.backgroundColor = .white
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.tag = 1
//        tableView.register(MenuGoodsNoSizeCell.self, forCellReuseIdentifier: "MenuGoodsNoSizeCell")
//        tableView.register(MenuGoodsSizeCell.self, forCellReuseIdentifier: "MenuGoodsSizeCell")
//        return tableView
//    }()
//
//    ///钱包
//    private let walletView: WalletView = {
//        let view = WalletView()
//        return view
//    }()
//
//    override func setViews() {
//        setUpUI()
//        addNotificationCenter()
//        bingStore_Net()
//        loadStoreDetail_Net()
//
//    }
//
//    override func setNavi() {
//        getWalletMoney_Net()
//    }
//
//    private func setUpUI() {
//
////        view.addSubview(backImg)
////        backImg.snp.makeConstraints {
////            $0.left.right.top.equalToSuperview()
////            $0.height.equalTo(statusBarH + R_H(180))
////        }
//
//        view.addSubview(backView)
//        backView.snp.makeConstraints {
//            $0.right.left.top.equalToSuperview()
//            $0.height.equalTo(statusBarH + 100)
//        }
//
//
//        view.addSubview(backBut)
//        backBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 40, height: 40))
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalToSuperview().offset(statusBarH + 2)
//        }
//
//        view.addSubview(titLab)
//        titLab.snp.makeConstraints {
//            $0.centerY.equalTo(backBut)
//            $0.centerX.equalToSuperview()
//        }
//
//
//
//        view.addSubview(infoView)
//        infoView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalTo(backView.snp.bottom).offset(-45)
//            $0.height.equalTo(130)
//        }
//
//
////        view.addSubview(searchBut)
////        searchBut.snp.makeConstraints {
////            $0.size.centerY.equalTo(backBut)
////            $0.right.equalToSuperview().offset(-10)
////        }
////
//
//        view.addSubview(selectView)
//        selectView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalTo(infoView.snp.bottom).offset(10)
//            $0.height.equalTo(40)
//        }
//
//        view.addSubview(b_view)
//        b_view.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.height.equalTo(50)
//        }
//
//        view.addSubview(l_table)
//        l_table.snp.makeConstraints {
//            $0.top.equalTo(selectView.snp.bottom).offset(15)
//            $0.left.equalToSuperview()
//            $0.bottom.equalTo(b_view.snp.top)
//            $0.width.equalTo(90)
//        }
//
//        view.addSubview(r_table)
//        r_table.snp.makeConstraints {
//            $0.left.equalTo(l_table.snp.right)
//            $0.right.equalToSuperview()
//            $0.top.equalTo(selectView.snp.bottom).offset(15)
//            $0.bottom.equalTo(b_view.snp.top)
//        }
//
//        view.addSubview(walletView)
//
//        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
//        //searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
//
//    }
//
//    @objc private func clickBackAction() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//
//
//    @objc private func clickSearchAction() {
//
//    }
//
//
//    //MARK: - 注册通知中心
//    private func addNotificationCenter() {
//        NotificationCenter.default.addObserver(self, selector: #selector(orderRefresh), name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(walletRefresh), name: NSNotification.Name(rawValue: "wallet"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(loginRefresh), name: NSNotification.Name(rawValue: "login"), object: nil)
//    }
//
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("cartRefresh"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("wallet"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("login"), object: nil)
//    }
//
//
//    @objc func orderRefresh() {
//        self.loadDishesData_Net(classID: self.classifyArr[curClassifyIdx].flID)
//    }
//
//    @objc func walletRefresh() {
//        getWalletMoney_Net()
//    }
//
//    @objc func loginRefresh() {
//        bingStore_Net()
//        loadStoreDetail_Net()
//        getWalletMoney_Net()
//    }
//
//
//
//
//    //MARK: - 网络请求
//    ///绑定店铺
//    private func bingStore_Net() {
//
//        if UserDefaults.standard.isLogin {
//            HTTPTOOl.bindingStore(storeID: storeID).subscribe(onNext: {_ in
//                NotificationCenter.default.post(name: NSNotification.Name("bindingRefresh"), object: nil)
//            }, onError: {_ in }).disposed(by: self.bag)
//        }
//    }
//
//
//    ///请求店铺详情
//    private func loadStoreDetail_Net() {
//
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.Store_MainPageData(storeID: storeID, type: "").subscribe(onNext: { [self] (json) in
//            //HUD_MB.dissmiss(onView: self.view)
//            self.storeInfo.updateModel(json: json["data"])
//            self.titLab.text = self.storeInfo.name
//            self.infoView.setData(model: self.storeInfo)
//
//            //更新店铺信息栏的高度
//            let h = self.storeInfo.name.getTextHeigh(BFONT(17), S_W - 140) + self.storeInfo.tags.getTextHeigh(SFONT(13), S_W - 170) + 100
//            self.infoView.snp.updateConstraints {
//                $0.height.equalTo(h)
//            }
//
//            self.selectView.setData(model: self.storeInfo)
//
//            //判断
//            if !self.isStoreMain {
//                //从店铺列表进入点餐页面
//                if self.storeInfo.deStatus == "1" && self.storeInfo.coStatus == "1" {
//                    self.buyType = "1"
//                }
//                if self.storeInfo.deStatus == "1" && self.storeInfo.coStatus == "2" {
//                    self.buyType = "1"
//                }
//                if self.storeInfo.deStatus == "2" && self.storeInfo.coStatus == "1" {
//                    self.buyType = "2"
//                }
//                if self.storeInfo.deStatus == "2" && self.storeInfo.coStatus == "2" {
//                    //关店状态
//                    self.buyType = ""
//                }
//            }
//
//            self.selectView.setButStyle(type: self.buyType, model: self.storeInfo)
//            self.loadClassifyData_Net()
//
//        }, onError: { (error) in
//            HUD_MB.showMessage(ErrorTool.errorMessage(error), self.view)
//        }).disposed(by: self.bag)
//
//    }
//
//
//    ///请求菜品分类
//    private func loadClassifyData_Net() {
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.getClassifyList(storeID: storeID).subscribe(onNext: { (json) in
//            var cArr: [ClassiftyModel] = []
//            for jsondata in json["data"].arrayValue {
//                let model = ClassiftyModel()
//                model.updateModel(json: jsondata)
//                cArr.append(model)
//            }
//            self.classifyArr = cArr
//            self.l_table.reloadData()
//
//            self.loadDishesData_Net(classID: cArr[0].flID)
//
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
//
//
//    ///请求分类下的商品
//    private func loadDishesData_Net(classID: String) {
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.getClassifyDishesList(classifyID: classID, storeID: storeID, keyword: "").subscribe(onNext: { (json) in
//
//            var dArr: [DishModel] = []
//            for jsondata in json["data"].arrayValue {
//                let model = DishModel()
//                model.updateModel(json: jsondata)
//                dArr.append(model)
//            }
//            self.dishArr = dArr
//            self.loadCartAdded_Net()
//
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
//
//    ///请求已添加购物车的商品
//    private func loadCartAdded_Net() {
//
//
//        if UserDefaults.standard.isLogin {
//
//            HUD_MB.loading("", onView: view)
//            HTTPTOOl.getAddedCartDishes(storeID: storeID, psType: buyType).subscribe(onNext: { (json) in
//                HUD_MB.dissmiss(onView: self.view)
//                print("已添加的")
//                //比对当前的菜品列表
//                self.manager.getDishesListByCart(cartJson: json, curDishArr: self.dishArr)
//                self.r_table.reloadData()
//                //设置底部工具栏
//                self.b_view.money = json["data"]["allPrice"].floatValue
//                self.cartDishArr = self.manager.updateCartDishArr(json: json)
//
//                ///3 OK  4 NO
//                let isClose = json["data"]["deliveryType"].stringValue == "4" ? true : false
//                self.b_view.isClosed = isClose
//
//                self.b_view.isHidden = false
//
//            }, onError: { (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//            }).disposed(by: self.bag)
//
//
//        } else {
//
//            HUD_MB.dissmiss(onView: self.view)
//            self.r_table.reloadData()
//
//            //设置底部工具栏
//            self.b_view.money = 0
//            ///3 OK  4 NO
//            self.b_view.isClosed = true
//            self.b_view.isHidden = false
//        }
//    }
//
//    ///添加购物车
//    private func addCart_Net(dishesID: String, buyNum: String, optionList: [[String: String]]) {
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.addShoppingCart(dishesID: dishesID, buyNum: buyNum, type: "2", optionList: optionList).subscribe(onNext: { (json) in
//            self.loadDishesData_Net(classID: self.classifyArr[self.curClassifyIdx].flID)
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
//
//    ///修改购物车数量
//    private func updateCartNum_Net(cartID: String, number: Int) {
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.updateCartNum(buyNum: number, cartID: cartID).subscribe(onNext: { (json) in
//            self.loadDishesData_Net(classID: self.classifyArr[self.curClassifyIdx].flID)
//
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
//
//
//    ///更新购物车
//    private func updateCart_Net() {
//
//        if UserDefaults.standard.isLogin {
//            HUD_MB.loading("", onView: view)
//            HTTPTOOl.getAddedCartDishes(storeID: storeID, psType: buyType).subscribe(onNext: { (json) in
//                HUD_MB.dissmiss(onView: self.view)
//                //设置底部工具栏
//                self.b_view.money = json["data"]["allPrice"].floatValue
//                //self.curCartPrice = json["data"]["allPrice"].floatValue
//                self.cartDishArr = self.manager.updateCartDishArr(json: json)
//                //self.b_view.type = self.buyType
//
//                let isClose = json["data"]["deliveryType"].stringValue == "4" ? true : false
//                self.b_view.isClosed = isClose
//
//                self.b_view.isHidden = false
//
//            }, onError: { (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//            }).disposed(by: self.bag)
//        }
//    }
//
//
//    //获取钱包
//    @objc func getWalletMoney_Net() {
//
//        if UserDefaults.standard.isLogin {
//            HTTPTOOl.getWalletAmount().subscribe(onNext: { (json) in
//
//                let moneyStr = "£" + json["data"]["amount"].stringValue
//                self.walletView.setData(money: moneyStr)
//                let w = moneyStr.getTextWidth(SFONT(11), 23) > 15 ? moneyStr.getTextWidth(SFONT(11), 23) : 15
//
//
//                self.walletView.snp.makeConstraints {
//                    $0.top.equalToSuperview().offset(statusBarH + 6)
//                    $0.right.equalToSuperview().offset(-20)
//                    $0.size.equalTo(CGSize(width: w + 50, height: 32))
//                }
//                self.walletView.isHidden = false
//
//            }, onError: { (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//            }).disposed(by: self.bag)
//
//        }
//
//    }
//
//}
//
//
//
//
//extension StroeOrderFoodController {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView.tag == 0 {
//
//            let h = classifyArr[indexPath.row].flName_C.getTextHeigh(BFONT(13), 70) + 30
//
//            return h > 50 ? h : 50
//
//        } else {
//            let model = dishArr[indexPath.row]
//            let n_h = model.name_C.getTextHeigh(BFONT(14), S_W - 225)
//            let d_h = model.des.getTextHeigh(SFONT(11), S_W - 225)
//            let h = (n_h + d_h + 85) > 120 ? (n_h + d_h + 85) : 120
//
//            if model.isSelect {
//                //计算高度
//                var o_h: CGFloat = 0
//                for selectModel in model.cart {
//                    o_h += (selectModel.selectOptionStr.getTextHeigh(SFONT(13), S_W - 180) + 50)
//                }
//                return h + o_h
//            } else {
//                return h
//            }
//
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView.tag == 0 {
//            return classifyArr.count
//        } else {
//            return dishArr.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if tableView.tag == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTypeCell") as! MenuTypeCell
//            let isSelect: Bool = indexPath.row == curClassifyIdx ? true : false
//            cell.setCellData(isSelect: isSelect, name: classifyArr[indexPath.row].flName_E)
//            return cell
//        } else {
//            let model = dishArr[indexPath.row]
//            if model.isSelect {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsSizeCell") as! MenuGoodsSizeCell
//                cell.setCellData(model: model)
//
////                cell.selectBlock = { [unowned self] (_) in
////                    //进入菜品详情页面
////                    let nextVC = SelectSizeController()
////                    nextVC.dishesID = model.dishID
////                    nextVC.delegate = self
////                    self.navigationController?.pushViewController(nextVC, animated: true)
////                }
//
////                cell.clickCountBlock = { [unowned self] (info) in
////
////                    let dic = info as! [String: Any]
////                    //更改购物车数量
////                    let cartModel = dic["model"] as! CartDishModel
////                    let count = dic["count"] as! Int
////                    self.updateCartNum_Net(cartID: cartModel.cartID, number: count)
////
////                }
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsNoSizeCell") as! MenuGoodsNoSizeCell
//                cell.setCellData(model: model)
//
//                cell.clickCountBlock = { [unowned self] (count) in
//
//                    let model = dishArr[indexPath.row]
//                    if model.cart.count == 0 {
//                        //添加购物车
//                        self.addCart_Net(dishesID: model.dishID, buyNum: String(count as! Int), optionList: [])
//                    } else {
//                        //更新购物车
//                        self.updateCartNum_Net(cartID: model.cart[0].cartID, number: count as! Int)
//                    }
//                }
//
//                return cell
//            }
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.tag == 0 {
//            if curClassifyIdx != indexPath.row {
//                curClassifyIdx = indexPath.row
//                self.l_table.reloadData()
//                self.loadDishesData_Net(classID: self.classifyArr[curClassifyIdx].flID)
//                self.r_table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//            }
//        }
//
//        if tableView.tag == 1 {
//
//            let model = dishArr[indexPath.row]
//            if model.isOn {
//                print("aaaaa")
//                let nextVC = SelectSizeController()
//                nextVC.dishesID = model.dishID
//                nextVC.delegate = self
//                self.navigationController?.pushViewController(nextVC, animated: true)
//            }
//        }
//    }
//
//
//    ///选择规格之后
//    func didSelectedSpecification() {
//        self.loadDishesData_Net(classID: self.classifyArr[curClassifyIdx].flID)
//    }
//
//}
