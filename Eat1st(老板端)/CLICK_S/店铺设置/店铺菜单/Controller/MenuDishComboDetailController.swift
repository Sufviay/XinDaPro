//
//  MenuDishComboDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/21.
//

import UIKit
import RxSwift

class MenuDishComboDetailController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource , SystemAlertProtocol {

    private let bag = DisposeBag()
    
    var dishID: String = ""
    
    var dishModel = DishDetailModel()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_delete"), for: .normal)
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

        tableView.register(DishDetailEditeCell.self, forCellReuseIdentifier: "DishDetailEditeCell")
        tableView.register(DishDetailMsgCell.self, forCellReuseIdentifier: "DishDetailMsgCell")
        tableView.register(DishDetailPictureCell.self, forCellReuseIdentifier: "DishDetailPictureCell")
        tableView.register(DishListPictureCell.self, forCellReuseIdentifier: "DishListPictureCell")
        tableView.register(DishDetailAddSpecCell.self, forCellReuseIdentifier: "DishDetailAddSpecCell")
        tableView.register(ComboNameCell.self, forCellReuseIdentifier: "ComboNameCell")
        tableView.register(ComboDishNameCell.self, forCellReuseIdentifier: "ComboDishNameCell")
        tableView.register(DishDetailKuCunCell.self, forCellReuseIdentifier: "DishDetailKuCunCell")
        tableView.register(DishDetailPriceCell.self, forCellReuseIdentifier: "DishDetailPriceCell")
        return tableView
        
    }()
    


    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Dish detail"
        self.loadData_Net()
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
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickRightAction() {
        //删除
        self.showSystemChooseAlert("Alert", "Delete or not?", "YES", "NO") { [unowned self] in
            self.deleteDish_Net()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dishModel.comboList.count + 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 22
        } else {
            return dishModel.comboList[section - 1].comboDishesList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let h1 = dishModel.dishName1.getTextHeigh(BFONT(17), S_W - 120)
                let h2 = dishModel.dishName2.getTextHeigh(SFONT(15), S_W - 120)
                return 25 + 15 + h1 + h2
                
            }
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13 || indexPath.row == 14 ||  indexPath.row == 17  {
                return 66
            }
            
            if indexPath.row == 3 {
                let h = dishModel.desStr.getTextHeigh(SFONT(14), S_W - 80)
                return h + 50
            }
            
            
            if indexPath.row == 5 {
                let h = dishModel.aliasStr.getTextHeigh(SFONT(14), S_W - 80)
                return h + 50
            }
            
            if indexPath.row == 15 {
                let h = dishModel.classifyStr.getTextHeigh(SFONT(14), S_W - 80)
                return h + 50
            }
            if indexPath.row == 16 {
                let h = dishModel.allergenStr.getTextHeigh(SFONT(14), S_W - 80)
                return h + 50
            }
            
            if indexPath.row == 18 {
                let h = dishModel.tagsStr.getTextHeigh(SFONT(14), S_W - 80)
                return h + 50
            }
            
            if indexPath.row == 19 {
                return 110
            }
            
            if indexPath.row == 20 {
                return 135
            }
            if indexPath.row == 21 {
                return 110
            }
        } else {
            if indexPath.row == 0 {
                return dishModel.comboList[indexPath.section - 1].name_h
            } else {
                return dishModel.comboList[indexPath.section - 1].comboDishesList[indexPath.row - 1].name_h
            }
        }
        
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailEditeCell") as! DishDetailEditeCell
                cell.setCellData(name1: dishModel.dishName1, name2: dishModel.dishName2)
                cell.editeBlock = { [unowned self] (_) in
                    //进入编辑菜品页面
                    let nextVC = MenuDishEditeController()
                    nextVC.dishID = self.dishID
                    nextVC.isAdd = false
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Serial number", msgStr: dishModel.dishesCode)
                return cell
            }
            
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Bar code", msgStr: dishModel.dishesBarCode)
                return cell
            }
            
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Description", msgStr: dishModel.desStr)
                return cell
            }
            
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                let str = dishModel.printType == "2" ? "Enable" : " Disable"
                cell.setCellData(titStr: "Print alias", msgStr: str)
                return cell
            }
            
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Alias", msgStr: dishModel.aliasStr)
                return cell
            }
            
            
            if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailKuCunCell") as! DishDetailKuCunCell
                cell.setCellData(type: dishModel.limitBuy, num: String(dishModel.limitNum))
                return cell
            }
            
            if indexPath.row == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                
                var msg = ""
                if dishModel.sellType == "1" {
                    msg = "Delivery"
                }
                if dishModel.sellType == "2" {
                    msg = "Dine-in"
                }
                if dishModel.sellType == "3" {
                    msg = "All"
                }
                
                cell.setCellData(titStr: "Method of sale", msgStr: msg)
                return cell

            }
            
            
            if indexPath.row == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                
                var msg = ""
                if dishModel.buffetType == "1" {
                    msg = "Disable"
                }
                if dishModel.buffetType == "2" {
                    msg = "Enable"
                }
                
                cell.setCellData(titStr: "Buffet", msgStr: msg)
                return cell

            }


            if indexPath.row == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailPriceCell") as! DishDetailPriceCell
                cell.setCellData(model: dishModel, type: "1")
                return cell
            }
            if indexPath.row == 10 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailPriceCell") as! DishDetailPriceCell
                cell.setCellData(model: dishModel, type: "2")
                return cell
            }
            
            if indexPath.row == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                var msg = ""
                if dishModel.giveOne == "1" {
                    msg = "Disable"
                } else {
                    msg = "Enable"
                }
                cell.setCellData(titStr: "Buy one get one free", msgStr: msg)
                return cell
            }
            
            if indexPath.row == 12 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                var msg = ""
                if dishModel.dishesKind == "1" {
                    msg = "Food"
                } else if dishModel.dishesKind == "2" {
                    msg = "Drink"
                } else  {
                    msg = "Milk tea"
                }
                cell.setCellData(titStr: "Dishes kind", msgStr: msg)
                return cell

            }
            
            if indexPath.row == 13 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                var msg = ""
                if dishModel.vatType == "1" {
                    msg = "Disable"
                } else {
                    msg = "Enable"
                }
                cell.setCellData(titStr: "VAT", msgStr: msg)
                return cell

            }

            
            if indexPath.row == 14 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                var msg = ""
                if dishModel.baleType == "1" {
                    msg = "Disable"
                } else {
                    msg = "Enable"
                }
                cell.setCellData(titStr: "Special offer", msgStr: msg)
                return cell

            }


            if indexPath.row == 15 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Category", msgStr: dishModel.classifyStr)
                return cell
            }
            
            if indexPath.row == 16 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Allergen", msgStr: dishModel.allergenStr)
                return cell
            }
            
            if indexPath.row == 17 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                var msg = ""
                if dishModel.statusId == "1" {
                    msg = "Enable"
                } else {
                    msg = "Disable"
                }
                cell.setCellData(titStr: "Status", msgStr: msg)
                return cell
            }
            
            if indexPath.row == 18 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
                cell.setCellData(titStr: "Food tags", msgStr: dishModel.tagsStr)
                return cell
            }

            if indexPath.row == 19 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishListPictureCell") as! DishListPictureCell
                cell.setCellData(titStr: "Dish picture", picUrl: dishModel.showListUrl)
                return cell
            }
            
            if indexPath.row == 20 {
                let cell = table.dequeueReusableCell(withIdentifier: "DishDetailPictureCell") as! DishDetailPictureCell
                cell.setCellData(picUrl: dishModel.showDetailUrl)
                return cell
            }
            if indexPath.row == 21 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailAddSpecCell") as! DishDetailAddSpecCell
                cell.inLab.text = "Add"
                return cell
            }
        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComboNameCell") as! ComboNameCell
                cell.setCellData(num: indexPath.section, name1: dishModel.comboList[indexPath.section - 1].name1, name2: dishModel.comboList[indexPath.section - 1].name2)
                
                cell.clickBlock = { [unowned self] _ in
                    //编辑套餐
                    let nextVC = MenuComboEditSpecController()
                    nextVC.dishModel = self.dishModel
                    nextVC.dataModel = self.dishModel.comboList[indexPath.section - 1]
                    nextVC.isSave = true
                    nextVC.isAdd = false
                    nextVC.idx = indexPath.section - 1
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComboDishNameCell") as! ComboDishNameCell
                cell.setCellData(name1: dishModel.comboList[indexPath.section - 1].comboDishesList[indexPath.row - 1].name1, name2: dishModel.comboList[indexPath.section - 1].comboDishesList[indexPath.row - 1].name2)
                return cell
            }
            
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 21 {
                ///添加套餐
                let nextVC = MenuComboEditSpecController()
                nextVC.isAdd = true
                nextVC.isSave = true
                nextVC.dishModel = dishModel
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}


extension MenuDishComboDetailController {
    
    //MARK: - 网络请求
    
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesDetail(id: dishID).subscribe(onNext: { [self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.dishModel = DishDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            self.dishModel.updateModle()
            print(self.dishModel)
            self.table.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 删除菜品
    private func deleteDish_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteDish(id: dishID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.navigationController?.popViewController(animated: true)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}



