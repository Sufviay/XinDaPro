//
//  ChooseAddressController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/27.
//

import UIKit
import RxSwift
import MJRefresh




protocol SelectAddressDelegate {

    func didSelectedAddress(model: AddressModel)
    
}


class ChooseAddressController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var page: Int = 1
    
    ///店铺ID
    var storeID: String = ""
    
    var delegate: SelectAddressDelegate?
    
    private var addressArr: [AddressModel] = []
    
    private var defaultArr: [AddressModel] = []
    private var ableArr: [AddressModel] = []
    private var unalbeArr: [AddressModel] = []
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Add Address", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    private lazy var mainTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = true
        tableView.register(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        tableView.register(DefaultAddressCell.self, forCellReuseIdentifier: "DefaultAddressCell")
        return tableView
    }()
    
    private lazy var noDataView: NoAddressDataView = {
        let view = NoAddressDataView()
        view.frame = self.mainTable.bounds
        return view
    }()
    

    override func setViews() {
        view.backgroundColor = .white
        setUpUI()
    }
    
    
    override func setNavi() {
        self.naviBar.headerTitle = "Address Book"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
        loadData_Net()
    }

    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        
        view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(45)
        }
        
        let line = UIView()
        line.backgroundColor = HCOLOR("#F7F7F7")
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom)
            $0.height.equalTo(7)
        }
        
        
        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(0)
            $0.bottom.equalTo(addBut.snp.top).offset(-20)
        }
        
        mainTable.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
        
        addBut.addTarget(self, action: #selector(clickAddAciton), for: .touchUpInside)
        
    }

    @objc private func clickAddAciton() {
        let nextVC = EditeAddressController()
        nextVC.isNew = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        let listType = storeID == "" ? "2" : "1"
        
        HTTPTOOl.getAddressList(storeID: storeID, type: listType, page: 1).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            
            var tArr: [AddressModel] = []
            for jsonData in json["data"].arrayValue {
                let model = AddressModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.addressArr = tArr
            
            self.defaultArr = self.addressArr.filter { $0.isDefault }
            
            self.ableArr = self.addressArr.filter { !$0.overRange && !$0.isDefault }
            
            self.unalbeArr = self.addressArr.filter { $0.overRange && !$0.isDefault }

            
            
            if self.addressArr.count == 0 {
                self.mainTable.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            
            self.mainTable.mj_header?.endRefreshing()
            self.mainTable.mj_footer?.resetNoMoreData()

            self.mainTable.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.mainTable.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
}

extension ChooseAddressController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            return defaultArr.count
        }
        if section == 1 {
            return ableArr.count
        }
        if section == 2 {
            return unalbeArr.count
        }
            
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return defaultArr[indexPath.row].address_H
        }
        
        if indexPath.section == 1 {
            return ableArr[indexPath.row].address_H
        }
        
        if indexPath.section == 2 {
            return unalbeArr[indexPath.row].address_H
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultAddressCell") as! DefaultAddressCell
            cell.setCellData(model: defaultArr[indexPath.row])
            
            cell.clickEditeBlock = { [unowned self] (_) in
                let nextVC = EditeAddressController()
                nextVC.isNew = false
                nextVC.addressModel = self.defaultArr[indexPath.row]
                self.navigationController?.pushViewController(nextVC, animated: true)
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
            
            if indexPath.section == 1 {
                cell.setCellData(model: ableArr[indexPath.row])
            }
            if indexPath.section == 2 {
                cell.setCellData(model: unalbeArr[indexPath.row])
            }
            cell.clickEditeBlock = { [unowned self] (_) in
            
                let nextVC = EditeAddressController()
                nextVC.isNew = false
                if indexPath.section == 1 {
                    nextVC.addressModel = self.ableArr[indexPath.row]
                }
                if indexPath.section == 2 {
                    nextVC.addressModel = self.unalbeArr[indexPath.row]
                }
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            return cell
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if storeID != "" {
                
            var model = AddressModel()
            if indexPath.section == 0 {
                model = defaultArr[indexPath.row]
            }
            if indexPath.section == 1 {
                model = ableArr[indexPath.row]
            }
            
            if !model.overRange {
                delegate?.didSelectedAddress(model: model)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
