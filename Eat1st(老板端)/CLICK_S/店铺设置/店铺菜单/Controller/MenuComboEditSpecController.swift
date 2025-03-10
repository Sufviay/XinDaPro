//
//  MenuComboEditSpecController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/26.
//

import UIKit
import RxSwift

class MenuComboEditSpecController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    var dishModel = DishDetailModel()
    
    var dataModel = DishDetailComboModel()
    
    var idx: Int = 0
    
    var isAdd: Bool = false
    
    var isSave: Bool = false {
        didSet {
            if isSave {
                self.saveBut.setTitle("Save", for: .normal)
            } else {
                self.saveBut.setTitle("Confirm", for: .normal)
            }
        }
    }

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
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        tableView.register(SpecHeaderEditeCell.self, forCellReuseIdentifier: "SpecHeaderEditeCell")
        tableView.register(ComboDishNameCell.self, forCellReuseIdentifier: "ComboDishNameCell")
        return tableView
        
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
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Edit"
        self.rightBut.isHidden = isAdd
        self.table.reloadData()
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
        self.showSystemChooseAlert("Alert", "Delete or not?", "YES", "NO") { [unowned self] in
            self.deleteAction_Net()
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
        
        
        if dataModel.comboDishesList.count == 0 {
            HUD_MB.showWarnig("Please add dishes!", onView: self.view)
            return
        }
        
        dataModel.updateModel()
        
        if isAdd {
            dishModel.comboList.append(dataModel)
        }

        if isSave {
            //调用接口
            HUD_MB.loading("", onView: self.view)
            HTTPTOOl.comboDoAddOrUpdate(model: dishModel).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.showSuccess("Success", onView: self.view)
                DispatchQueue.main.after(time: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func deleteAction_Net() {
        
        if isSave {
            if dishModel.comboList.count == 1 {
                HUD_MB.showWarnig("Keep at least one!", onView: self.view)
                return
            }
            self.dishModel.comboList.remove(at: idx)

            HUD_MB.loading("", onView: self.view)
            
            HUD_MB.loading("", onView: self.view)
            HTTPTOOl.comboDoAddOrUpdate(model: dishModel).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.showSuccess("Success", onView: self.view)
                DispatchQueue.main.after(time: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        } else {
            self.dishModel.comboList.remove(at: idx)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if dataModel.comboDishesList.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return dataModel.comboDishesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
                return 80
            }
            if indexPath.row == 3 {
                return 50
            }
        } else {
            return dataModel.comboDishesList[indexPath.row].name_h
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
                if indexPath.row == 0 {
                    cell.setCellData(titStr: "Simplified Chinese name", msgStr: dataModel.nameCn)
                }
                if indexPath.row == 1 {
                    cell.setCellData(titStr: "Traditional Chinese name", msgStr: dataModel.nameHk)
                }
                if indexPath.row == 2 {
                    cell.setCellData(titStr: "English name", msgStr: dataModel.nameHk)
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
                }
                
                return cell
            }
            
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpecHeaderEditeCell") as! SpecHeaderEditeCell
                cell.titlab.text = "Dishes"
                cell.clickBlock = { [unowned self] _ in
                    //编辑套餐的菜品
                    let nextVC = MenuComboEditDishController()
                    nextVC.comboModel = self.dataModel
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }
                return cell
            }
                        
        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ComboDishNameCell") as! ComboDishNameCell
            cell.setCellData(name1: dataModel.comboDishesList[indexPath.row].name1, name2: dataModel.comboDishesList[indexPath.row].name2)
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            if indexPath.row == 3 {
//                //编辑套菜的菜品
//                let nextVC = MenuComboEditDishController()
//                nextVC.comboModel = dataModel
//                self.navigationController?.pushViewController(nextVC, animated: true)
//            }
//        }
    }

    
    deinit {
        
        print("\(self.classForCoder)销毁")
    }

}
