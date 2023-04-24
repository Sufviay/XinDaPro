//
//  MenuDishAddOptionController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit
import RxSwift

class MenuDishAddOptionController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    var dataModel = DishDetailOptionModel()

    var number = 0
    
    var isAdd = false
    
    ///规格ID 添加选项时用
    var specID: String = ""
    

    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_delete"), for: .normal)
        return but
    }()
    
    
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

        tableView.register(SpecHeaderCell.self, forCellReuseIdentifier: "SpecHeaderCell")
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(DishEditePriceInPutCell.self, forCellReuseIdentifier: "DishEditePriceInPutCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
    
        return tableView
        
    }()



    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Option"
        self.rightBut.isHidden = isAdd
    }

    
    override func setViews() {
        setUpUI()
        
    }
    
    
    private func setUpUI() {
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
        
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
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
        }

        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)
        self.cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)

    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickRightAction() {
        //删除
        self.showSystemChooseAlert("Alert", "Delete it?", "YES", "NO") {
            self.deleteSpecOption_Net()
        }

    }
    
    @objc private func clickCancelAction() {
        //取消
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSaveAction() {
        //保存
        saveAciton_Net()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 60
        }
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            return 80
        }
        if indexPath.row == 4 {
            return 80
        }
        if indexPath.row == 5 {
            return 90
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecHeaderCell") as! SpecHeaderCell
            cell.titlab.text = "#\(number) Option"
            return cell
        }
        
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Option Simplified Chinese name", msgStr: dataModel.nameCn)
            }
            if indexPath.row == 2 {
                cell.setCellData(titStr: "Option Traditional Chinese name", msgStr: dataModel.nameHk)
            }
            if indexPath.row == 3 {
                cell.setCellData(titStr: "Option English name", msgStr: dataModel.nameEn)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.row == 1 {
                    self.dataModel.nameCn = text
                }
                if indexPath.row == 2 {
                    self.dataModel.nameHk = text
                }
                if indexPath.row == 3 {
                    self.dataModel.nameEn = text
                }
            }
            
            return cell
        }
        
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.titlab.text = "Option price"
            cell.setCellData(money: dataModel.price)
            cell.editeEndBlock = { [unowned self] (text) in
                
                self.dataModel.price = text == "" ? "0" : text
            }
            return cell
        }
        
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setCellData(titStr: "Option state", l_str: "On menu", r_Str: "Off menu", statusID: dataModel.statusId)

            cell.selectBlock = { [unowned self] (type) in
                self.dataModel.statusId = type
                self.table.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .none)
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
}

extension MenuDishAddOptionController {
    
    //保存
    private func saveAciton_Net() {
        //校验信息
        if dataModel.nameCn == "" {
            HUD_MB.showWarnig("Please fill in the simplified Chinese name!", onView: self.view)
            return
        }
        
        if dataModel.nameHk == "" {
            HUD_MB.showWarnig("Please fill in the traditional Chinese name!", onView: self.view)
            return
        }
        
        if dataModel.nameEn == "" {
            HUD_MB.showWarnig("Please fill in the English name!", onView: self.view)
            return
        }
        
//        if dataModel.price == 0 {
//            HUD_MB.showWarnig("Please fill in the price!", onView: self.view)
//            return
//        }
                
        if dataModel.statusId == "" {
            HUD_MB.showWarnig("Please select the available status of the Option!", onView: self.view)
            return
        }
        
        
        if dataModel.price == "" {
            dataModel.price = "0"
        }

        
        if isAdd {
            //添加选项
            if specID != "0" {
                self.dataModel.specId = specID
                HUD_MB.loading("", onView: view)
                HTTPTOOl.addSpecOption(model: dataModel).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.view)
                    
                    self.dataModel.updateModel()
                    let info: [String: Any] = ["opt": self.dataModel, "type": "add", "idx": self.number - 1]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: info)

                    self.navigationController?.popViewController(animated: true)
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                }).disposed(by: self.bag)
            } else {
                self.dataModel.updateModel()
                let info: [String: Any] = ["opt": self.dataModel, "type": "add", "idx": self.number - 1]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: info)
                self.navigationController?.popViewController(animated: true)
            }
        
        } else {
            ///编辑选项
            if specID != "0" {
                HUD_MB.loading("", onView: view)
                HTTPTOOl.editeSpecOption(model: dataModel).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.view)
                    //发送通知
                    self.dataModel.updateModel()
                    let info: [String: Any] = ["opt": self.dataModel, "type": "edite", "idx": self.number - 1]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: info)

                    self.navigationController?.popViewController(animated: true)
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                }).disposed(by: self.bag)
            } else {
                self.dataModel.updateModel()
                let info: [String: Any] = ["opt": self.dataModel, "type": "edite", "idx": self.number - 1]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: info)

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //删除选项
    private func deleteSpecOption_Net() {
        
        if specID != "0" {
            HUD_MB.loading("", onView: view)
            HTTPTOOl.deleteSpecOption(id: String(dataModel.optionId)).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                //发送通知
                self.dataModel.updateModel()
                let info: [String: Any] = ["opt": self.dataModel, "type": "delete", "idx": self.number - 1]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: info)

                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        } else {
            //发送通知
            self.dataModel.updateModel()
            let info: [String: Any] = ["opt": self.dataModel, "type": "delete", "idx": self.number - 1]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: info)
            self.navigationController?.popViewController(animated: true)
        }

    }
    
}
