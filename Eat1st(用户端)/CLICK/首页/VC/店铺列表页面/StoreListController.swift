//
//  StoreListController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/28.
//

import UIKit
import RxSwift
import MJRefresh

class StoreListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let bag = DisposeBag()
    
    private var sortStrArr: [String] = ["Distance", "Review", "Best Selling"]
        
    private var sortBeSelected: Bool = false
    private var filterBeSelected: Bool = false
    
    private var sortSeletIdx: Int = 1000
    private var filterSelectIdx: Int = 1000

    
    ///搜索词
    private var searchStr: String = ""
    ///tag
    private var tag: String = ""
    ///type 1:绑定、2:附近、3:热门
    var type: String = "1"
    ///排序类型 1距离，2评分，3销量
    var sortType: String = "1"
    ///分页
    private var page: Int = 1
    
    private var tagsArr: [ScreenTagsModel] = []
    
    ///数据ModelArr
    private var dataArr: [StoreInfoModel] = []
    
    
    ///搜索栏
    private lazy var searchView: CommonSearchView = {
        let view = CommonSearchView()
        
        view.backBlock = { [unowned self] (_) in
            //如果排序筛选栏出现时，先做隐藏
            if self.sortBeSelected {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: "px")
                return
            }
            if self.filterBeSelected {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: "sx")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        view.searchBlock = { [unowned self] (str) in
            //如果排序筛选栏出现时，先做隐藏
            if self.sortBeSelected {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: "px")
                return
            }
            if self.filterBeSelected {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: "sx")
                return
            }
        
            //搜索
            let nextVC = StoreSearchController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("F7F7F7")
        return view
    }()
    
    
    ///筛选排序栏
    private lazy var toolView: StoreSXToolView = {
        
        /**
         1、出现排序  px_o
         2、出现筛选  sx_o
         3、排序消失  px_d
         4、筛选消失  sx_d
         5、排序消失 出现筛选  px_d&sx_o
         6、筛选消失 出现排序  px_o&sx_d
         */

        let view = StoreSXToolView()
        
        view.clickBlock = { [unowned self] (type) in
            
            if type == "px_o" {
                self.sortView.appearAction()
                self.sortBeSelected = true
                self.filterBeSelected = false
            }
            if type == "sx_o" {
                self.filterView.appearAction()
                self.sortBeSelected = false
                self.filterBeSelected = true
            }
            if type == "px_d" {
                self.sortView.disAppearAction()
                self.sortBeSelected = false
                self.filterBeSelected = false
            }
            if type == "sx_d" {
                self.filterView.disAppearAction()
                self.sortBeSelected = false
                self.filterBeSelected = false
            }
            if type == "px_d&sx_o" {
                self.sortView.disAppearAction(0)
                self.filterView.appearAction(0)
                self.sortBeSelected = false
                self.filterBeSelected = true
            }
            if type == "px_o&sx_d" {
                self.filterView.disAppearAction(0)
                self.sortView.appearAction(0)
                self.sortBeSelected = true
                self.filterBeSelected = false
            }
        }
        return view
    }()
    
    
    ///排序条件框
    private lazy var sortView: SortOptionView = {
        let view = SortOptionView()
        view.sortStrArr = self.sortStrArr
        view.selectBlock = { [unowned self] (idx) in
            if idx as! Int != self.sortSeletIdx {
                self.sortSeletIdx = idx as! Int
                if idx as! Int != 1000 {
                    print(self.sortStrArr[idx as! Int])
                    self.type = String((idx as! Int) + 1)
                    self.loadData_Net()                    
                } else {
                    print("px cancel")
                }
            }
        }
        return view
    }()
    
    ///筛选条件栏
    private lazy var filterView: FilterOptionView = {
        let view = FilterOptionView()
        
        view.selectBlock = { [unowned self] (idx) in
            if idx as! Int != self.filterSelectIdx {
                self.filterSelectIdx = idx as! Int
                if idx as! Int != 1000 {
                    print(self.tagsArr[idx as! Int].name)
                    self.tag = self.tagsArr[idx as! Int].id
                } else {
                    print("sx cancel")
                    self.tag = ""
                }
                self.loadData_Net()
            }
        }
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
        tableView.register(StoreTableCell.self, forCellReuseIdentifier: "StoreTableCell")
        return tableView
    }()
    

    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()
    

    override func setViews() {
        
        self.naviBar.isHidden = true
        setUpUI()
        
        loadData_Net()
        loadTags_Net()

    }
    
    override func setNavi() {
    }
    
    
    private func setUpUI() {
        
        view.backgroundColor = HCOLOR("F7F7F7")
        
        self.view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(searchView.snp.bottom)
            $0.height.equalTo(10)
        }
        
        view.addSubview(toolView)
        toolView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom)
            $0.height.equalTo(45)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(toolView.snp.bottom)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }
        
    }

}


extension StoreListController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SET_H(225, 355) + 105 + 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableCell") as! StoreTableCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = StoreMenuOrderController()
        nextVC.storeID = dataArr[indexPath.row].storeID
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    //MARK: - 网络请求
    ///获取Tags
    private func loadTags_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getFiltrateTags().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)

            var tempArr: [ScreenTagsModel] = []
            for jsonData in json["data"].arrayValue {
                let model = ScreenTagsModel()
                model.updateModel(json: jsonData)
                tempArr.append(model)
            }
            self.tagsArr = tempArr
            self.filterView.filterStrArr = self.tagsArr

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: bag)
    }
    
    ///获取店铺列表
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
                
        if self.type == "1" {
            HTTPTOOl.storeList_Binding(tag: tag, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, page: 1).subscribe(onNext: { (json) in
                
                HUD_MB.dissmiss(onView: self.view)
                
                self.page = 2
                
                var tempArr: [StoreInfoModel] = []
                for jsondata in json["data"].arrayValue {
                    let model = StoreInfoModel()
                    model.updateModel(json: jsondata)
                    tempArr.append(model)
                }
                self.dataArr = tempArr
                
                if self.dataArr.count == 0 {
                    self.table.addSubview(self.noDataView)
                } else {
                    self.noDataView.removeFromSuperview()
                }
                
                self.table.reloadData()
                
                self.table.mj_header?.endRefreshing()
                self.table.mj_footer?.resetNoMoreData()
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: bag)
        }
        
        if type == "2" {
            //附近
            HTTPTOOl.storeList_Nearby(tag: tag, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, allStore: "1", page: 1).subscribe(onNext: { (json) in
                
                HUD_MB.dissmiss(onView: self.view)
                
                self.page = 2
                
                var tempArr: [StoreInfoModel] = []
                for jsondata in json["data"].arrayValue {
                    let model = StoreInfoModel()
                    model.updateModel(json: jsondata)
                    tempArr.append(model)
                }
                self.dataArr = tempArr
                
                if self.dataArr.count == 0 {
                    self.table.addSubview(self.noDataView)
                } else {
                    self.noDataView.removeFromSuperview()
                }
                
                self.table.reloadData()
                
                self.table.mj_header?.endRefreshing()
                self.table.mj_footer?.resetNoMoreData()
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: bag)
        }
        
        if type == "3" {
            //热门
            HTTPTOOl.storeList_Hot(tag: tag, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, page: 1).subscribe(onNext: { (json) in
                
                HUD_MB.dissmiss(onView: self.view)
                
                self.page = 2
                
                var tempArr: [StoreInfoModel] = []
                for jsondata in json["data"].arrayValue {
                    let model = StoreInfoModel()
                    model.updateModel(json: jsondata)
                    tempArr.append(model)
                }
                self.dataArr = tempArr
                
                if self.dataArr.count == 0 {
                    self.table.addSubview(self.noDataView)
                } else {
                    self.noDataView.removeFromSuperview()
                }
                
                self.table.reloadData()
                
                self.table.mj_header?.endRefreshing()
                self.table.mj_footer?.resetNoMoreData()
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_header?.endRefreshing()
            }).disposed(by: bag)
        }
        
    }
    
    private func loadDataMore_Net() {
        
        if type == "1" {
            
            HTTPTOOl.storeList_Binding(tag: tag, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, page: self.page).subscribe(onNext: { (json) in
                if json["data"].arrayValue.count == 0 {
                    self.table.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.page += 1
                    for jsonData in json["data"].arrayValue {
                        let model = StoreInfoModel()
                        model.updateModel(json: jsonData)
                        self.dataArr.append(model)
                    }
                    self.table.reloadData()
                    self.table.mj_footer?.endRefreshing()
                }

            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_footer?.endRefreshing()
            }).disposed(by: bag)

            
        }
        
        if type == "2" {
            
            HTTPTOOl.storeList_Nearby(tag: tag, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, allStore: "1", page: self.page).subscribe(onNext: { (json) in
                if json["data"].arrayValue.count == 0 {
                    self.table.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.page += 1
                    for jsonData in json["data"].arrayValue {
                        let model = StoreInfoModel()
                        model.updateModel(json: jsonData)
                        self.dataArr.append(model)
                    }
                    self.table.reloadData()
                    self.table.mj_footer?.endRefreshing()
                }

            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_footer?.endRefreshing()
            }).disposed(by: bag)

        }
        
        if type == "3" {
            HTTPTOOl.storeList_Hot(tag: tag, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, page: self.page).subscribe(onNext: { (json) in
                if json["data"].arrayValue.count == 0 {
                    self.table.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.page += 1
                    for jsonData in json["data"].arrayValue {
                        let model = StoreInfoModel()
                        model.updateModel(json: jsonData)
                        self.dataArr.append(model)
                    }
                    self.table.reloadData()
                    self.table.mj_footer?.endRefreshing()
                }

            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                self.table.mj_footer?.endRefreshing()
            }).disposed(by: bag)
        }
    }

}
