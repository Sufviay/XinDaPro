//
//  MenuListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/18.
//

import UIKit
import RxSwift
import MJRefresh



enum PageType {
    ///菜品搜索編輯
    case seach_edit
    ///菜品搜索上下架
    case search_onoff
    ///單品
    case dish
    ///套餐
    case combo
    ///附加
    case additional
    ///禮品贈送
    case gift
    
}


class MenuListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    private let bag = DisposeBag()
    
    private var dataArr: [F_DishModel] = []
    
    private var comboDishes: [DishModel] = []
    
    private var dataType: PageType = .dish
    
    private lazy var tagView: MenuTagView = {
        let view = MenuTagView()
        view.clickBlock = { [unowned self] (type) in
            dataType = type as! PageType
            if dataType == .combo {
                addBut.setTitle("Add Dishes".local, for: .normal)
            } else {
                addBut.setTitle("Add Category".local, for: .normal)
            }
                
            self.loadData_Net()
        }
        return view
    }()
    
    //折扣
    private lazy var discountView: EditDiscountView = {
        let view = EditDiscountView()
        return view
    }()
    
    //库存
    private lazy var kuCunView: EditeKuCunView = {
        let view = EditeKuCunView()
        return view
    }()
    
    //价格
    private lazy var priceView: EditPriceView = {
        let view = EditPriceView()
        return view
    }()
    
    //设置状态
    private lazy var statusView: EditStatusView = {
        let view = EditStatusView()
        return view
    }()

    //设置VIP价格
    private lazy var vipView: EditVIPView = {
        let view = EditVIPView()
        return view
    }()


    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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

        tableView.register(MenuListClassifyCell.self, forCellReuseIdentifier: "MenuListClassifyCell")
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        tableView.register(MenuDishCell.self, forCellReuseIdentifier: "MenuDishCell")
        return tableView
        
    }()
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add Category".local, HCOLOR("#465DFD"), TIT_2, BACKCOLOR_3)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        return but
    }()
    
    
    private lazy var addClassifyView: AddClassifyView = {
        let view = AddClassifyView()
        
        view.saveSuccessBlock = { [unowned self] (_) in
            self.loadData_Net()
        }
        
        return view
    }()

    
    private let searchBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("search_nav"), for: .normal)
        return but
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Edit your menu".local
        loadData_Net()
    }

    
    override func setViews() {
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        setUpUI()
        addNotificationCenter()
    }
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        
        view.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(55)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.height.equalTo(50)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(tagView.snp.bottom)
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
        }
        
        view.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.centerY.equalTo(leftBut)
            $0.right.equalToSuperview().offset(-10)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            self.loadData_Net(true)
        }
        
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
    }
    
    
    @objc private func clickSearchAction() {
        //搜索菜品
        let nextVC = MenuDishListController()
        nextVC.titStr = "Search".local
        nextVC.type = .seach_edit
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    
    @objc private func clickAddAction() {
        if dataType == .combo {
            //添加套餐菜品
            let nextVC = MenuDishComboEditeController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        } else {
            //添加分类
            addClassifyView.type = dataType
            self.addClassifyView.appearAction()
        }
    }
    
    
    //MARK: - 通知中心
    private func addNotificationCenter() {
        //监测消息的变化
        NotificationCenter.default.addObserver(self, selector: #selector(centerAction), name: NSNotification.Name(rawValue: "dishList"), object: nil)
        
    }
        
    deinit {
        print("\(self.classForCoder)销毁")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("dishList"), object: nil)
    }
    
    @objc private func centerAction() {
        self.loadData_Net()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if dataType == .combo {
            //套餐
            let model = comboDishes[indexPath.row]
            let h1 = model.name1.getTextHeigh(TIT_3, S_W - 220)
            let h2 = model.name2.getTextHeigh(TIT_1, S_W - 220)
            
            if model.tags.count == 0 {
                return 15 + h1 + h2 + 10 + 40
            } else {
                return 15 + h1 + h2 + 10 + 55
            }
            
        } else {
            let h1 = dataArr[indexPath.row].name1.getTextHeigh(TIT_3, S_W - 90)
            let h2 = dataArr[indexPath.row].name2.getTextHeigh(TXT_1, S_W - 90)
            return h1 + h2 + 50
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if dataType == .combo {
            return comboDishes.count
        } else {
            return dataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataType == .combo {
            
            let model = comboDishes[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishCell") as! MenuDishCell
            cell.setCellData(model: model, type: dataType)
            
            cell.clickMoreBlock = { [unowned self] (par) in
                if par == "delete" {
                    //删除
                    showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) {
                        
                        if model.statusID == "1" {
                            //上架
                            self.showSystemChooseAlert("Alert".local, "The dish is in use. Do you want to delete it?".local, "Delete".local, "Cancel".local) {
                                self.deleteDishes_Net(idx: indexPath.row)
                            }
                        } else {
                            self.deleteDishes_Net(idx: indexPath.row)
                        }
                    }
                }
                
                if par == "discount" {
                    //优惠
                    discountView.setAlertData(discountType: model.discountType, discountPrice: model.discountPrice, dishID: model.id, discountStartDate: model.discountStartDate, discountEndDate: model.discountEndDate)
                    discountView.appearAction()
                }
                
                if par == "stock" {
                    //库存
                    kuCunView.setAlertData(name1: model.name1, name2: model.name2, type: model.limitBuy, num: model.limitNum, dishID: model.id)
                    kuCunView.appearAction()
                }

                if par == "detail" {
                    //详情
                    let nextVC = MenuDishComboDetailController()
                    nextVC.dishID = model.id
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                if par == "price" {
                    //修改价格
                    priceView.setAlertData(id: model.id, sellType: model.sellType, buffetType: model.buffetType, dePrice: model.deliPrice, dinePrice: model.dinePrice)
                    priceView.appearAction()
                }
                
                if par == "free" {
                    //买一赠一
                    statusView.setAlertData(type: .giveOne, status: model.isGiveOne, id: model.id)
                    statusView.appearAction()
                }
                
                if par == "special" {
                    //设置点心套餐
                    let stauts = model.baleType == "2" ? true : false
                    statusView.setAlertData(type: .baleType, status: stauts, id: model.id)
                    statusView.appearAction()
                }
                
                if par == "VIP" {
                    //设置VIP
                    vipView.setAlertData(id: model.id, status: model.vipType, price: model.vipPrice, typeStr: model.vipDeliveryStr)
                    vipView.appearAction()
                }
                
                if par == "VAT" {
                    //设置VAT
                    loadDishDetail_Net(id: model.id)
                }
                
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuListClassifyCell") as! MenuListClassifyCell
            cell.setCellData(model: dataArr[indexPath.row])
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if dataType == .combo {
            //套餐菜品详情
            let nextVC = MenuDishComboDetailController()
            nextVC.dishID = comboDishes[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        } else {
            //分类下菜品列表
            let nextVC = MenuDishListController()
            nextVC.titStr = dataArr[indexPath.row].name1
            nextVC.classifyID = dataArr[indexPath.row].id
            nextVC.type = dataType
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    private func loadDishDetail_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesDetail(id: id).subscribe(onNext: { [self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            var dishModel = DishDetailModel()
            dishModel = DishDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            statusView.dishModel = dishModel
            let status = dishModel.vatType == "2" ? true : false
            statusView.setAlertData(type: .VAT, status: status, id: String(dishModel.dishesId))
            statusView.appearAction()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)

    }
    
}


extension MenuListController {
    
    //MARK: - 网络请求
    
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        

        if dataType == .dish {
            HTTPTOOl.getMenuDishClassifyList().subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [F_DishModel] = []
                for jsondata in json["data"].arrayValue {
                    let model = F_DishModel()
                    model.updateModel(json: jsondata)
                    tArr.append(model)
                }
                self.dataArr = tArr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        if dataType == .additional {
            HTTPTOOl.getMenuAttachClassifyList().subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [F_DishModel] = []
                for jsondata in json["data"].arrayValue {
                    let model = F_DishModel()
                    model.updateModel(json: jsondata)
                    tArr.append(model)
                }
                self.dataArr = tArr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        if dataType == .gift {
            HTTPTOOl.getMenuGiftClassifyList().subscribe(onNext: {[unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [F_DishModel] = []
                for jsondata in json["data"].arrayValue {
                    let model = F_DishModel()
                    model.updateModel(json: jsondata)
                    tArr.append(model)
                }
                self.dataArr = tArr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        
        if dataType == .combo {
            //如果是套餐的话就展示套菜的菜品
            HTTPTOOl.getDishList().subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var d_arr: [DishModel] = []
                for d_jsonData in json["data"]["dishesList"].arrayValue {
                    let model = DishModel()
                    model.updateModel(json: d_jsonData)
                    if model.dishesType == "2" {
                        d_arr.append(model)
                    }
                }
                self.comboDishes = d_arr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
            }, onError: {[unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
    }
    
    
    //删除菜品
    private func deleteDishes_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteDish(id: comboDishes[idx].id).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.comboDishes.remove(at: idx)
            self.table.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}
