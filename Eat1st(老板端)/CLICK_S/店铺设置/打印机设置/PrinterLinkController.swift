//
//  PrinterLinkController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/2/6.
//

import UIKit
import RxSwift
import MJRefresh


class PrinterLinkController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {


    var printerID: String = ""
    
    private let bag = DisposeBag()

    private var dataArr: [ComboDishModel] = []
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    
    private let editBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Edit".local, .white, TIT_2, MAINCOLOR)
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
        tableView.register(PrinterDishesCell.self, forCellReuseIdentifier: "PrinterDishesCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Dishes".local
        loadDishesData_Net()
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
        
        backView.addSubview(editBut)
        editBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }

        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(editBut.snp.top).offset(-10)
            $0.top.equalToSuperview().offset(20)
        }

        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadDishesData_Net(true)
        }
        
        editBut.addTarget(self, action: #selector(clickEditAction), for: .touchUpInside)
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickEditAction() {
        
        let editdishVC = MenuComboEditDishController()
        editdishVC.pageType = .printer
        let model = DishDetailComboModel()
        model.comboDishesList = dataArr
        editdishVC.comboModel = model
        editdishVC.printID = printerID
        navigationController?.pushViewController(editdishVC, animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = dataArr[indexPath.row]
        let h1 = model.name1.getTextHeigh(TIT_3, S_W - 40)
        let h2 = model.name2.getTextHeigh(TXT_1, S_W - 40)
        return h1 + h2 + 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterDishesCell") as! PrinterDishesCell
        cell.setCellData(name1: dataArr[indexPath.row].name1, name2: dataArr[indexPath.row].name2)
        return cell
    }
    
    
    
    
    
    private func loadDishesData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getPrinterLinkDishes(id: printerID).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.dissmiss(onView: view)
            
            var tarr: [ComboDishModel] = []
            
            for jsonData in json["data"].arrayValue {
                let model = ComboDishModel()
                model.updatePrinterDishModel(json: jsonData)
                tarr.append(model)
            }
            dataArr = tarr
            
            if dataArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }

            table.mj_header?.endRefreshing()
            table.reloadData()

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
}
