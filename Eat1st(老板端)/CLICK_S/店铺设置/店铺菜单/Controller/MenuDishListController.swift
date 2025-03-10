//
//  MenuDishListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/21.
//

import UIKit
import RxSwift
import MJRefresh


class MenuDishListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    var titStr: String = ""
    var classifyID: String = ""
    //菜品类型  菜 赠品 附加
    var type: String = ""
    
    private var dishArr: [DishModel] = []

    
    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_more"), for: .normal)
        return but
    }()
    
    private lazy var searchView: MenuDishSearchView = {
        let view = MenuDishSearchView()
        view.doSearchBlock = { [unowned self] (s_str) in
            //进行搜索
            self.doSearch(searchStr: s_str)
        }
        return view
    }()
    
    private lazy var moreView: EditeClassifyView = {
        let view = EditeClassifyView()
        view.clickBlock = { [unowned self] (type) in
            if type == "delete" {
                
                DispatchQueue.main.async {
                    self.showSystemChooseAlert("Alert", "Delete or not?", "YES", "NO") {
                        self.deleteClassify_Net()
                    }
                }
            }
            
            if type == "edite" {
                self.editeView.isEdite = true
                self.editeView.classifyID = self.classifyID
                self.editeView.type = self.type
                self.editeView.appearAction()
            }
        }
        
        return view
    }()
    
    private lazy var editeView: AddClassifyView = {
        let view = AddClassifyView()

        view.editeSuccessBlock = { [unowned self] (str) in
            self.biaoTiLab.text = str
        }
        
        return view
    }()
    
    //库存
    private lazy var kuCunView: EditeKuCunView = {
        let view = EditeKuCunView()
        return view
    }()
    
    //折扣
    private lazy var discountView: EditDiscountView = {
        let view = EditDiscountView()
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

        tableView.register(MenuDishCell.self, forCellReuseIdentifier: "MenuDishCell")
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        return tableView
        
    }()
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add", HCOLOR("#465DFD"), BFONT(17), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        return but
    }()
    


    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = titStr
        loadData_Net()
    }
    
    
    override func setViews() {
        addNotificationCenter()
        setUpUI()
    }

    
    private func setUpUI() {
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
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
            $0.top.equalTo(searchView.snp.bottom)
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
        }
        
        
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            self.loadData_Net(true)
        }

        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
        
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickRightAction() {
        self.moreView.appearAction()
    }
    
    
    @objc private func clickAddAction() {
        //新增菜品
        
        if type == "dis" {
            let nextVC = MenuDishEditeController()
            nextVC.isAdd = true
            nextVC.dishType = "1"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if type == "add" {
            let nextVC = MenuAdditionalAddController()
            nextVC.isAdd = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if type == "fre" {
            let nextVC = MenuGiftAddController()
            nextVC.isAdd = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    
    
    //搜索
    func doSearch(searchStr: String) {
        if searchStr == "" {
            self.loadData_Net()
        } else {
            self.dishArr = self.dishArr.filter { $0.name_En.contains(searchStr) || $0.name_Hk.contains(searchStr) }
            self.table.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return dishArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dishArr[indexPath.row]
        
        let h1 = model.name1.getTextHeigh(BFONT(13), S_W - 120)
        let h2 = model.name2.getTextHeigh(SFONT(13), S_W - 120)
        
        if model.tags.count == 0 {
            return 15 + h1 + h2 + 10 + 40
        } else {
            return 15 + h1 + h2 + 10 + 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dishArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishCell") as! MenuDishCell
        cell.setCellData(model: model, type: self.type)
        
        cell.clickMoreBlock = { [unowned self] (par) in
            
            print(par)
            
            if par == "delete" {
                //删除
                showSystemChooseAlert("Alert", "Delete or not?", "YES", "NO") { [unowned self] in
                    
                    if model.statusID == "1" {
                        //上架
                        self.showSystemChooseAlert("Alert", "The dish is in use. Do you want to delete it？", "Delete", "Cancel") {
                            self.deleteDish_Net(idx: indexPath.row)
                        }
                    } else {
                        self.deleteDish_Net(idx: indexPath.row)
                    }
                }
            }
            if par == "detail" {
                //编辑
                if type == "dis" {
                    let nextVC = MenuDishDetailController()
                    nextVC.dishID = model.id
                    navigationController?.pushViewController(nextVC, animated: true)
                }
                if type == "add" {
                    let nextVC = MenuAdditionalDetailController()
                    nextVC.addID = model.id
                    navigationController?.pushViewController(nextVC, animated: true)
                }
                if type == "fre" {
                    let nextVC = MenuGiftDetailController()
                    nextVC.giftID = model.id
                    navigationController?.pushViewController(nextVC, animated: true)                }
            }
            
            if par == "stock" {
                //库存
                kuCunView.setAlertData(name1: model.name1, name2: model.name2, type: model.limitBuy, num: model.limitNum, dishID: model.id)
                kuCunView.appearAction()
            }
            
            if par == "discount" {
                //优惠
                discountView.setAlertData(discountType: model.discountType, discountPrice: model.discountPrice, dishID: model.id, discountStartDate: model.discountStartDate, discountEndDate: model.discountEndDate)
                discountView.appearAction()
            }
            
            if par == "price" {
                //价格
                let model = self.dishArr[indexPath.row]
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
            
            if par == "status" {
                //设置状态
                let status = model.statusID == "1" ? true : false
                statusView.setAlertData(type: .attachStatus, status: status, id: model.id)
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == "dis" {
            let nextVC = MenuDishDetailController()
            nextVC.dishID = dishArr[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if type == "add" {
            let nextVC = MenuAdditionalDetailController()
            nextVC.addID = dishArr[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if type == "fre" {
            let nextVC = MenuGiftDetailController()
            nextVC.giftID = dishArr[indexPath.row].id
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
    
    
    
    //MARK: - 通知中心
    private func addNotificationCenter() {
        //监测消息的变化
        NotificationCenter.default.addObserver(self, selector: #selector(centerAction), name: NSNotification.Name(rawValue: "dishList"), object: nil)
        
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("dishList"), object: nil)
    }
    
    @objc private func centerAction() {
        self.loadData_Net()
    }

    
}

extension MenuDishListController {
    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        if type == "dis" {
            HTTPTOOl.getClassifyDishesList(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [DishModel] = []
                for jsonData in json["data"].arrayValue {
                    let model = DishModel()
                    model.updateModel(json: jsonData)
                    if model.dishesType == "1" {
                        tArr.append(model)
                    }
                }
                self.dishArr = tArr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        if type == "add" {
            HTTPTOOl.getClassifyAttachList(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [DishModel] = []
                for jsonData in json["data"].arrayValue {
                    let model = DishModel()
                    model.updateAttachModel(json: jsonData)
                    tArr.append(model)
                }
                self.dishArr = tArr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        if type == "fre" {
            HTTPTOOl.getClassifyGiftList(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [DishModel] = []
                for jsonData in json["data"].arrayValue {
                    let model = DishModel()
                    model.updateGiftModel(json: jsonData)
                    tArr.append(model)
                }
                self.dishArr = tArr
                self.table.mj_header?.endRefreshing()
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
    }
    
    //删除分类
    private func deleteClassify_Net() {
        HUD_MB.loading("", onView: view)
        
        if type == "dis" {
            HTTPTOOl.deleteMenuDishClassify(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        if type == "add" {
            HTTPTOOl.deleteAttachDishClassify(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        if type == "fre" {
            HTTPTOOl.deleteGiftDishClassify(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        }
    }
    
    //删除菜品
    private func deleteDish_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        
        if type == "dis" {
            HTTPTOOl.deleteDish(id: dishArr[idx].id).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.dishArr.remove(at: idx)
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        if type == "add" {
            HTTPTOOl.deleteAdditional(id: dishArr[idx].id).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.dishArr.remove(at: idx)
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        if type == "fre" {
            HTTPTOOl.deleteGift(id: dishArr[idx].id).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.dishArr.remove(at: idx)
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
    }
    
}



