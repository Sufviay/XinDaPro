//
//  StoreTimeListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/22.
//

import UIKit
import RxSwift
import MJRefresh


class StoreTimeListController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {


    private let bag = DisposeBag()
    
    private var timeArr: [DayTimeModel] = []
    
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
                
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        tableView.register(OpeningTimeListCell.self, forCellReuseIdentifier: "OpeningTimeListCell")
        
        return tableView
        
    }()
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add", HCOLOR("465DFD"), BFONT(17), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        but.layer.cornerRadius = 10
        return but
    }()


    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
    }

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Opening hours"
        loadData_Net()
    }

    
    private func setUpUI() {
        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
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
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
        }

        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }
    
    
    @objc private func clickAddAction() {
        //添加
        let nextVC = AddStoreTimeController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return timeArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningTimeListCell") as! OpeningTimeListCell
        cell.setCellData(model: timeArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            if type == "detail" {
                //详情
                let detailVC = StoreTimeDetailController()
                detailVC.timeModel = self.timeArr[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            if type == "edit" {
                //编辑
                let editVC = AddStoreTimeController()
                editVC.timeModel = self.timeArr[indexPath.row]
                self.navigationController?.pushViewController(editVC, animated: true)
            }
            
            if type == "dish" {
                //编辑菜品
                let editDishVC = StoreTimeBindingDishController()
                editDishVC.timeID = self.timeArr[indexPath.row].timeId
                self.navigationController?.pushViewController(editDishVC, animated: true)
            }

            if type == "status" {
                //禁用启用
                self.canUseAction_Net(timeID: self.timeArr[indexPath.row].timeId)
            }
            
            if type == "delete" {
                //删除
                self.showSystemChooseAlert("Alert", "Delete or not", "YES", "NO") {
                    
                    if self.timeArr[indexPath.row].status == "1" {
                        self.showSystemChooseAlert("Alert", "The time range is in use. Do you want to delete it？", "Delete", "Cancel") {
                            self.deleteAction_Net(timeID: self.timeArr[indexPath.row].timeId)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = StoreTimeDetailController()
        detailVC.timeModel = timeArr[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getStoreOpeningHours().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var tArr: [DayTimeModel] = []
            for jsondata in json["data"]["openTimeValList"].arrayValue {
                let model = DayTimeModel()
                model.updateModel(json: jsondata)
                model.updateTimeListModel(relationJsonArr: json["data"]["openTimeWeekList"].arrayValue)
                tArr.append(model)
            }
            self.timeArr = tArr
            
            if timeArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            
            self.table.reloadData()
            table.mj_header?.endRefreshing()
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    private func deleteAction_Net(timeID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteOpeningHours(timeID: timeID).subscribe(onNext: { [unowned self] json in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func canUseAction_Net(timeID: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.openingHoursCanUse(timeID: timeID).subscribe(onNext: { [unowned self] json in
            HUD_MB.dissmiss(onView: self.view)
            self.loadData_Net()
        }, onError: { [unowned self] error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

}
