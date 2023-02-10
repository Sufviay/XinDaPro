//
//  ChangeDistanceController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/11.
//

import UIKit
import RxSwift


class ChangeDistanceController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    private let bag = DisposeBag()
    
    private var dataArr: [DeliveryFeeModel] = []

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .left)
        lab.numberOfLines = 0
        lab.text = "1. The delivery distance shall be at most one decimal point and must be greater than 0. The delivery fee can be 0.\n2. Delivery distance and delivery fee must be increasing.\n3. The farthest distance is the maximum distribution distance of the store."
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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
        
        tableView.register(DistanceChargeCell.self, forCellReuseIdentifier: "DistanceChargeCell")
        tableView.register(DistanceAddCell.self, forCellReuseIdentifier: "DistanceAddCell")
        return tableView
        
    }()
    
    private lazy var editeView: DistanceEditeView = {
        let view = DistanceEditeView()
        
        view.clickSaveBlock = { [unowned self] (val) in
            let par = val as! [[String: Any]]
            self.addData_Net(par: par)
        }
        
        return view
    }()

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Change distance limit"
    
    }

    
    override func setViews() {
        setUpUI()
        getData_Net()
    }
    
    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(titLab.snp.bottom).offset(20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(0)
            $0.bottom.equalToSuperview()
        }
        
        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)

    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceChargeCell") as! DistanceChargeCell
            cell.setCellData(model: dataArr[indexPath.row])
            cell.clickDeleteBlock = { [unowned self] (_) in
                
                //二次确认
                self.showSystemChooseAlert("Alert", "Delete it?", "YES", "NO") {
                    self.deleteData_Net(id: self.dataArr[indexPath.row].id)
                }

            }
            
            cell.editeBlock = { [unowned self] (_) in
                //编辑
                let model = dataArr[indexPath.row]
                editeView.curFeeList = self.dataArr
                editeView.setValueWith(miles: String(model.distance), pound: String(model.amount))
                editeView.editeIdx = indexPath.row
                editeView.isEdite = true
                editeView.appearAction()
            }

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceAddCell") as! DistanceAddCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            editeView.curFeeList = self.dataArr
            editeView.setValueWith(miles: "", pound: "")
            editeView.isEdite = false
            editeView.appearAction()
        }
    }
    
}

extension ChangeDistanceController {
    
    //MARK: - 网络请求
    private func getData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeliveryFeeList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [DeliveryFeeModel] = []
            for jsonData in json["data"].arrayValue {
                let model = DeliveryFeeModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //添加一条
    private func addData_Net(par: [[String: Any]]) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.addDelivaryFeeList(list: par).subscribe(onNext: { (json) in
            self.getData_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //删除一条
    func deleteData_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteDeliveryFee(id: id).subscribe(onNext: { (json) in
            self.getData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
}



