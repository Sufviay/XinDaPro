//
//  StoreListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/1/26.
//

import UIKit
import SwiftyJSON
import RxSwift

class StoreListController: LBBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    
    private let bag = DisposeBag()
    
    var dataArr: [StoreModel] = []
    
    ///登录信息
    var logininfo: JSON?
    var isLogin: Bool = false
    
    var canBack: Bool = true
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F9F9F9")
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
            
        //回弹效果
        tableView.bounces = !isLogin
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(StoreInfoCell.self, forCellReuseIdentifier: "StoreInfoCell")
        return tableView
    }()

    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Choose Store".local
    }
    
    
    
    
    
    override func setViews() {
        setUpUI()
        
        if !isLogin {
            loadData_Net()
        }
        
    }
    
    
    private func setUpUI() {
        
        leftBut.isHidden = !canBack
        
        view.addSubview(backView)
        
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }

        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let name = dataArr[indexPath.row].storeName
        let h = name.getTextHeigh(TIT_14, S_W - 90) + 50
        return h
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell") as! StoreInfoCell
        
        let storeID = dataArr[indexPath.row].storeId
        let storeID_BD = UserDefaults.standard.storeID ?? ""
        let isSel = storeID == storeID_BD ? true : false
        cell.setCellData(name: dataArr[indexPath.row].storeName, isSelect: isSel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        let storeID = model.storeId
        let storeID_BD = UserDefaults.standard.storeID ?? ""
        if storeID != storeID_BD {
            HUD_MB.loading("", onView: view)
            if isLogin {
                //选择店铺进行登录
                UserDefaults.standard.token = logininfo?["data"]["token"].stringValue
                UserDefaults.standard.userName = logininfo?["data"]["name"].stringValue
                UserDefaults.standard.userRole = logininfo?["data"]["accountType"].stringValue
                UserDefaults.standard.storeName = model.storeName
                UserDefaults.standard.userAuth = model.auth
                UserDefaults.standard.storeID = model.storeId
                UserDefaults.standard.isLogin = true
                UserDefaults.standard.loginDate = Date().getString("yyyy-MM-dd HH:mm:ss")

            } else {
                //切换店铺
                UserDefaults.standard.storeName = model.storeName
                UserDefaults.standard.userAuth = model.auth
                UserDefaults.standard.storeID = model.storeId
            }
            
            table.reloadData()
            DispatchQueue.main.after(time: .now() + 1) {
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.setViewControllers([BossFirstController()], animated: false)
            }
        }
    }
    
    
    private func loadData_Net(_ isLoading: Bool = false ) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HTTPTOOl.getLoginInfo().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            var tarr: [StoreModel] = []
            for jsonData in json["data"]["storeList"].arrayValue {
                let model = StoreModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            dataArr = tarr
            if dataArr.count == 0 {
                table.addSubview(noDataView)
                
                //没有绑定的店铺退出登录
                HUD_MB.showWarnig("You do not have the permission for store.".local, onView: PJCUtil.getWindowView())
                HTTPTOOl.userLogOut().subscribe(onNext: { [unowned self] (json) in
    
                    UserDefaults.standard.isLogin = false
                    UserDefaults.standard.removeObject(forKey: Keys.userName)
                    UserDefaults.standard.removeObject(forKey: Keys.userAuth)
                    UserDefaults.standard.removeObject(forKey: Keys.storeName)
                    UserDefaults.standard.removeObject(forKey: Keys.userRole)
                    UserDefaults.standard.removeObject(forKey: Keys.storeID)
                    navigationController?.setViewControllers([LogInController()], animated: false)
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
                }).disposed(by: self.bag)
                
            } else {
                noDataView.removeFromSuperview()
            }
            
            table.reloadData()
            table.mj_header?.endRefreshing()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
}
