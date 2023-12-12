//
//  DeskSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/1.
//

import UIKit
import RxSwift
import MJRefresh

class DeskSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var dataArr: [TableModel] = []
    
    private var page: Int = 0
    
    
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
        tableView.register(TableInfoCell.self, forCellReuseIdentifier: "TableInfoCell")
        return tableView
    }()

    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Add", HCOLOR("#465DFD"), BFONT(15), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.layer.cornerRadius = 10
        but.setImage(LOIMG("dis_add"), for: .normal)
        return but
    }()
    
    
    private lazy var editAlert: TableEditAlert = {
        let alert = TableEditAlert()
        alert.savedBlock = { [unowned self] (_) in
            loadData_Net()
        }
        return alert
    }()
    
    
    
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Table setting"
    }
    
    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.height.equalTo(60)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
            $0.top.equalToSuperview().offset(20)
        }

        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }


        
        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }
    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickAddAction() {
        editAlert.setData(id: "", name: "")
        editAlert.appearAction()
    }
    
    
    
}

extension DeskSettingController {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].deskName.getTextHeigh(BFONT(17), S_W - 100) + 40 + 20
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableInfoCell") as! TableInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            
            if type as! String == "open" {
                //改变状态
                setStatus_Net(idx: indexPath.row)
            }
            
            if type as! String == "edit" {
                //编辑
                editAlert.setData(id: dataArr[indexPath.row].deskId, name: dataArr[indexPath.row].deskName)
                editAlert.appearAction()
            }
            
            if type as! String == "delete" {
                //删除
                deleteAction_Net(idx: indexPath.row)
            }
            
        }
        
        return cell
    }
    

}


extension DeskSettingController {
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeskList(page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            var tArr: [TableModel] = []
            for jsonData in json["data"].arrayValue {
                let model = TableModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeskList(page: page).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
        
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = TableModel()
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
    
    
    
    
    private func setStatus_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setDeskStatus(id: dataArr[idx].deskId).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            if dataArr[idx].status == "1" {
                dataArr[idx].status = "2"
            } else {
                dataArr[idx].status = "1"
            }
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    private func deleteAction_Net(idx: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteDesk(id: dataArr[idx].deskId).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            dataArr.remove(at: idx)
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
}



