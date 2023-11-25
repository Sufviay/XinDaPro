//
//  PrinterSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit
import RxSwift


class PrinterSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

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
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickAddAction() {
        editAlert.setData(name: "", ip: "", id: "")
        editAlert.appearAction()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterInfoCell") as! PrinterInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickMoreBlock = { [unowned self] (type) in
            
            if type as! String == "open" {
                //改变状态
                doStatus_Net(id: dataArr[indexPath.row].printerId)
            }
            
            if type as! String == "edit" {
                //编辑
                editAlert.setData(name: dataArr[indexPath.row].name, ip: dataArr[indexPath.row].ip, id: dataArr[indexPath.row].printerId)
                editAlert.appearAction()
            }
            
            if type as! String == "delete" {
                //删除
                delete_Net(id: dataArr[indexPath.row].printerId)
            }
        }
        
        return cell

    }


}

extension PrinterSettingController {
    
    
    //MARK: - 网络请求
    
    ///列表
    private func loadPrinterList_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getPrinterList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [PrinterModel] = []
            for jsonData in json["data"].arrayValue {
                let model = PrinterModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
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
}
