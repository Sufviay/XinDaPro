//
//  SalesIncomSearchController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/7.
//

import UIKit
import RxSwift

class SalesIncomSearchController: XSBaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    

    private let bag = DisposeBag()
    
    private var dataArr: [StoreCommissionModel] = []
    private var page: Int = 1

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.setCommonShadow()
        return view
    }()

    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search for a store"
        tf.textColor = TXTCOLOR_1
        tf.font = TXT_14
        tf.delegate = self
        return tf
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
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()
 
    
    override func setNavi() {
        leftBut.setImage(LOIMG("xs_nav_back"), for: .normal)
    }
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
        inputTF.becomeFirstResponder()
    }
    
    private func setUpUI() {
        
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.left.equalTo(leftBut.snp.right).offset(0)
            $0.height.equalTo(35)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(leftBut)
        }
        
        searchView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(statusBarH + 70)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 5)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreIncomeCell") as! StoreIncomeCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loadData_Net()
    }

    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }

        
        HTTPTOOl.salesGetCommissionList(storeId: "", storeName: inputTF.text ?? "", page: 1).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.dissmiss(onView: view)
            
            page = 2
            var tArr: [StoreCommissionModel] = []
            for jsonData in json["data"].arrayValue {
                let model = StoreCommissionModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            dataArr = tArr
        
            if dataArr.count == 0 {
                table.layoutIfNeeded()
                table.addSubview(noDataView)
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
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.salesGetCommissionList(storeId: "", storeName: inputTF.text ?? "", page: page).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = StoreCommissionModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
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
