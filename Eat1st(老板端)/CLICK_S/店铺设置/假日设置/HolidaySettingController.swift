//
//  HolidaySettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/6/26.
//

import UIKit
import RxSwift


class HolidaySettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private var dataArr: [HolidayModel] = []
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add".local, HCOLOR("465DFD"), TIT_2, HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        but.layer.cornerRadius = 10
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
        tableView.register(HolidayInfoCell.self, forCellReuseIdentifier: "HolidayInfoCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    private lazy var editAlert: EditHolidayAlert = {
        let alert = EditHolidayAlert()
        alert.savedBlock = { [unowned self] (_) in
            loadHolidayList_Net()
        }
        return alert
    }()

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Holiday".local
    }
    
    override func setViews() {
        setUpUI()
        loadHolidayList_Net()
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
            loadHolidayList_Net(true)
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)

    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickAddAction() {
        editAlert.setData(model: HolidayModel())
        editAlert.appearAction()
    }
    

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cell_H
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayInfoCell") as! HolidayInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            
            if type as! String == "edit" {
                //编辑
                editAlert.setData(model: dataArr[indexPath.row])
                editAlert.appearAction()
            }
            
            if type as! String == "delete" {
                //删除
                showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) { [unowned self] in
                    delete_Net(id: self.dataArr[indexPath.row].holidayId)
                }
            }

        }
        
        return cell
    }
    


    
    

}

extension HolidaySettingController {
    
    //MARK: - 网络请求
    
    ///列表
    private func loadHolidayList_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getHolidayList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [HolidayModel] = []
            for jsonData in json["data"].arrayValue {
                let model = HolidayModel.deserialize(from: jsonData.dictionaryObject!) ?? HolidayModel()
                model.uodateHight()
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
    
    
    ///删除
    private func delete_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteHoliday(id: id).subscribe(onNext: { [unowned self] (json) in
            loadHolidayList_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
}
