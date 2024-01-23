//
//  DishListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit
import RxSwift
import MJRefresh


class DishListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    private let bag = DisposeBag()
    
    
    var titStr: String = ""
    var deskID: String = ""
    
    var attachDataArr: [AttachClassifyModel] = []
    
    ///全部的菜品数据
    private var allDataArr: [DishModel] = []
    ///筛选词
    private var screenKey: String = ""
    ///筛选后的菜品数据
    private var screenDataArr: [DishModel] = []
    
    ///购物车中的菜品模型
    private var cartData = CartModel()
    
    ///筛选按钮
    private let screenBut: ScreenBut = {
        let but = ScreenBut()
        return but
    }()
    
    private var isShowSX: Bool = false
    
    
    ///底部购物车
    private lazy var b_cartView: CartConfirmView = {
        let view = CartConfirmView()
        
        view.clickCartBlock = { [unowned self]  (_) in
            if cartAlert.isHidden {
                cartAlert.appearAction()
            } else {
                cartAlert.disAppearAction()
            }
        }
        
        
        view.clickConfirmBlock = { [unowned self]  (_) in
            if cartData.dishesList.count != 0 {
                cartAlert.disAppearAction()
                createOrder_Net()
            }
        }
        
        return view
    }()
    
    ///购物车弹窗
    private lazy var cartAlert: CartView = {
        let view = CartView()
        view.dataModel = cartData
        
        view.cleanAllBlock = { [unowned self] _ in
            //清除购物车
            b_cartView.updateData(price: "0", data: cartData)
        }
        
        view.deleteBlock = { [unowned self] _ in
            //删除菜品 计算菜品价格
            doCalOrder_Net()
        }
        
        view.detailBlock = { [unowned self] (idx) in
            //进入详情
            detailView.dishID = cartData.dishesList[idx].dishesId
            detailView.deskID = deskID
            detailView.buyNum = cartData.dishesList[idx].buyNum
            detailView.cartAttachArr = cartData.dishesList[idx].attachList
            detailView.cartSelectItemArr = cartData.dishesList[idx].itemList
            detailView.cartEditIdx = idx
            detailView.isEdit = true
            detailView.appearAction()
        }
        
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
        tableView.register(DishCell.self, forCellReuseIdentifier: "DishCell")
        tableView.register(DishesKeyWordsCell.self, forCellReuseIdentifier: "DishesKeyWordsCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    //筛选提示框
    private lazy var sxView: ScreenView = {
        let view = ScreenView()
        
        view.clickConfirmBlock = { [unowned self] info in
            isShowSX = false
            screenBut.jiantouImg = "xiala"
            
            let dic = info as! [String: Any]
            screenKey = dic["key"] as! String
            screenDataArr = dic["arr"] as! [DishModel]
            
            if screenKey == "" {
                if allDataArr.count == 0 {
                    table.addSubview(noDataView)
                } else {
                    noDataView.removeFromSuperview()
                }
            } else {
                if screenDataArr.count == 0 {
                    table.addSubview(noDataView)
                } else {
                    noDataView.removeFromSuperview()
                }
            }
    
            table.reloadData()
        }
        
        return view
    }()

    
    //菜品详情
    private lazy var detailView: DishDetailView = {
        let view = DishDetailView()
        view.attachDataArr = attachDataArr
        
        //添加购物车菜品
        view.addBlock = { [unowned self] (info) in
            
            let dic = info as! [String: Any]
            let num = dic["num"] as! Int
            let selectOption = dic["opt"] as! [OptionModel]
            let selectCombo = dic ["com"] as! [ComboDishesModel]
            let selectAtt = dic["att"] as! [AttachModel]
            let dish = dic["dish"] as! DishModel
         
            dishAddCart(dish: dish, selectOption: selectOption, selectCombo: selectCombo, attach: selectAtt, buyNum: num)
            doCalOrder_Net()
        }
        
        
        //编辑购物车菜品
        view.editBlock = { [unowned self] (info) in
            let dic = info as! [String: Any]
            let num = dic["num"] as! Int
            let selectOption = dic["opt"] as! [OptionModel]
            let selectCombo = dic ["com"] as! [ComboDishesModel]
            let selectAtt = dic["att"] as! [AttachModel]
            let dish = dic["dish"] as! DishModel
            let idx = dic["idx"] as! Int
            
            //更新购物车数据
            cartData.dishesList[idx].updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: selectAtt)
            cartData.dishesList[idx].buyNum = num
            cartAlert.updateData()
            doCalOrder_Net()
        }
        
        return view
    }()
    
    
    override func setNavi() {
        naviBar.leftImg = LOIMG("nav_back_w")
        naviBar.rightBut.isHidden = true
        naviBar.headerTitle = titStr
    }
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("#F7F6FA")
        
        naviBar.addSubview(screenBut)
        screenBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-2)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 65 - 10)
        }

        view.addSubview(cartAlert)
        
        view.addSubview(b_cartView)
        b_cartView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(bottomBarH + 65)
        }
        
        
        
        screenBut.addTarget(self, action: #selector(clickScreeAction), for: .touchUpInside)
    }
    
    override func clickLeftButAction() {
        screenBut.jiantouImg = "xiala"
        sxView.disAppearAction()
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickScreeAction() {
        
        if isShowSX {
            isShowSX = false
            screenBut.jiantouImg = "xiala"
            sxView.disAppearAction()
        } else {
            isShowSX = true
            screenBut.jiantouImg = "shouqi"
            sxView.appearAction()
        }
        
    }
    
    deinit {
        print("\(self.classForCoder)销毁了")
    }

    
    
}


extension DishListController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if screenKey == "" {
                return 0
            }
            return 1
        }
        
        if section == 1 {
            if screenKey == "" {
                return allDataArr.count
            }
            return screenDataArr.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if screenKey == "" {
                return allDataArr[indexPath.row].dish_H
            }
            return screenDataArr[indexPath.row].dish_H
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishesKeyWordsCell") as! DishesKeyWordsCell
            cell.setCellData(key: screenKey)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell") as! DishCell
        
        if screenKey == "" {
            cell.setCellData(model: allDataArr[indexPath.row])
        } else {
            cell.setCellData(model: screenDataArr[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dishMmodel = DishModel()
        if screenKey == "" {
            dishMmodel = allDataArr[indexPath.row]
        } else {
            dishMmodel = screenDataArr[indexPath.row]
        }
        
        //如果是单品且无规格
        if dishMmodel.dishesType == "1" && dishMmodel.haveSpec == "2" {
            //直接加入购物车
            dishAddCart(dish: dishMmodel, selectOption: [], selectCombo: [], attach: [], buyNum: 1)
            doCalOrder_Net()
            
        } else {
            //进入菜品详情
            detailView.deskID = deskID
            detailView.dishID = dishMmodel.dishesId
            detailView.appearAction()
        }
    }
}

extension DishListController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesList(deskID: deskID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [DishModel] = []
            for jsonData in json["data"].arrayValue {
                let model = DishModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            allDataArr = tArr
            
            if allDataArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            //筛选框赋值
            sxView.allDishes = allDataArr
            table.reloadData()
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //MARK: - 下单计算价格 每次菜品添加购物车时需要调用，计算出菜品的价格
    private func doCalOrder_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCalOrder(deskID: deskID, dishesArr: cartData.dishesList).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            //更新价格 更新底部购物车
            b_cartView.updateData(price: D_2_STR(json["data"]["orderPrice"].doubleValue), data: cartData)
//            cartAlert.updateData(f_d_price: D_2_STR(json["data"]["dishesPrice"].doubleValue), ser_price: D_2_STR(json["data"]["servicePrice"].doubleValue))
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //MARK: - 下单
    private func createOrder_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCreateOrder(deskID: deskID, dishesArr: cartData.dishesList).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            //下单成功
            
            let rootVC: UIViewController = navigationController?.viewControllers.first ?? DeskListController()
            let orderListVC = DeskOrderListController()
            orderListVC.deskID = deskID
            orderListVC.titStr = titStr
            orderListVC.deskStatus = .Process
            orderListVC.attachDataArr = attachDataArr
            
            navigationController?.setViewControllers([rootVC, orderListVC], animated: true)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)

    }
}


extension DishListController {
    
    ///菜品添加购物车
    private func dishAddCart(dish: DishModel, selectOption: [OptionModel], selectCombo: [ComboDishesModel], attach: [AttachModel], buyNum: Int)  {
        
        /**
         判断添加的菜品在购物车中是合并数量还是 新的菜品
         合并的条件：
         菜品不为空 ,  最后一个菜品不是叫起状态， 当菜品的ID、菜品选的规格相同、菜品选择的套餐相同、菜品选择的附加、菜品的printSort也相同时合并， 数量+1
        */
        
        /**
         * 根据分隔线情况，给菜品设置分组参数
         * 如果“叫起”为开始，那么printSort从1（可能是100）开始计数，否则从2（可能是99）开始
         * 如果“叫起”为结束，那么printSort从99结束，否则正常计数结束
         * 如果只有一组printSort，开始时有“叫起”，结束时有“叫起”时：printSort = 100
         * 如果只有一组printSort，开始时没有“叫起”，结束时有“叫起”时 printSort = 99
         */
        
        if cartData.dishesList.count == 0 {
            //没有菜 创建购物车菜品直接添加
            let cartDishModel = CartDishModel()
            cartDishModel.updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: attach)
            cartDishModel.buyNum = buyNum
            
            //处理printSort
            if cartData.showJiaoqi {
                cartDishModel.printSort = 1
            } else {
                cartDishModel.printSort = 2
            }
            cartData.dishesList.append(cartDishModel)
            
        } else {
            //有菜 需要进行判断
            
            //如果最后一个菜品是叫起状态的 直接创建菜品添加
            if cartData.dishesList.last!.showJiaoqi {
                let cartDishModel = CartDishModel()
                cartDishModel.updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: attach)
                cartDishModel.buyNum = buyNum
                //printSort是最后一个菜的printSort+1
                cartDishModel.printSort = cartData.dishesList.last!.printSort + 1
                cartData.dishesList.append(cartDishModel)
            } else {
                //查看是否可以进行合并
                ///选择的规格ID拼接的字符串
                var specStr = ""
                for spec in selectOption {
                    specStr += spec.optionId + ","
                }
                ///选择的套餐ID拼接的字符串
                var comStr = ""
                for com in selectCombo {
                    comStr += com.dishesComboRelId + ","
                }
                ///选择的附加ID拼接的字符串
                var attStr = ""
                for att in attach {
                    attStr += att.attachId + ","
                }
                
                ///是否存在一样的菜品
                var isHave: Bool = false

                ///当前的 printSort 的值
                let curPrintSort = cartData.dishesList.last!.printSort
                

                for cartDish in cartData.dishesList {
                
                    ///菜品不为空 ,  最后一个菜品不是叫起状态， 当菜品的ID、菜品选的规格相同、菜品选择的套餐相同、菜品选择的附加、菜品的printSort也相同时合并， 数量+1
                        
                    var cartItemIDStr = ""
                    for model in cartDish.itemList {
                        cartItemIDStr += model.itemID + ","
                    }
    
                    
                    var cartAttIDStr = ""
                    for model in cartDish.attachList {
                        cartAttIDStr += model.itemID + ","
                    }
                    
                    if dish.dishesType == "1" {
                        //单品菜
                        ///规格用字符串进行比对
                        if cartDish.dishesId == dish.dishesId && cartDish.printSort == curPrintSort && cartItemIDStr == specStr && cartAttIDStr == attStr {
                            isHave = true
                            //购物车中数量添加
                            cartDish.buyNum += buyNum
                            break
                        }
                    } else {
                        //套餐
                        ///套餐用字符串进行比对
                        if cartDish.dishesId == dish.dishesId && cartDish.printSort == curPrintSort && cartItemIDStr == comStr && cartAttIDStr == attStr {
                            isHave = true
                            //购物车中数量添加
                            cartDish.buyNum += buyNum
                            break
                        }
                    }
                }
                
                if !isHave {
                    //不存在的菜 创建购物车菜品直接添加 printSort为最后一个菜品的值
                    let cartDishModel = CartDishModel()
                    cartDishModel.updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: attach)
                    cartDishModel.buyNum = buyNum
                    //printSort是最后一个菜的printSort
                    cartDishModel.printSort = cartData.dishesList.last!.printSort
                    cartData.dishesList.append(cartDishModel)
                }
            }
        }
        
        cartAlert.updateData()
    }
    

    
    
}


