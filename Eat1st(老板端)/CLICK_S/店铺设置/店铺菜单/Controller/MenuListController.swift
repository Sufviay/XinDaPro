//
//  MenuListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/18.
//

import UIKit
import RxSwift
import MJRefresh

class MenuListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    private let bag = DisposeBag()
    
    private var dataArr: [F_DishModel] = []
    
    private var comboDishes: [DishModel] = []
    
    private var type: String = "dis"
    
    private lazy var tagView: MenuTagView = {
        let view = MenuTagView()
        view.clickBlock = { [unowned self] (type) in
            self.type = type
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
    
    private lazy var addClassifyView: AddClassifyView = {
        let view = AddClassifyView()
        
        view.saveSuccessBlock = { [unowned self] (_) in
            self.loadData_Net()
        }
        
        return view
    }()

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Edit your menu"
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
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(tagView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
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
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 90
        } else {
            
            if self.type == "com" {
                //套餐
                let model = comboDishes[indexPath.row]
                let h1 = model.name1.getTextHeigh(BFONT(13), S_W - 120)
                let h2 = model.name2.getTextHeigh(SFONT(13), S_W - 120)
                
                if model.tags.count == 0 {
                    return 15 + h1 + h2 + 10 + 40
                } else {
                    return 15 + h1 + h2 + 10 + 55
                }
                
            } else {
                let h1 = dataArr[indexPath.row].name1.getTextHeigh(BFONT(13), S_W - 90)
                let h2 = dataArr[indexPath.row].name2.getTextHeigh(SFONT(13), S_W - 90)
                return h1 + h2 + 50
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if type == "com" {
                return comboDishes.count
            } else {
                return dataArr.count
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! AddItemCell
            return cell
        }
        if type == "com" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishCell") as! MenuDishCell
            cell.setCellData(model: comboDishes[indexPath.row], type: "dis")
            
            cell.clickMoreBlock = { [unowned self] (par) in
                if par == "de" {
                    //删除
                    DispatchQueue.main.async {
                        self.showSystemChooseAlert("Alert", "Delete it?", "YES", "NO") { [unowned self] in
                            self.deleteDishes_Net(idx: indexPath.row)
                        }
                    }
                }
                if par == "yh" {
                    //优惠
                    let model = self.comboDishes[indexPath.row]
                    self.discountView.setAlertData(discountType: model.discountType, discountPrice: model.discountPrice, dishID: model.id, discountStartDate: model.discountStartDate, discountEndDate: model.discountEndDate)
                    self.discountView.appearAction()
                }
                
                if par == "kc" {
                    //库存
                    let model = self.comboDishes[indexPath.row]
                    self.kuCunView.setAlertData(name1: model.name1, name2: model.name2, type: model.limitBuy, num: model.limitNum, dishID: model.id)
                    self.kuCunView.appearAction()
                }

                if par == "ed" {
                    
                    let nextVC = MenuDishComboDetailController()
                    nextVC.dishID = comboDishes[indexPath.row].id
                    self.navigationController?.pushViewController(nextVC, animated: true)

//
//                    let nextVC = MenuDishEditeController()
//                    nextVC.isAdd = false
//                    nextVC.dishID = comboDishes[indexPath.row].id
//                    self.navigationController?.pushViewController(nextVC, animated: true)
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
        if indexPath.section == 1 {
            
            if type == "com" {
        
                //添加套餐菜品
                let nextVC = MenuDishComboEditeController()
                nextVC.isAdd = true
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
            } else {
                
                //添加分类
                self.addClassifyView.type = self.type
                self.addClassifyView.appearAction()

            }
            
        } else {
            
            
            if type == "com" {
                //套餐菜品详情
                let nextVC = MenuDishComboDetailController()
                nextVC.dishID = comboDishes[indexPath.row].id
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
            } else {
                //分类下菜品列表
                let nextVC = MenuDishListController()
                nextVC.titStr = dataArr[indexPath.row].name1
                nextVC.classifyID = dataArr[indexPath.row].id
                nextVC.type = self.type
                self.navigationController?.pushViewController(nextVC, animated: true)

            }
        }
    }
    
    
}


extension MenuListController {
    
    //MARK: - 网络请求
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        if type == "dis" {
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
        
        if type == "add" {
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
        
        if type == "fre" {
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
        
        
        if type == "com" {
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
