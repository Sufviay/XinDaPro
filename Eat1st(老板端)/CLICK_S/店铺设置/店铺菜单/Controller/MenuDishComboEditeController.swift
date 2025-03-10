//
//  MenuDishComboEditeController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/26.
//

import UIKit
import RxSwift

class MenuDishComboEditeController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    var dishID: String = ""
    //var isAdd: Bool = false

    private var dataModel = DishDetailModel()
    
    private var up_DishPic: UIImage?
    private var up_DishDetailPic: UIImage?
    
    

    
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
        tableView.register(DishEditeTextViewCell.self, forCellReuseIdentifier: "DishEditeTextViewCell")
        tableView.register(DishEditePriceInPutCell.self, forCellReuseIdentifier: "DishEditePriceInPutCell")
        tableView.register(DishEditeClassifyCell.self, forCellReuseIdentifier: "DishEditeClassifyCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(DishEditeTagCell.self, forCellReuseIdentifier: "DishEditeTagCell")
        tableView.register(DishEditeImageCell.self, forCellReuseIdentifier: "DishEditeImageCell")
        tableView.register(DishEditeImageDetailCell.self, forCellReuseIdentifier: "DishEditeImageDetailCell")
        tableView.register(DishKuCunEditeCell.self, forCellReuseIdentifier: "DishKuCunEditeCell")
        tableView.register(DishDetailAddSpecCell.self, forCellReuseIdentifier: "DishDetailAddSpecCell")
    
        tableView.register(ComboNameCell.self, forCellReuseIdentifier: "ComboNameCell")
        tableView.register(ComboDishNameCell.self, forCellReuseIdentifier: "ComboDishNameCell")
        tableView.register(DishEditeChooseCell_Three.self, forCellReuseIdentifier: "DishEditeChooseCell_Three")
        return tableView
        
    }()
    
    //选择标签
    private lazy var tagView: DishSelectTagsView = {
        let view = DishSelectTagsView()
        
        view.confirmBlock = { [unowned self] (par) in
            self.dataModel.tagList = par as! [DishDetailTagModel]
            table.reloadData()
        }
        
        return view
    }()
    
    //选择分类
    private lazy var classifyView: DishSelectClassifyView = {
        let view = DishSelectClassifyView()
        
        view.confirmBlock = { [unowned self] (par) in
            let strArr = par as! [String]
            self.dataModel.classifyId = Int64(strArr[0]) ?? 0
            self.dataModel.classifyNameEn = strArr[1]
            self.dataModel.classifyNameHk = strArr[2]
            table.reloadData()
        }

        return view
    }()
    

    private lazy var cropVC: CropImageController = {
        let vc = CropImageController()
        
        vc.cropDoneBlock = { [unowned self] (img) in
            
            if vc.cropRatio == 1.0 {
                self.up_DishPic = img
                table.reloadData()
                
                self.uploadImg_Net(img: img!, type: "1")
            } else {
                self.up_DishDetailPic = img
                table.reloadData()
                self.uploadImg_Net(img: img!, type: "2")
            }
        }
        return vc
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Dish Edit"
        self.table.reloadData()
    }

    
    override func setViews() {
        setUpUI()
//        if !isAdd {
//            self.loadData_Net()
//        }
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
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataModel.comboList.count + 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 27
        } else {
            return dataModel.comboList[section - 1].comboDishesList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
                return 80
            }
            if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 19 || indexPath.row == 20 || indexPath.row == 21 {
                return 115
            }
            
            if indexPath.row == 8 {
                return 80
            }
            
            if indexPath.row == 9 {
                return 90
            }
            
            if indexPath.row == 10 {
                if dataModel.limitBuy == "1" {
                    return 100
                } else {
                    return 160
                }
            }
            
            if indexPath.row == 11 {
                return 90
            }
            
            if indexPath.row == 12 || indexPath.row == 13 {
                return 80
            }
            
            if indexPath.row == 14 || indexPath.row == 15 || indexPath.row == 16 || indexPath.row == 17 {
                return 90
            }
            
            if indexPath.row == 18 {
                return 80
            }
            if indexPath.row == 22 {
                return 90
            }
            if indexPath.row == 23 {
                return 90
            }
            if indexPath.row == 24 || indexPath.row == 25 {
                return 135
            }
            if indexPath.row == 26 {
                return 110
            }
            
        } else {
            
            if indexPath.row == 0 {
                return dataModel.comboList[indexPath.section - 1].name_h
            } else {
                return dataModel.comboList[indexPath.section - 1].comboDishesList[indexPath.row - 1].name_h
            }
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
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
                    cell.setCellData(titStr: "Serial number", msgStr: dataModel.dishesCode)
                }
                if indexPath.row == 4 {
                    cell.setCellData(titStr: "Bar code", msgStr: dataModel.dishesBarCode, isMust: false)
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
                        self.dataModel.dishesCode = text
                    }
                    if indexPath.row == 4 {
                        self.dataModel.dishesBarCode = text
                    }
                }
                
                return cell
            }
            
            if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 19 || indexPath.row == 20 || indexPath.row == 21 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeTextViewCell") as! DishEditeTextViewCell
                if indexPath.row == 5 {
                    cell.setCellData(titStr: "Simplified Chinese description", msgStr: dataModel.remarkCn, isMust: false)
                }
                if indexPath.row == 6 {
                    cell.setCellData(titStr: "Traditional Chinese description", msgStr: dataModel.remarkHk, isMust: false)
                }
                if indexPath.row == 7 {
                    cell.setCellData(titStr: "English description", msgStr: dataModel.remarkEn, isMust: false)
                }
                
                if indexPath.row == 19 {
                    cell.setCellData(titStr: "Chinese simplified allergen", msgStr: dataModel.allergenCn, isMust: true)
                }
                if indexPath.row == 20 {
                    cell.setCellData(titStr: "Chinese traditional allergen", msgStr: dataModel.allergenHk, isMust: true)
                }
                if indexPath.row == 21 {
                    cell.setCellData(titStr: "English allergen", msgStr: dataModel.allergenEn, isMust: true)
                }
                
                cell.editeEndBlock = { [unowned self] (text) in
                    if indexPath.row == 5 {
                        self.dataModel.remarkCn = text
                    }
                    if indexPath.row == 6 {
                        self.dataModel.remarkHk = text
                    }
                    if indexPath.row == 7 {
                        self.dataModel.remarkEn = text
                    }
                    if indexPath.row == 19 {
                        self.dataModel.allergenCn = text
                    }
                    if indexPath.row == 20 {
                        self.dataModel.allergenHk = text
                    }
                    if indexPath.row == 21 {
                        self.dataModel.allergenEn = text
                    }
                }
                        
                return cell
            }
            
            
            if indexPath.row == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                cell.setChooseCellData(titStr: "Print alias", l_str: "Enable", r_Str: "Disable", statusID: dataModel.printType)
            
                cell.selectBlock = { [unowned self] (status) in
                
                    dataModel.printType = status
                    table.reloadData()
                }
                return cell

            }
            
            if indexPath.row == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
                cell.setCellData(titStr: "Alias", msgStr: dataModel.printAlias, isMust: false)
                
                cell.editeEndBlock = { [unowned self] (text) in
                    dataModel.printAlias = text
                }
                return cell
            }
            
            
            if indexPath.row == 10 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishKuCunEditeCell") as! DishKuCunEditeCell
                cell.setCellData(type: dataModel.limitBuy, number: String(dataModel.limitNum))
                cell.clickTypeBlock = { [unowned self] (type) in
                    self.dataModel.limitBuy = type
                    table.reloadData()
                }
                
                cell.editeNumBlock = { [unowned self] (num) in
                    self.dataModel.limitNum = Int(num) ?? 0
                }
                return cell
            }
            
            if indexPath.row == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell_Three") as! DishEditeChooseCell_Three
                cell.setCellData(titStr: "Method of sale", l_str: "Delivery", m_str: "Dine-in", r_str: "All", statusID: dataModel.sellType)
                cell.selectBlock = { [unowned self] (type) in
                    self.dataModel.sellType = type
                    table.reloadData()
                }
                return cell
            }
            
            
            if indexPath.row == 12 || indexPath.row == 13 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
                if indexPath.row == 12 {
                    cell.setCellData(money: dataModel.deliPrice, titStr: "Delivery Price")
                }
                if indexPath.row == 13 {
                    cell.setCellData(money: dataModel.dinePrice, titStr: "Dine-in Price")
                }
                
                cell.editeEndBlock = { [unowned self] (text) in
                    
                    if indexPath.row == 12 {
                        self.dataModel.deliPrice = text
                    }
                    if indexPath.row == 13 {
                        self.dataModel.dinePrice = text
                    }
                }
                return cell
            }

            if indexPath.row == 14 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                    cell.setChooseCellData(titStr: "Buffet", l_str: "Enable", r_Str: "Disable", statusID: dataModel.buffetType)
                
                cell.selectBlock = { [unowned self] (status) in
                    
                    dataModel.buffetType = status
                    table.reloadData()
                }
                
                return cell
            }
            
            if indexPath.row == 15 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell_Three") as! DishEditeChooseCell_Three
                cell.setCellData(titStr: "Dishes kind", l_str: "Food", m_str: "Drink", r_str: "Milk tea", statusID: dataModel.dishesKind)
                
                cell.selectBlock = { [unowned self] (status) in
                
                    dataModel.dishesKind = status
                    table.reloadData()
                }
                return cell
            }

            if indexPath.row == 16 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                cell.setChooseCellData(titStr: "VAT", l_str: "Enable", r_Str: "Disable", statusID: dataModel.vatType)
            
                cell.selectBlock = { [unowned self] (status) in
                
                    dataModel.vatType = status
                    table.reloadData()
                }
                return cell
            }
            
            if indexPath.row == 17 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                cell.setChooseCellData(titStr: "Special offer", l_str: "Enable", r_Str: "Disable", statusID: dataModel.baleType)
            
                cell.selectBlock = { [unowned self] (status) in
                
                    dataModel.baleType = status
                    table.reloadData()
                }
                return cell
            }

            
            
            if indexPath.row == 18 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeClassifyCell") as! DishEditeClassifyCell
                let str = PJCUtil.getCurrentLanguage() == "en_GB" ? dataModel.classifyNameEn : dataModel.classifyNameHk
                cell.setCellData(c_msg: str)
                
                cell.selectBlock = { [unowned self] (_) in
                    ///选择分类
                    self.classifyView.selectID = String(dataModel.classifyId)
                    self.classifyView.appearAction()
                }
                
                return cell
            }
            
            if indexPath.row == 22  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                    cell.setChooseCellData(titStr: "Status", l_str: "Enable", r_Str: "Disable", statusID: dataModel.statusId)
                
                cell.selectBlock = { [unowned self] (status) in
                    ///点选上下架 和 折扣
                    self.dataModel.statusId = status
                    table.reloadData()
                }
                
                return cell

            }

            if indexPath.row == 23 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeTagCell") as! DishEditeTagCell
                cell.setCellData(modelArr: dataModel.tagList)
                
                cell.selectBlock = { [unowned self] (_) in
                    ///选择规格
                    self.tagView.selectArr = self.dataModel.tagList
                    self.tagView.appearAction()
                }
                
                cell.deleteBlock = { [unowned self] (par) in
                    ///删除规格
                    self.dataModel.tagList = par as! [DishDetailTagModel]
                    table.reloadData()
                }
                
                return cell
            }
            
            if indexPath.row == 24 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageCell") as! DishEditeImageCell
                cell.setCellData(titStr: "Dish picture", imgUrl: dataModel.showListUrl, picImage: up_DishPic)
        
                cell.selectImgBlock = { [unowned self] (img) in
                        
                    self.cropVC.cropImg = img
                    self.cropVC.cropRatio = 1
                    self.navigationController?.pushViewController(cropVC, animated: true)
                }
                
                return cell
            }
            
            if indexPath.row == 25 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageDetailCell") as! DishEditeImageDetailCell
                cell.setCellData(titStr: "Dish Detail picture", imgUrl: dataModel.showDetailUrl, picImage: up_DishDetailPic)
                
                cell.selectImgBlock = { [unowned self] (img) in
                    self.cropVC.cropImg = img
                    self.cropVC.cropRatio = 3 / 2
                    self.navigationController?.pushViewController(cropVC, animated: true)
                }
                return cell
            }
            
            if indexPath.row == 26 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailAddSpecCell") as! DishDetailAddSpecCell
                cell.inLab.text = "Add"
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComboNameCell") as! ComboNameCell
                cell.setCellData(num: indexPath.section, name1: dataModel.comboList[indexPath.section - 1].name1, name2: dataModel.comboList[indexPath.section - 1].name2)
                
                cell.clickBlock = { [unowned self] _ in
                    //编辑套餐
                    let nextVC = MenuComboEditSpecController()
                    nextVC.isAdd = false
                    nextVC.dataModel = dataModel.comboList[indexPath.section - 1]
                    nextVC.dishModel = dataModel
                    nextVC.idx = indexPath.section - 1
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComboDishNameCell") as! ComboDishNameCell
                cell.setCellData(name1: dataModel.comboList[indexPath.section - 1].comboDishesList[indexPath.row - 1].name1, name2: dataModel.comboList[indexPath.section - 1].comboDishesList[indexPath.row - 1].name2)
                return cell
            }
        }
    
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 26 {
                //添加套餐的规格
                let nextVC = MenuComboEditSpecController()
                nextVC.isAdd = true
                nextVC.dishModel = dataModel
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
    deinit {
        print("\(self.classForCoder)销毁")
    }
    

}


extension MenuDishComboEditeController {
    
    
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesDetail(id: dishID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            self.dataModel = DishDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            self.dataModel.updateModle()
            self.table.reloadData()
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //保存
    func saveAction_Net() {
       
//        ///校验信息
//        if dataModel.nameCn == "" {
//            HUD_MB.showWarnig("Please fill in the simplified Chinese name of the dish!", onView: self.view)
//            return
//        }
//        
//        if dataModel.nameHk == "" {
//            HUD_MB.showWarnig("Please fill in the traditional Chinese name of the dish!", onView: self.view)
//            return
//        }
//        
//        if dataModel.nameEn == "" {
//            HUD_MB.showWarnig("Please fill in the English name of the dish!", onView: self.view)
//            return
//        }
//        
//        if dataModel.dishesCode == "" {
//            HUD_MB.showWarnig("Please fill in the serial number of the dish!", onView: self.view)
//            return
//        }
//        
//        if dataModel.limitBuy == "2" {
//            if dataModel.limitNum == 0 {
//                HUD_MB.showWarnig("Place fill in the remaining quantity in stock!", onView: self.view)
//                return
//
//            }
//        }
//
//        if dataModel.sellType == "" {
//            HUD_MB.showWarnig("Please select the type of dishes sold!", onView: self.view)
//            return
//        }
//
//
//
//        if dataModel.sellType == "3" {
//            if dataModel.deliPrice == "0" || dataModel.deliPrice == "" {
//                HUD_MB.showWarnig("Please fill in the delivery price of the dishes!", onView: self.view)
//                return
//            }
//            if dataModel.dinePrice == "0" || dataModel.dinePrice == "" {
//                HUD_MB.showWarnig("Please fill in the price of the dishes!", onView: self.view)
//                return
//            }
//        }
//
//        if dataModel.sellType == "1" {
//            if dataModel.deliPrice == "0" || dataModel.deliPrice == "" {
//                HUD_MB.showWarnig("Please fill in the delivery price of the dishes!", onView: self.view)
//                return
//            }
//        }
//        if dataModel.sellType == "2" {
//            if dataModel.dinePrice == "0" || dataModel.dinePrice == "" {
//                HUD_MB.showWarnig("Please fill in the price of the dishes!", onView: self.view)
//                return
//            }
//
//        }
//
//        if dataModel.classifyId == 0 {
//            HUD_MB.showWarnig("Please fill in the food category!", onView: self.view)
//            return
//        }
//        
//        if dataModel.allergenCn == "" {
//            HUD_MB.showWarnig("Please fill in the allergen in Simplified Chinese!", onView: self.view)
//            return
//        }
//        
//        if dataModel.allergenHk == "" {
//            HUD_MB.showWarnig("Please fill in the allergen in traditional Chinese!", onView: self.view)
//            return
//        }
//        
//        if dataModel.allergenEn == "" {
//            HUD_MB.showWarnig("Please fill in the allergen in English!", onView: self.view)
//            return
//        }
//        
//        if dataModel.statusId == "" {
//            HUD_MB.showWarnig("Please select the available status of the dish!", onView: self.view)
//            return
//        }
//        
//        
//        
//        if dataModel.showListUrl == "" && self.dataModel.listUrl == "" {
//            HUD_MB.showWarnig("Please upload pictures of dishes!", onView: self.view)
//            return
//        }
//        
//        if dataModel.showDetailUrl == "" && self.dataModel.detailUrl == "" {
//            HUD_MB.showWarnig("Please upload pictures of dishes!", onView: self.view)
//            return
//        }
//        
//        if dataModel.comboList.count == 0 {
//            HUD_MB.showWarnig("Please add combo options!", onView: self.view)
//            return
//
//        }
//        
        
        
        HUD_MB.loading("", onView: view)
        
        //添加菜品
        dataModel.dishesType = "2"
        HTTPTOOl.addDish(model: dataModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.navigationController?.popViewController(animated: true)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)

        
//        if isAdd {
//            //添加菜品
//            dataModel.dishesType = "2"
//            HTTPTOOl.addDish(model: dataModel).subscribe(onNext: { [unowned self] (json) in
//                HUD_MB.dissmiss(onView: self.view)
//                self.navigationController?.popViewController(animated: true)
//            }, onError: { [unowned self] (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//            }).disposed(by: self.bag)
//
//        } else {
//    
//            HTTPTOOl.editeDish(model: dataModel).subscribe(onNext: {[unowned self] (json) in
//                HUD_MB.dissmiss(onView: self.view)
//                self.navigationController?.popViewController(animated: true)
//            }, onError: {[unowned self] (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//            }).disposed(by: self.bag)
//
//        }
    }
    
    
    
    private func uploadImg_Net(img: UIImage, type: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.uploadDishImages(images: [img]) { [unowned self] result in
            HUD_MB.dissmiss(onView: self.view)
            
            if type == "1" {
                self.dataModel.listUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
            }
            if type == "2" {
                self.dataModel.detailUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
            }
            
        } failure: { [unowned self] error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }

    }
    


}
