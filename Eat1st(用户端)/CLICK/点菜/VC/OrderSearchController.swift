//
//  OrderSearchController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/7/8.
//

import UIKit
import MJRefresh
import RxSwift


class OrderSearchController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    private let bag = DisposeBag()
    
    
    ///菜品数据
    private var allDataArr: [ClassiftyModel] = [] {
        didSet {
            dataArr.removeAll()
            
            for c_model in allDataArr {
                for d_model in c_model.dishArr {
                    dataArr.append(d_model)
                    self.table.reloadData()
                }
            }
            
        }
    }
    
    var deskID: String = ""
    
    ///店铺信息数据
    var storeInfo = StoreInfoModel()
    
    ///店铺菜品模型
    var menuInfo = MenuModel() {
        didSet {
            if menuInfo.buyType == "" {
                //店铺为关店状态 所有商品将不可购买
                canBuy = false
                allDataArr = menuInfo.allDataArr
            } else {
                canBuy = true
                allDataArr = menuInfo.curentTime.dataArr
            }
        }
    }
    
    ///购物车数据
    var cartModel = CartDataModel()
    
    ///是否可购买
    private var canBuy: Bool = false
    
    var storeID: String = ""
    
    private var dataArr: [DishModel] = []

    private var searchResultArr: [DishModel] = []
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private let searchBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F2F2F2")
        view.layer.cornerRadius = 35 / 2
        return view
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#DDDDDD")
        return view
    }()
    
    private let searchBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("first_search"), for: .normal)
        return but
    }()
    
    private lazy var searchTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.placeholder = "Search for dishes"
        tf.font = BFONT(13)
        tf.delegate = self
        return tf
    }()

    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
                
                var vcs = self.navigationController?.viewControllers
                vcs?.removeLast()
                let nextVC = ConfirmOrderController()
                nextVC.storeID = self.storeID
                nextVC.type = self.menuInfo.buyType
                nextVC.curentTimeModel = self.menuInfo.curentTime
                vcs?.append(nextVC)
                self.navigationController?.setViewControllers(vcs!, animated: true)
                
                //self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
        }
        
        
        view.clickCartBlock = { [unowned self] (_) in
            //弹出购购物车
            if self.cartModel.dishesList.count != 0 {
                if self.cartView.isHidden {
                    self.cartView.appearAction()
                } else {
                    self.cartView.disAppearAction()
                }
            }
        }

        
        return view
    }()
    
    ///购物车弹窗
    private lazy var cartView: MenuCartView = {
        let view = MenuCartView()
        view.isSearchVC = true
        view.storeID = self.storeID
        return view
    }()

    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        
//        tableView.register(MenuGoodsNoSizeCell.self, forCellReuseIdentifier: "MenuGoodsNoSizeCell")
//        tableView.register(MenuGoodsSizeCell.self, forCellReuseIdentifier: "MenuGoodsSizeCell")
//
        tableView.register(MenuDishesCell.self, forCellReuseIdentifier: "MenuDishesCell")
        
        return tableView
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()

    
    
    override func setViews() {
        self.naviBar.isHidden = true
        setUpUI()
        addNotificationCenter()
        b_view.setValue(dishMoney: D_2_STR(self.cartModel.allPrice), buyCount: self.cartModel.dishesNum, discountType: self.cartModel.discountType, discountMoney: D_2_STR(self.cartModel.discountAmount), minOrder: D_2_STR(self.storeInfo.minOrder), type: self.cartModel.deliveryType)
    }
    
    
    
    
    
    func setUpUI() {
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        view.addSubview(searchBackView)
        searchBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.centerY.equalTo(backBut)
            $0.height.equalTo(35)
            $0.right.equalToSuperview().offset(-10)
        }
        
        searchBackView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 20))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-45)
        }
        
        searchBackView.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.left.equalTo(line1.snp.right).offset(0)
            $0.top.bottom.right.equalToSuperview()
        }
        
        searchBackView.addSubview(searchTF)
        searchTF.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-50)
        }
        
        view.addSubview(line2)
        line2.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(7)
            $0.top.equalToSuperview().offset(statusBarH + 50)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line2.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10 - 15 - 50)
        }
        
        cartView.cartDataArr = cartModel.dishesList
        view.addSubview(cartView)
        
        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(10))
            $0.right.equalToSuperview().offset(-R_W(10))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 15)
            $0.height.equalTo(50)
        }
        

        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        searchBut.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
    }
    
    
    

    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchAction() {
        doSearch()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ///输入结束 开始搜索
        doSearch()
    }
    
    func doSearch() {
        if searchTF.text ?? "" == "" {
            return
        } else {
            let searchStr = searchTF.text!
            searchResultArr.removeAll()
            for model in dataArr {
                if model.name.contains(searchStr) {
                    
                    ///去掉重复的
                    if (searchResultArr.filter { $0.dishID == model.dishID }.count == 0) {
                        searchResultArr.append(model)
                        continue
                    }
                }
                
                for t_model in model.tagList {
                    if t_model.tagName.contains(searchStr) {
                        ///去掉重复的
                        if (searchResultArr.filter { $0.dishID == model.dishID }.count == 0) {
                            searchResultArr.append(model)
                            break
                        }
                    }
                }
            }
        }
        
        if searchResultArr.count == 0 {
            table.addSubview(noDataView)
            table.reloadData()
            b_view.isHidden = true
        } else {
            noDataView.removeFromSuperview()
            table.reloadData()
            b_view.isHidden = false
        }
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(pageRefresh), name: NSNotification.Name(rawValue: "SearchRefresh"), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SearchRefresh"), object: nil)
        print("\(self.classForCoder)销毁了")

    }
    
    @objc private func pageRefresh() {
        loadCartData_Net()
    }

    
}


extension OrderSearchController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResultArr[indexPath.row].dish_H_S
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = searchResultArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishesCell") as! MenuDishesCell
        cell.setCellData(model: model, canBuy: canBuy)
        
        cell.optionBlock = { [unowned self] _ in
            ///进入选择规格页面
            
            if model.dishesType == "1" {
                //单品
                let nextVC = SelectSizeController()
                nextVC.dishesID = model.dishID
                nextVC.canBuy = self.canBuy
                nextVC.deskID = self.deskID
                nextVC.isSearchVC = true
                nextVC.isVip = storeInfo.isVip
                nextVC.deType = menuInfo.buyType
                PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
            }
            if model.dishesType == "2" {
                //套餐
                let nextVC = MealSelectSizeController()
                nextVC.dishesID = model.dishID
                nextVC.canBuy = self.canBuy
                nextVC.deskID = self.deskID
                nextVC.isSearchVC = true
                nextVC.isVip = storeInfo.isVip
                nextVC.deType = menuInfo.buyType

                PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
            }
        }

        cell.clickCountBlock = { [unowned self] (par) in
            
            let count = par as! Int
            if model.sel_Num == 0 {
                //添加购物车
                self.addCart_Net(dishesID: model.dishID, buyNum: count)
                
            } else {
                //更新购物车
                self.updateCart_Net(cartID: model.cart[0].cartID, buyNum: count)
            }
        }
        
        return cell        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击进入菜品详情页页面
        let model = searchResultArr[indexPath.row]
        
        if model.dishesType == "1" {
            //单品
            if model.isOn == "1" {
                print("aaaaa")
                let nextVC = SelectSizeController()
                nextVC.dishesID = model.dishID
                nextVC.canBuy = canBuy
                nextVC.deskID = deskID
                nextVC.isSearchVC = true
                nextVC.isVip = storeInfo.isVip
                nextVC.deType = menuInfo.buyType

                //如果不是规格规格商品 且已添加到购物车中 需将数量带到下一页面
                if !model.isSelect && model.cart.count != 0 {
                    nextVC.cartID = model.cart[0].cartID
                    nextVC.dishCount = model.sel_Num
                }
                                
                PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        if model.dishesType == "2" {
            //套餐
            let nextVC = MealSelectSizeController()
            nextVC.dishesID = model.dishID
            nextVC.canBuy = canBuy
            nextVC.deskID = deskID
            nextVC.isSearchVC = true
            nextVC.isVip = storeInfo.isVip
            nextVC.deType = menuInfo.buyType
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
        }

    }
    
}




extension OrderSearchController {
    
    //MARK: - 添加购物车
    private func addCart_Net(dishesID: String, buyNum: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.addShoppingCart(dishesID: dishesID, buyNum: "1", type: "2", optionList: [], deskID: deskID).subscribe(onNext: { [unowned self] (json) in
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

    
    //MARK: - 已添加购物车的菜品
    func loadCartData_Net() {
        
        
        var buyType = ""
        if deskID == "" {
            buyType = menuInfo.buyType == "" ? "1" : menuInfo.buyType
        } else {
            buyType = "3"
        }
        
        HTTPTOOl.getAddedCartDishes(storeID: storeID, psType: buyType).subscribe(onNext: { [unowned self] (json) in
            
            self.cartModel.updateModel(json: json)
            
            ///赋值购物车弹窗
            self.cartView.cartDataArr = self.cartModel.dishesList
    
            ///根据购物车 处理页面数据
            self.menuInfo.dealWithMenuDishesByCartData(cart_arr: self.cartModel.dishesList)
                        
            ///更新底部购物车栏
            self.b_view.setValue(dishMoney: D_2_STR(self.cartModel.allPrice), buyCount: self.cartModel.dishesNum, discountType: self.cartModel.discountType, discountMoney: D_2_STR(self.cartModel.discountAmount), minOrder: D_2_STR(self.storeInfo.minOrder), type: self.cartModel.deliveryType)
            //发送通知 点菜页面刷新数据
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: "1")
            HUD_MB.dissmiss(onView: self.view)
            self.table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}
