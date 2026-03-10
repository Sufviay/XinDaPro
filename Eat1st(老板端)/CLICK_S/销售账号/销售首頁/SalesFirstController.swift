//
//  SalesFirstController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/1/30.
//

import UIKit
import RxSwift


enum FirstPageShowType {
    case store
    case person
}

class SalesFirstController: XSBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var totalData = ToTalDataModel()
    private var storeDataArr: [StoreCommissionModel] = []
    private var personDataArr: [SubCommissionModel] = []
    private var page: Int = 1
    
    private var curShowType: FirstPageShowType = .store
    
    
    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("xs_search"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_20, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = UserDefaults.standard.userName ?? ""
        return lab
    }()
    
    
    private lazy var headview: SalesFirstHeaderView = {
        let view = SalesFirstHeaderView()
        view.clickBlock = { [unowned self] _ in
            let nextVC = SalesIncomeListController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        return view
    }()
    
    
    
    private let backView2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        view.setCommonShadow()
        return view
    }()
    
    
    private lazy var selectBut: SalesFirstSelectView = {
        let view = SalesFirstSelectView()
        view.clickBlock = { [unowned self] (par) in
            table.setContentOffset(.zero, animated: false)
            //table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            let type = par as! FirstPageShowType
            curShowType = type
            loadData_Net()
        }
        return view
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 15
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
        tableView.register(StoreIncomeCell.self, forCellReuseIdentifier: "StoreIncomeCell")
        tableView.register(SubPersonCell.self, forCellReuseIdentifier: "SubPersonCell")
        return tableView
    }()
    
    ///侧滑栏
    private lazy var sideBar: SalesSideToolView = {
        let view = SalesSideToolView()
        return view
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()
    

    override func setNavi() {
        leftBut.setImage(LOIMG("xs_side"), for: .normal)
    }
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
        biaoTiLab.isHidden = true
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        view.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-75)
            $0.centerY.equalTo(leftBut)
        }
        
        view.addSubview(headview)
        headview.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(145)
            $0.top.equalToSuperview().offset(statusBarH + 44 + 25)
        }
        


        view.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.left.right.equalTo(headview)
            $0.top.equalTo(headview.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 5)
        }
        
        backView2.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
        }
        
        
        backView2.addSubview(table)
        table.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(selectBut.snp.bottom)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }


        
        rightBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        leftBut.addTarget(self, action: #selector(clickLeftAction), for: .touchUpInside)
    }
    
    @objc private func clickLeftAction() {
        sideBar.appearAction()
    }
    
    
    @objc private func clickSearchAction() {
        let searchVC = SalesIncomSearchController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if curShowType == .store {
            return storeDataArr.count
        } else {
            return personDataArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if curShowType == .store {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreIncomeCell") as! StoreIncomeCell
            cell.setCellData(model: storeDataArr[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubPersonCell") as! SubPersonCell
            cell.setCellData(model: personDataArr[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if curShowType == .store {
            let model = storeDataArr[indexPath.row]
            let nextVC = SalesIncomeListController()
            nextVC.storeId = model.storeId
            nextVC.storeName = model.storeName
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    

    
    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
                
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        
        

        HTTPTOOl.salesGetHomePageData().subscribe(onNext: { [unowned self] (json) in
            
            totalData.updateModel(json: json["data"])
            headview.setData(data: totalData)
            
            if curShowType == .store {
                HTTPTOOl.salesGetCommissionList(storeId: "", storeName: "", page: 1).subscribe(onNext: { [unowned self] (json) in
                    HUD_MB.dissmiss(onView: view)
                    page = 2
                    var tArr: [StoreCommissionModel] = []
                    for jsonData in json["data"].arrayValue {
                        let model = StoreCommissionModel()
                        model.updateModel(json: jsonData)
                        tArr.append(model)
                    }
                    
                    storeDataArr = tArr
                
                    if storeDataArr.count == 0 {
                        if noDataView.superview == nil {
                            table.layoutIfNeeded()
                            table.addSubview(noDataView)
                        }
                    } else {
                        noDataView.removeFromSuperview()
                    }
                    
                    table.reloadData()
                    table.mj_header?.endRefreshing()
                    table.mj_footer?.resetNoMoreData()
                                
                }, onError: { [unowned self] (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                    table.mj_header?.endRefreshing()
                }).disposed(by: bag)

            } else {
                
                HTTPTOOl.salesGetSubCommissionList(page: 1).subscribe(onNext: { [unowned self] (json) in
                    HUD_MB.dissmiss(onView: view)
                    page = 2
                    var tArr: [SubCommissionModel] = []
                    for jsonData in json["data"].arrayValue {
                        let model = SubCommissionModel()
                        model.updateModel(json: jsonData)
                        tArr.append(model)
                    }
                    
                    personDataArr = tArr
                
                    if personDataArr.count == 0 {
                        if noDataView.superview == nil {
                            table.layoutIfNeeded()
                            table.addSubview(noDataView)
                        }
                    } else {
                        noDataView.removeFromSuperview()
                    }
                    
                    table.reloadData()
                    table.mj_header?.endRefreshing()
                    table.mj_footer?.resetNoMoreData()
                                
                }, onError: { [unowned self] (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                    table.mj_header?.endRefreshing()
                }).disposed(by: bag)
            }
                    
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        
        if curShowType == .store {
            HTTPTOOl.salesGetCommissionList(storeId: "", storeName: "", page: page).subscribe(onNext: { [unowned self] (json) in
                
                if json["data"].arrayValue.count == 0 {
                    table.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.page += 1
                    for jsonData in json["data"].arrayValue {
                        let model = StoreCommissionModel()
                        model.updateModel(json: jsonData)
                        storeDataArr.append(model)
                    }
                    table.reloadData()
                    table.mj_footer?.endRefreshing()
                }
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_footer?.endRefreshing()
            }).disposed(by: bag)
        } else {
            HTTPTOOl.salesGetSubCommissionList(page: page).subscribe(onNext: { [unowned self] (json) in
                
                if json["data"].arrayValue.count == 0 {
                    table.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.page += 1
                    for jsonData in json["data"].arrayValue {
                        let model = SubCommissionModel()
                        model.updateModel(json: jsonData)
                        personDataArr.append(model)
                    }
                    table.reloadData()
                    table.mj_footer?.endRefreshing()
                }
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_footer?.endRefreshing()
            }).disposed(by: bag)

        }
        
    }

    
    
    
    
    
    
    
    
}
