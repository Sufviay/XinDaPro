//
//  DeskSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/1.
//

import UIKit
import RxSwift
import MJRefresh

class DeskSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    private var dataArr: [TableModel] = []
    
    private var page: Int = 0
    
    private var deskIsEdit: Bool = false {
        didSet {
            if deskIsEdit {
                addBut.isHidden = true
                saveBut.isHidden = false
                cancelBut.isHidden = false
            } else {
                addBut.isHidden = false
                saveBut.isHidden = true
                cancelBut.isHidden = true
            }
        }
    }
    
    
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
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add".local, MAINCOLOR, TIT_2, BACKCOLOR_3)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let pxBt: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("px"), for: .normal)
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, MAINCOLOR, TIT_2, .clear)
        but.layer.cornerRadius = 14
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        but.isHidden = true
        return but
    }()

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        but.isHidden = true
        return but
    }()

    
    private lazy var editAlert: TableEditAlert = {
        let alert = TableEditAlert()
        alert.savedBlock = { [unowned self] (_) in
            loadData_Net()
        }
        return alert
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Dine-in table management".local
    }
    
    
    private func setUpUI() {
        
        view.addSubview(pxBt)
        pxBt.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(leftBut)
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.height.equalTo(50)
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(backView.snp.centerX).offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalTo(backView.snp.centerX).offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }

        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
            $0.top.equalToSuperview().offset(20)
        }

        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            self.loadData_Net(true)
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
        pxBt.addTarget(self, action: #selector(clickPXAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickAddAction() {
        editAlert.setData(id: "", name: "", num: "")
        editAlert.appearAction()
    }
    
    
    @objc private func clickSaveAction() {
        saveSort_Net()
    }
    
    @objc private func clickCancelAction() {
        deskIsEdit = false
        table.setEditing(false, animated: true)
        loadData_Net()
    }


    
    @objc private func clickPXAction() {
        if !deskIsEdit {
            deskIsEdit = true
            table.setEditing(true, animated: true)
        }
        
    }
    
    
    private func getSortList() -> [[String: String]] {
        
        var tArr: [[String: String]] = []
        for (idx, model) in dataArr.enumerated() {
            
            let info = ["deskId": model.deskId, "sort": String(idx + 1)]
            tArr.append(info)
        }
        return tArr
    }
    
    
}

extension DeskSettingController {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].deskName.getTextHeigh(BFONT(17), S_W - 100) + 40 + 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableInfoCell") as! TableInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            
            if type as! String == "status" {
                //改变状态
                setStatus_Net(idx: indexPath.row)
            }
            
            if type as! String == "edit" {
                //编辑
                editAlert.setData(id: dataArr[indexPath.row].deskId, name: dataArr[indexPath.row].deskName, num: dataArr[indexPath.row].dinersNum)
                editAlert.appearAction()
            }
            
            if type as! String == "delete" {
                //删除
                showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) {
                    self.deleteAction_Net(idx: indexPath.row)
                }
                
            }
            
        }
        
        return cell
    }
    

}


extension DeskSettingController {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 防止缩进，使整个行可拖动
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //插入
        let model = dataArr.remove(at: sourceIndexPath.row)
        dataArr.insert(model, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
}


extension DeskSettingController {
    
    private func loadData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
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
    
    private func saveSort_Net() {
        HUD_MB.loading("", onView: view)
        let sort = getSortList()
        HTTPTOOl.deskDoSort(sortList: sort).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success".local, onView: view)
            deskIsEdit = false
            table.setEditing(false, animated: true)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
}



