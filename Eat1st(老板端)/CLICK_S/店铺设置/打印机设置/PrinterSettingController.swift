//
//  PrinterSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit
import RxSwift
import MJRefresh


class PrinterSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    
    private var dataArr: [PrinterModel] = []
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_add"), for: .normal)
        but.setCommentStyle(.zero, "Add", HCOLOR("465DFD"), BFONT(17), HCOLOR("#8F92A1").withAlphaComponent(0.06))
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
        tableView.register(PrinterInfoCell.self, forCellReuseIdentifier: "PrinterInfoCell")
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        return tableView
    }()
    
    private lazy var editAlert: EditPrintAlert = {
        let alert = EditPrintAlert()
        alert.savedBlock = { [unowned self] (_) in
            loadPrinterList_Net()
        }
        return alert
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Printer Setting"
    }
    
    override func setViews() {
        setUpUI()
        loadPrinterList_Net()
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
            loadPrinterList_Net(true)
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickAddAction() {
        editAlert.setData(model: PrinterModel())
        editAlert.appearAction()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterInfoCell") as! PrinterInfoCell
        cell.setCellData(model: model)
        
        cell.clickMoreBlock = { [unowned self] (type) in
            
            if type as! String == "main" {
                //是否为主打印机
                doMainPrinter(id: dataArr[indexPath.row].printerId)
            }
            
            if type as! String == "status" {
                //改变状态
                doStatus_Net(id: dataArr[indexPath.row].printerId)
            }
            
            if type as! String == "edit" {
                //编辑
                editAlert.setData(model: dataArr[indexPath.row])
                editAlert.appearAction()
            }
            
            if type as! String == "delete" {
                //删除
                showSystemChooseAlert("Alert", "Delete or not?", "YES", "NO") {
                    self.delete_Net(id: self.dataArr[indexPath.row].printerId)
                }
            }
            
            if type as! String == "dish" {
                let nextVC = PrinterLinkController()
                nextVC.printerID = model.printerId
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
        return cell

    }


}

extension PrinterSettingController {
    
    
    //MARK: - 网络请求
    
    ///列表
    private func loadPrinterList_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getPrinterList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [PrinterModel] = []
            for jsonData in json["data"].arrayValue {
                let model = PrinterModel.deserialize(from: jsonData.dictionaryObject!) ?? PrinterModel()
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
        HTTPTOOl.deletePrinter(id: id).subscribe(onNext: { [unowned self] (json) in
            loadPrinterList_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    ///改变状态
    private func doStatus_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doPrinterStatus(id: id).subscribe(onNext: { [unowned self] (json) in
            loadPrinterList_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    //设置是否为主打印机
    private func doMainPrinter(id: String)  {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doMainPrinter(id: id).subscribe(onNext: { [unowned self] (json) in
            loadPrinterList_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
}
