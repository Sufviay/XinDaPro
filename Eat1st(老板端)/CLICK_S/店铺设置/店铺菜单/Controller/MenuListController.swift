//
//  MenuListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/18.
//

import UIKit
import RxSwift
import MJRefresh

class MenuListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let bag = DisposeBag()
    
    private var dataArr: [F_DishModel] = []
    
    private var type: String = "dis"
    
    private lazy var tagView: MenuTagView = {
        let view = MenuTagView()
        view.clickBlock = { [unowned self] (type) in
            self.type = type
            self.loadData_Net()
        }
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 90
        } else {
            let h1 = dataArr[indexPath.row].name1.getTextHeigh(BFONT(13), S_W - 90)
            let h2 = dataArr[indexPath.row].name2.getTextHeigh(SFONT(13), S_W - 90)
            return h1 + h2 + 50
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return dataArr.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! AddItemCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuListClassifyCell") as! MenuListClassifyCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.addClassifyView.type = self.type
            self.addClassifyView.appearAction()
        } else {
            
            let nextVC = MenuDishListController()
            nextVC.titStr = dataArr[indexPath.row].name1
            nextVC.classifyID = dataArr[indexPath.row].id
            nextVC.type = self.type
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
}


extension MenuListController {
    
    //MARK: - 网络请求
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        if type == "dis" {
            HTTPTOOl.getMenuDishClassifyList().subscribe(onNext: { (json) in
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
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        if type == "add" {
            HTTPTOOl.getMenuAttachClassifyList().subscribe(onNext: { (json) in
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
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
        
        if type == "fre" {
            HTTPTOOl.getMenuGiftClassifyList().subscribe(onNext: { (json) in
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
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: self.bag)
        }
    }
}
