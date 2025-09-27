//
//  StoreDetailSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/10.
//

import UIKit
import RxSwift

class StoreDetailSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var minOrderPrice: Double = 0
    ///查询数据范围（0：30天 1：60天 2：90天）
    private var salesScope: String = ""
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
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
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: "SettingOptionCell")
        return tableView
    }()

    
    private lazy var setPriceAlert: SetMinOrderPriceAlert = {
        let alert = SetMinOrderPriceAlert()
        alert.clickSaveBlock = { [unowned self] _ in
            //保存
            getStoreInfo_Net()
        }
        return alert
    }()
    
    
    private lazy var setScopeAlert: DataScopeAlert = {
        let alert = DataScopeAlert()
        alert.clickSaveBlock = { [unowned self] _ in
            //保存
            getStoreInfo_Net()
        }
        return alert
    }()

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Restaurant details settings".local
    }

    
    override func setViews() {
        setUpUI()
        getStoreInfo_Net()
    }

    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.bottom.equalToSuperview()
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)

    }

    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingOptionCell") as! SettingOptionCell
        
        if indexPath.row == 0 {
            var tStr = ""
            if salesScope == "0" {
                tStr = "1 day".local
            }
            if salesScope == "1" {
                tStr = "30 days".local
            }
            if salesScope == "2" {
                tStr = "60 days".local
            }
            if salesScope == "3" {
                tStr = "90 days".local
            }
            if salesScope == "4" {
                tStr = "perpetual".local
            }


            cell.setCellData(imgStr: "salesScope", titStr: "Data Management".local, msgStr: tStr)
        }
        if indexPath.row  == 1 {
            cell.setCellData(imgStr: "minOrder", titStr: "Min delivery price".local, msgStr: "£\(D_2_STR(minOrderPrice))")
        }
        if indexPath.row == 2 {
            cell.setCellData(imgStr: "customerTag", titStr: "Customer tags setting".local, msgStr: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            ///數據查詢
            setScopeAlert.setAlertData(scopeID: salesScope)
            setScopeAlert.appearAction()
        }
        if indexPath.row == 1 {
            ///設置最低起送費用
            setPriceAlert.setAlertData(price: D_2_STR(minOrderPrice))
            setPriceAlert.appearAction()
        }
        if indexPath.row == 2 {
            //客戶标签
            let vc = CustomerTagListController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    
    private func getStoreInfo_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreInfo().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            minOrderPrice = json["data"]["minOrderPrice"].doubleValue
            salesScope = json["data"]["salesScope"]["id"].stringValue
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
    
}
