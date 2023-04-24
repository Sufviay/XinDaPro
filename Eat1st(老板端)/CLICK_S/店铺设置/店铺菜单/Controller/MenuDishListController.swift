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
                    self.showSystemChooseAlert("Alert", "Delete it?", "YES", "NO") {
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
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(searchView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)
        
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickRightAction() {
        self.moreView.appearAction()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 1
        }
        
        return dishArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 90
        }
        
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
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! AddItemCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishCell") as! MenuDishCell
        cell.setCellData(model: dishArr[indexPath.row], type: self.type)
        
        cell.clickMoreBlock = { [unowned self] (par) in
            if par == "de" {
                //删除
                DispatchQueue.main.async {
                    self.showSystemChooseAlert("Alert", "Delete it?", "YES", "NO") {
                        self.deleteDish_Net(idx: indexPath.row)
                    }
                }                
            }
            if par == "ed" {
                //编辑
                if type == "dis" {
                    let nextVC = MenuDishEditeController()
                    nextVC.isAdd = false
                    nextVC.dishID = dishArr[indexPath.row].id
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                if type == "add" {
                    let nextVC = MenuAdditionalAddController()
                    nextVC.isAdd = false
                    nextVC.addID = dishArr[indexPath.row].id
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                if type == "fre" {
                    let nextVC = MenuGiftAddController()
                    nextVC.isAdd = false
                    nextVC.giftID = dishArr[indexPath.row].id
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            
            if par == "kc" {
                //库存
                let model = self.dishArr[indexPath.row]
                self.kuCunView.setAlertData(name1: model.name1, name2: model.name2, type: model.limitBuy, num: model.limitNum, dishID: model.id)
                self.kuCunView.appearAction()
            }
            
            if par == "yh" {
                //优惠
                let model = self.dishArr[indexPath.row]
                self.discountView.setAlertData(discountType: model.discountType, discountPrice: model.discountPrice, dishID: model.id)
                self.discountView.appearAction()
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
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
            
            
        } else {
            //新增菜品
            
            if type == "dis" {
                let nextVC = MenuDishEditeController()
                nextVC.isAdd = true
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
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        if type == "dis" {
            HTTPTOOl.getClassifyDishesList(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var tArr: [DishModel] = []
                for jsonData in json["data"].arrayValue {
                    let model = DishModel()
                    model.updateModel(json: jsonData)
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



