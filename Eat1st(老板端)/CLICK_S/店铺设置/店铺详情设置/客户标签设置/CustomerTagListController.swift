//
//  CustomerTagListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/23.
//

import UIKit
import RxSwift

class CustomerTagListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    private var dataArr: [CustomerTagModel] = []
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add".local, MAINCOLOR, TIT_2, BACKCOLOR_3)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        return but
    }()


    private lazy var table: UITableView = {
        let tableView = UITableView()
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
        tableView.register(CustomerTagInfoCell.self, forCellReuseIdentifier: "CustomerTagInfoCell")
        return tableView
    }()

    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()
    
    private lazy var editAlert: EditCustomerTagAlert = {
        let alert = EditCustomerTagAlert()
        alert.saveClock = { [unowned self] _ in
            loadData_Net()
        }
        return alert
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Customer tags setting".local
    }

    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }

    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.height.equalTo(50)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
            $0.top.equalToSuperview().offset(20)
        }

        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }

    
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickAddAction() {
        editAlert.setAlertData(model: CustomerTagModel())
        editAlert.appearAction()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTagInfoCell") as! CustomerTagInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            if type as! String == "edit" {
                //编辑
                editAlert.setAlertData(model: dataArr[indexPath.row])
                editAlert.appearAction()
            }
            
            if type as! String == "delete" {
                //删除
                showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) {
                    self.delete_Net(id: self.dataArr[indexPath.row].tagId)
                }
            }

        }
        return cell
    }
    
    
    ///列表
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getCustomerTagList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [CustomerTagModel] = []
            for jsonData in json["data"].arrayValue {
                let model = CustomerTagModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            
            if dataArr.count == 0 {
                table.addSubview(noDataView)
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
    
    
    //刪除
    private func delete_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteCustomTag(id: id).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            loadData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
}
