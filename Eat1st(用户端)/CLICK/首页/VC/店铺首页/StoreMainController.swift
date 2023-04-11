//
//  StoreMainController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/8.
//

import UIKit
import RxSwift

class StoreMainController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    private let bag = DisposeBag()
    
    ///店铺ID
    var storeID: String = ""
    ///店铺信息
    private var dataModel = StoreInfoModel()
    
//    ///是否是扫一扫进来的
//    var isScan: Bool = false

    var type: String = ""
    
    
    private let homeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_cbl_w"), for: .normal)
        but.backgroundColor = .black.withAlphaComponent(0.4)
        but.layer.cornerRadius = 7
        return but
    }()
    
    
    ///钱包
//    private let walletView: WalletView = {
//        let view = WalletView()
//        return view
//    }()
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
        view.isHome = false
        return view
    }()

    
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(StoreFirstHeadCell.self, forCellReuseIdentifier: "StoreFirstHeadCell")
        tableView.register(StoreMidInfoCell.self, forCellReuseIdentifier: "StoreMidInfoCell")
        tableView.register(StoreDesCell.self, forCellReuseIdentifier: "StoreDesCell")
        tableView.register(StoreFirstPageButCell.self, forCellReuseIdentifier: "StoreFirstPageButCell")
        return tableView
    }()

    
    override func setViews() {
        
        view.backgroundColor = .white
        setUpUI()
        addNotificationCenter()
        loadData_Net()
    }
    
    override func setNavi() {
        //getWalletMoney_Net()
    }
    
    override func didAppear() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    
    private func setUpUI() {
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(homeBut)
        homeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.top.equalToSuperview().offset(statusBarH + 7)
            $0.left.equalToSuperview().offset(10)
        }

        homeBut.addTarget(self, action: #selector(clickCBLAction), for: .touchUpInside)
        //view.addSubview(walletView)
    }
    
    
    @objc private func clickCBLAction()  {
        sideBar.appearAction()
    }
    
    
    
    private func loadData_Net() {
        
        HUD_MB.loading("", onView: view)
        
        HTTPTOOl.Store_MainPageData(storeID: storeID, type: type).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.dataModel.updateModel(json: json["data"])
            self.bindingAction_Net()
            self.table.reloadData()
                        
        }, onError: { (error) in
            HUD_MB.showMessage(ErrorTool.errorMessage(error), self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    
    
    private func bindingAction_Net() {
        //进行店铺绑定
        HTTPTOOl.bindingStore(storeID: dataModel.storeID).subscribe(onNext: { (json) in
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
//    @objc func getWalletMoney_Net() {
//        HTTPTOOl.getWalletAmount().subscribe(onNext: { (json) in
//
//            let moneyStr = "£" + json["data"]["amount"].stringValue
//            self.walletView.setData(money: moneyStr)
//            let w = moneyStr.getTextWidth(SFONT(11), 23) > 15 ? moneyStr.getTextWidth(SFONT(11), 23) : 15
//
//
//
//            self.walletView.snp.makeConstraints {
//                $0.top.equalToSuperview().offset(statusBarH + 2)
//                $0.right.equalToSuperview().offset(-20)
//                $0.size.equalTo(CGSize(width: w + 50, height: 32))
//            }
//
//            self.walletView.isHidden = false
//
//        }, onError: { (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
    
    
    //MARK: - 注册通知中心
    private func addNotificationCenter() {
        //NotificationCenter.default.addObserver(self, selector: #selector(walletRefresh), name: NSNotification.Name(rawValue: "wallet"), object: nil)
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name("wallet"), object: nil)
    }
    
    @objc func walletRefresh() {
        //getWalletMoney_Net()
    }

    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return SET_H(265, 375)
        }
        if indexPath.row == 1 {
            return R_H(200)
        }
        if indexPath.row == 2 {
            let str = "Store introduction:\n" + self.dataModel.des
            return str.getTextHeigh(SFONT(12), S_W - 60) + 50
        }
        if indexPath.row == 3 {
            return 220
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFirstHeadCell") as! StoreFirstHeadCell
            cell.setCellData(imgStr: self.dataModel.coverImg)
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreMidInfoCell") as! StoreMidInfoCell
            cell.setCellData(model: self.dataModel)
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDesCell") as! StoreDesCell
            cell.setCellData(desLab: "Store introduction:\n" + self.dataModel.des)
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFirstPageButCell") as! StoreFirstPageButCell
            return cell
            
        }
        
        let cell = UITableViewCell()
        return cell
    }

}

