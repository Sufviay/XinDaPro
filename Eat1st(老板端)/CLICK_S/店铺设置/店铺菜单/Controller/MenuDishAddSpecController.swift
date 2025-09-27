//
//  MenuDishAddSpecController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/23.
//

import UIKit
import RxSwift


class MenuDishAddSpecController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    
    private let bag = DisposeBag()
        
    var dataModel = DishDetailSpecModel()
    
    var dishModel = DishDetailModel()
    
    var number = 0
    
    var isAdd: Bool = false
    var isSave: Bool = false
    
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

        tableView.register(SpecHeaderCell.self, forCellReuseIdentifier: "SpecHeaderCell")
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(OptionHeaderCell.self, forCellReuseIdentifier: "OptionHeaderCell")
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        tableView.register(OptionHeaderEditeCell.self, forCellReuseIdentifier: "OptionHeaderEditeCell")
        tableView.register(DishDetailOptionNameCell.self, forCellReuseIdentifier: "DishDetailOptionNameCell")
        tableView.register(DishDetailOptionPriceCell.self, forCellReuseIdentifier: "DishDetailOptionPriceCell")
        tableView.register(DishDetailOptionMsgCell.self, forCellReuseIdentifier: "DishDetailOptionMsgCell")
        
        return tableView
        
    }()
    
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, MAINCOLOR, TIT_2, .clear)
        but.layer.cornerRadius = 14
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        return but
    }()

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Edit specification".local
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
        self.showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) {
            self.deleteSpec_Net()
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


    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.optionList.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 60
            }
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
                return 80
            }
            if indexPath.row == 4 || indexPath.row == 5 {
                return 90
            }
            
            if indexPath.row == 6 {
                return 50
            }
            
            if indexPath.row == 7 {
                return 100
            }
        } else {
            if indexPath.row == 0 {
                return 45
            }
            if indexPath.row == 1 {
                return dataModel.optionList[indexPath.section - 1].name_h
            }
            if indexPath.row == 2 {
                return 70
            }
            
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpecHeaderCell") as! SpecHeaderCell
                cell.titlab.text = "#\(number) \("Specification".local)"
                return cell
            }
            
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
                if indexPath.row == 1 {
                    cell.setCellData(titStr: "Simplified Chinese name".local, msgStr: dataModel.nameCn)
                }
                if indexPath.row == 2 {
                    cell.setCellData(titStr: "Traditional Chinese name".local, msgStr: dataModel.nameHk)
                }
                if indexPath.row == 3 {
                    cell.setCellData(titStr: "English name".local, msgStr: dataModel.nameEn)
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
            
            if indexPath.row == 4 || indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                if indexPath.row == 4 {
                    cell.setChooseCellData(titStr: "Choose".local, l_str: "Required".local, r_Str: "Optional".local, statusID: dataModel.required)
                }
                
                if indexPath.row == 5 {
                    cell.setChooseCellData(titStr: "Multi-select".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.multiple)
                }
                
                
                cell.selectBlock = { [unowned self] (type) in
                    if indexPath.row == 4 {
                        self.dataModel.required = type
                        self.table.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
                    }
                    
                    if indexPath.row == 5 {
                        self.dataModel.multiple = type
                        self.table.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .none)
                    }
                    
                }
                
                return cell
            }
            if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OptionHeaderCell") as! OptionHeaderCell
                return cell
            }
            if indexPath.row == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! AddItemCell
                cell.inLab.text = "Add options".local
                return cell
            }
                        
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionHeaderEditeCell") as! OptionHeaderEditeCell
            cell.setCellData(number: indexPath.section)
            
            cell.clickBlock = { [unowned self] (_) in
                //编辑规格选项
                let nextVC = MenuDishAddOptionController()
                nextVC.dataModel = self.dataModel.optionList[indexPath.section - 1]
                nextVC.curSpecModel = self.dataModel
                nextVC.dishModel = self.dishModel
                nextVC.isAdd = false
                nextVC.number = indexPath.section
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailOptionNameCell") as! DishDetailOptionNameCell
            cell.setCellData(model: dataModel.optionList[indexPath.section - 1])
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailOptionPriceCell") as! DishDetailOptionPriceCell
            
            let price = dataModel.optionList[indexPath.section - 1].price
            cell.setCellData(price: price)
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 7 {
                //添加选项
                let nextVC = MenuDishAddOptionController()
                nextVC.dishModel = dishModel
                nextVC.curSpecModel = dataModel
                nextVC.isAdd = true
                nextVC.number = dataModel.optionList.count + 1
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    deinit {
        
        print("\(self.classForCoder)销毁")
        
    }

}


extension MenuDishAddSpecController {
    
    //保存
    private func saveAciton_Net() {
        //校验信息
        if dataModel.nameCn == "" {
            HUD_MB.showWarnig("Please fill in the simplified Chinese name!".local, onView: self.view)
            return
        }
        
        if dataModel.nameHk == "" {
            HUD_MB.showWarnig("Please fill in the traditional Chinese name!".local, onView: self.view)
            return
        }
        
        if dataModel.nameEn == "" {
            HUD_MB.showWarnig("Please fill in the English name!".local, onView: self.view)
            return
        }
                
//        if dataModel.statusId == "" {
//            HUD_MB.showWarnig("Please select the available status of the specifications!".local, onView: self.view)
//            return
//        }
        
        if dataModel.required == "" {
            HUD_MB.showWarnig("Please select whether it is mandatory!".local, onView: self.view)
            return
        }
        
        if dataModel.multiple == "" {
            HUD_MB.showWarnig("Whether you can select both!".local, onView: self.view)
            return
        }
        
        if dataModel.optionList.count == 0 {
            HUD_MB.showWarnig("Please add an optio!".local, onView: self.view)
            return
        }
        

        HUD_MB.loading("", onView: view)
        
        dataModel.updateModel()
        
        if isAdd {
            dishModel.specList.append(dataModel)
        }
        
        if isSave {
            HTTPTOOl.specDoAddOrUpdate(model: dishModel).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }

    
    //删除规格
    private func deleteSpec_Net() {
        
        dishModel.specList.remove(at: number - 1)
        HUD_MB.loading("", onView: view)
        HTTPTOOl.specDoAddOrUpdate(model: dishModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}
