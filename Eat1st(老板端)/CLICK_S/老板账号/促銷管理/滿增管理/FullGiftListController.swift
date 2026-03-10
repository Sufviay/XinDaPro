//
//  FullGiftListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/12/17.
//

import UIKit
import RxSwift

class FullGiftListController: LBBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    
    private let bag = DisposeBag()
    
    private var dataArr: [FullGiftModel] = []
    
    private var page: Int = 1
    
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
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(FullGiftInfoCell.self, forCellReuseIdentifier: "FullGiftInfoCell")
        return tableView
    }()

    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add".local, HCOLOR("465DFD"), TIT_16, BACKCOLOR_3)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()


    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Order full gift Management".local
        loadData_Net()
    }

    
    override func setViews() {
        setUpUI()
        
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
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
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
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }

    
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickAddAction() {
        let vc = FullGiftEditController()
        navigationController?.pushViewController(vc, animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].listCell_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullGiftInfoCell") as! FullGiftInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            if type == "delete" {
                //刪除
                if dataArr[indexPath.row].status == "1" {
                    HUD_MB.showWarnig("Enabled. Cannot be deleted.".local, onView: view)
                    return
                }
                showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) {
                    self.deleteAction_Net(idx: indexPath.row)
                }
            }
            if type == "status" {
                //改變狀態
                editStatus_Net(idx: indexPath.row)
            }
            if type == "edit" {
                //編輯
                let editVC = FullGiftEditController()
                editVC.dataModel = dataArr[indexPath.row]
                navigationController?.pushViewController(editVC, animated: true)
            }
        }
        
        
        return cell
    }
    
            
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HTTPTOOl.getFullGiftList(name: "", price: "", status: "", page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            var tArr: [FullGiftModel] = []
            for jsonData in json["data"].arrayValue {
                let model = FullGiftModel()
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
        HTTPTOOl.getFullGiftList(name: "", price: "", status: "", page: page).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                page += 1
                for jsonData in json["data"].arrayValue {
                    let model = FullGiftModel()
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
    
    
    private func editStatus_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        var statusStr = ""
        if dataArr[idx].status == "1" {
            statusStr = "2"
        } else {
            statusStr = "1"
        }
        
        HTTPTOOl.changeFullGiftStatus(id: dataArr[idx].giftId, status: statusStr).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            dataArr[idx].status = statusStr
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    
    private func deleteAction_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteFullGift(id: dataArr[idx].giftId).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            dataArr.remove(at: idx)

            if dataArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    


    
    
}
