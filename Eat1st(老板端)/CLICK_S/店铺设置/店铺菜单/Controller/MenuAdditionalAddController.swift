//
//  MenuAdditionalAddController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/27.
//

import UIKit
import RxSwift
import HandyJSON

class MenuAdditionalAddController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    var addID: String = ""
    
    private var dataModel = AdditionalDetailModel()
    
    var isAdd: Bool = false
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "cancel", HCOLOR("#465DFD"), BFONT(14), .clear)
        but.layer.cornerRadius = 14
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        but.layer.borderWidth = 2
        return but
    }()

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "save", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
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
        
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(DishEditePriceInPutCell.self, forCellReuseIdentifier: "DishEditePriceInPutCell")
        tableView.register(PriceDesCell.self, forCellReuseIdentifier: "PriceDesCell")
        tableView.register(DishEditeClassifyCell.self, forCellReuseIdentifier: "DishEditeClassifyCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(DishEditeChooseCell_Three.self, forCellReuseIdentifier: "DishEditeChooseCell_Three")

        return tableView
        
    }()
    
    
    //选择分类
    private lazy var classifyView: DishSelectClassifyView = {
        let view = DishSelectClassifyView()
        
        view.confirmBlock = { [unowned self] (par) in
            let strArr = par as! [String]
            self.dataModel.classifyId = Int64(strArr[0]) ?? 0
            self.dataModel.classifyNameEn = strArr[1]
            self.dataModel.classifyNameHk = strArr[2]
            self.table.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
        }

        return view
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Additional edit"
    }

    
    override func setViews() {
        setUpUI()
        if !isAdd {
            self.loadData_Net()
        }
    }
    
    
    private func setUpUI() {
                
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
            
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
            $0.top.equalToSuperview().offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(cancelBut.snp.top).offset(-30)
        }
        
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickCancelAction() {
        //取消
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSaveAction() {
        //保存
        saveAction_Net()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            return 80
        }
        if indexPath.row == 4 {
            return 80
        }
        
        if indexPath.row == 5 {
            return 50
        }

        
        if indexPath.row ==  6 {
            return 90
        }
        
        
        if indexPath.row == 7 {
            return 80
        }
        
        if indexPath.row == 8 {
            return 90
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            
            if indexPath.row == 0 {
                cell.setCellData(titStr: "Simplified Chinese name", msgStr: dataModel.nameCn)
            }
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Traditional Chinese name", msgStr: dataModel.nameHk)
            }
            if indexPath.row == 2 {
                cell.setCellData(titStr: "English name", msgStr: dataModel.nameEn)
            }
            if indexPath.row == 3 {
                cell.setCellData(titStr: "Serial number", msgStr: dataModel.attachCode)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.row == 0 {
                    self.dataModel.nameCn = text
                }
                if indexPath.row == 1 {
                    self.dataModel.nameHk = text
                }
                if indexPath.row == 2 {
                    self.dataModel.nameEn = text
                }
                if indexPath.row == 3 {
                    self.dataModel.attachCode = text
                }
            }
    
            return cell
        }
        
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.setCellData(money: dataModel.price, titStr: "Price")
            cell.editeEndBlock = { [unowned self] (text) in
                self.dataModel.price = text == "" ? "0" : text
            }
            return cell
        }
        
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceDesCell") as! PriceDesCell
            return cell
        }

        
        if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell_Three") as! DishEditeChooseCell_Three
            cell.setCellData(titStr: "Dishes kind", l_str: "Food", m_str: "Drink", r_str: "Milk tea", statusID: dataModel.dishesKind)
            cell.selectBlock = { [unowned self] (status) in
                dataModel.dishesKind = status
                tableView.reloadData()
            }
            return cell
        }
        
        
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeClassifyCell") as! DishEditeClassifyCell
            let str = PJCUtil.getCurrentLanguage() == "en_GB" ? dataModel.classifyNameEn : dataModel.classifyNameHk
            cell.setCellData(c_msg: str)
            
            cell.selectBlock = { [unowned self] (_) in
                ///选择分类
                self.classifyView.selectID = String(dataModel.classifyId)
                self.classifyView.type = "add"
                self.classifyView.appearAction()
            }
            
            return cell
        }
        
        if indexPath.row == 8 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                cell.setChooseCellData(titStr: "Status", l_str: "Enable", r_Str: "Disable", statusID: dataModel.statusId)
            
            cell.selectBlock = { [unowned self] (status) in
                dataModel.statusId = status
                table.reloadData()
            }
            
            return cell
        }
        
        
        let cell = UITableViewCell()
        return cell
    }
    
}

extension MenuAdditionalAddController {
    //MARK: - 网络请求
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getAdditionalDetail(id: addID).subscribe(onNext: { [self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            self.dataModel = AdditionalDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            self.dataModel.updateModle()
            self.table.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //保存
    func saveAction_Net() {
       
//        ///校验信息
//        if dataModel.nameCn == "" {
//            HUD_MB.showWarnig("Please fill in the simplified Chinese name!", onView: self.view)
//            return
//        }
//        
//        if dataModel.nameHk == "" {
//            HUD_MB.showWarnig("Please fill in the traditional Chinese name!", onView: self.view)
//            return
//        }
//        
//        if dataModel.nameEn == "" {
//            HUD_MB.showWarnig("Please fill in the English name!", onView: self.view)
//            return
//        }
//        
//        if dataModel.attachCode == "" {
//            HUD_MB.showWarnig("Please fill in the serial number!", onView: self.view)
//            return
//        }
//        
////        if dataModel.price == "" {
////            HUD_MB.showWarnig("Please fill in the price!", onView: self.view)
////            return
////        }
//        
//        if dataModel.classifyId == 0 {
//            HUD_MB.showWarnig("Please fill in the food category!", onView: self.view)
//            return
//        }
        
        
        HUD_MB.loading("", onView: view)
        if isAdd {
            //添加菜品
            HTTPTOOl.addAdditional(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        } else {
            HTTPTOOl.editeAdditional(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
    }
}



