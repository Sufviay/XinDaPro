//
//  MenuDishEditeController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/24.
//

import UIKit
import RxSwift



class MenuDishEditeController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()

    private var dataModel = DishDetailModel()
    
    var dishID: String = ""
    //菜品类型 1单品。2套餐
    var dishType: String = ""
    
    private var up_DishPic: UIImage?
    private var up_DishDetailPic: UIImage?
    
    var isAdd: Bool = false
        
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
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
        tableView.register(SelectThreeButCell.self, forCellReuseIdentifier: "SelectThreeButCell")
        
        tableView.register(DishDetailAddSpecCell.self, forCellReuseIdentifier: "DishDetailAddSpecCell")
        tableView.register(DishDetailSpecInfoCell.self, forCellReuseIdentifier: "DishDetailSpecInfoCell")
        tableView.register(DishEditeChooseCell_Three.self, forCellReuseIdentifier: "DishEditeChooseCell_Three")
        return tableView
        
    }()
    
    //选择标签
    private lazy var tagView: DishSelectTagsView = {
        let view = DishSelectTagsView()
        
        view.confirmBlock = { [unowned self] (par) in
            dataModel.tagList = par as! [DishDetailTagModel]
            table.reloadData()
        }
        
        return view
    }()
    
    //选择分类
    private lazy var classifyView: DishSelectClassifyView = {
        let view = DishSelectClassifyView()
        
        view.confirmBlock = { [unowned self] (par) in
            let strArr = par as! [String]
            dataModel.classifyId = Int64(strArr[0]) ?? 0
            dataModel.classifyNameEn = strArr[1]
            dataModel.classifyNameHk = strArr[2]
            table.reloadData()
        }

        return view
    }()
    

    private lazy var cropVC: CropImageController = {
        let vc = CropImageController()
        
        vc.cropDoneBlock = { [unowned self] (img) in
            
            if vc.cropRatio == 1.0 {
                up_DishPic = img
                table.reloadData()
                uploadImg_Net(img: img!, type: "1")
            } else {
                up_DishDetailPic = img
                table.reloadData()
                uploadImg_Net(img: img!, type: "2")
            }
        }
        return vc
    }()
    
    

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Dish Edit".local
        table.reloadData()
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
        
        return 28
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 27 {
            return dataModel.specList.count
        }
        
        if section == 26 {
            if !isAdd {
                return 0
            }
        }
        
        if section == 11 || section == 12 || section == 13 || section == 14 || section == 17 {
            if !isAdd {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 27 {
            return dataModel.specList[indexPath.row].spe_H
        }
        
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 {
            return 80
        }
        if indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 19 || indexPath.section == 20 || indexPath.section == 21 {
            return 115
        }
        
        
        if indexPath.section == 8 {
            return 90
        }
        
        if indexPath.section == 9 {
            return 80
        }
        
        
        if indexPath.section == 10 {
            if dataModel.limitBuy == "1" {
                return 100
            } else {
                return 160
            }
        }

        if indexPath.section == 11 {
            return 90
        }

        if indexPath.section == 12 || indexPath.section == 13 {
            return 80
        }
        
        if indexPath.section == 14 || indexPath.section == 15 || indexPath.section == 16 || indexPath.section == 17 {
            return 90
        }

        if indexPath.section == 18 {
            return 80
        }
        if indexPath.section == 22 {
            return 120
        }
        if indexPath.section == 23 {
            return 80
        }
        if indexPath.section == 24 || indexPath.section == 25 {
            return 135
        }
        if indexPath.section == 26 {
            return 110
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            
            if indexPath.section == 0 {
                cell.setCellData(titStr: "Simplified Chinese name".local, msgStr: dataModel.nameCn)
            }
            if indexPath.section == 1 {
                cell.setCellData(titStr: "Traditional Chinese name".local, msgStr: dataModel.nameHk)
            }
            if indexPath.section == 2 {
                cell.setCellData(titStr: "English name".local, msgStr: dataModel.nameEn)
            }
            if indexPath.section == 3 {
                cell.setCellData(titStr: "Serial number".local, msgStr: dataModel.dishesCode)
            }
            if indexPath.section == 4 {
                cell.setCellData(titStr: "Bar code".local, msgStr: dataModel.dishesBarCode, isMust: false)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.section == 0 {
                    dataModel.nameCn = text
                }
                if indexPath.section == 1 {
                    dataModel.nameHk = text
                }
                if indexPath.section == 2 {
                    dataModel.nameEn = text
                }
                if indexPath.section == 3 {
                    dataModel.dishesCode = text
                }
                if indexPath.section == 4 {
                    dataModel.dishesBarCode = text
                }
            }
            
            return cell
        }
        

        
        if indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 19 || indexPath.section == 20 || indexPath.section == 21 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeTextViewCell") as! DishEditeTextViewCell
            if indexPath.section == 5 {
                cell.setCellData(titStr: "Simplified Chinese description".local, msgStr: dataModel.remarkCn, isMust: false)
            }
            if indexPath.section == 6 {
                cell.setCellData(titStr: "Traditional Chinese description".local, msgStr: dataModel.remarkHk, isMust: false)
            }
            if indexPath.section == 7 {
                cell.setCellData(titStr: "English description".local, msgStr: dataModel.remarkEn, isMust: false)
            }
            
            if indexPath.section == 19 {
                cell.setCellData(titStr: "Simplified Chinese allergen".local, msgStr: dataModel.allergenCn, isMust: true)
            }
            if indexPath.section == 20 {
                cell.setCellData(titStr: "Traditional Chinese allergen".local, msgStr: dataModel.allergenHk, isMust: true)
            }
            if indexPath.section == 21 {
                cell.setCellData(titStr: "English allergen".local, msgStr: dataModel.allergenEn, isMust: true)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.section == 5 {
                    self.dataModel.remarkCn = text
                }
                if indexPath.section == 6 {
                    self.dataModel.remarkHk = text
                }
                if indexPath.section == 7 {
                    self.dataModel.remarkEn = text
                }
                if indexPath.section == 19 {
                    self.dataModel.allergenCn = text
                }
                if indexPath.section == 20 {
                    self.dataModel.allergenHk = text
                }
                if indexPath.section == 21 {
                    self.dataModel.allergenEn = text
                }
            }
                    
            return cell
        }
        
        if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Print alias".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.printType)
        
            cell.selectBlock = { [unowned self] (status) in
            
                dataModel.printType = status
                table.reloadData()
            }
            return cell

        }
        
        if indexPath.section == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            cell.setCellData(titStr: "Alias".local, msgStr: dataModel.printAlias, isMust: false)
            
            cell.editeEndBlock = { [unowned self] (text) in
                dataModel.printAlias = text
            }
            return cell
        }
        
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishKuCunEditeCell") as! DishKuCunEditeCell
            cell.setCellData(type: dataModel.limitBuy, number: String(dataModel.limitNum))
            cell.clickTypeBlock = { [unowned self] (type) in
                dataModel.limitBuy = type
                table.reloadData()
            }
            
            cell.editeNumBlock = { [unowned self] (num) in
                dataModel.limitNum = Int(num) ?? 0
            }
            return cell
        }
        
        if indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell_Three") as! DishEditeChooseCell_Three
            cell.setCellData(titStr: "Sell type".local, l_str: "Delivery".local, m_str: "Dine-in".local, r_str: "All".local, statusID: dataModel.sellType)
            cell.selectBlock = { [unowned self] (type) in
                dataModel.sellType = type
                table.reloadData()
            }
            return cell
        }
        
    
        if indexPath.section == 12 || indexPath.section == 13 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            if indexPath.section == 12 {
                cell.setCellData(money: dataModel.deliPrice, titStr: "Delivery Price".local)
            }
            if indexPath.section == 13 {
                cell.setCellData(money: dataModel.dinePrice, titStr: "Dine-in Price".local)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                
                if indexPath.section == 12 {
                    dataModel.deliPrice = text
                }
                if indexPath.section == 13 {
                    dataModel.dinePrice = text
                }
            }
            return cell
        }
        
        if indexPath.section == 14 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Buffet".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.buffetType)
        
            cell.selectBlock = { [unowned self] (status) in
            
                dataModel.buffetType = status
                table.reloadData()
            }
            return cell
        }

        if indexPath.section == 15 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell_Three") as! DishEditeChooseCell_Three
            cell.setCellData(titStr: "Dishes kind".local, l_str: "Food".local, m_str: "Drink".local, r_str: "Milk tea".local, statusID: dataModel.dishesKind)
        
            cell.selectBlock = { [unowned self] (status) in
            
                dataModel.dishesKind = status
                table.reloadData()
            }
            return cell
        }
        
        if indexPath.section == 16 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "VAT", l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.vatType)
        
            cell.selectBlock = { [unowned self] (status) in
            
                dataModel.vatType = status
                table.reloadData()
            }
            return cell
        }
        
        
        if indexPath.section == 17 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Special offer".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.baleType)
        
            cell.selectBlock = { [unowned self] (status) in
            
                dataModel.baleType = status
                table.reloadData()
            }
            return cell
        }

        
        if indexPath.section == 18 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeClassifyCell") as! DishEditeClassifyCell
            let str = PJCUtil.getCurrentLanguage() == "en_GB" ? dataModel.classifyNameEn : dataModel.classifyNameHk
            cell.setCellData(c_msg: str)
            
            cell.selectBlock = { [unowned self] (_) in
                ///选择分类
                classifyView.selectID = String(dataModel.classifyId)
                classifyView.appearAction()
            }
            
            return cell
        }
        
        if indexPath.section == 22 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectThreeButCell") as! SelectThreeButCell
            cell.setCellData(titStr: "Status".local, str1: "In stock".local, str2: "Sold out indefinitely".local, str3: "Sold out today".local, selectType: dataModel.statusId)
            
            cell.clickBlock = { [unowned self] (status) in
                ///点选上下架 和 折扣
                dataModel.statusId = status
                table.reloadData()
            }
            
            return cell

        }

        if indexPath.section == 23 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeTagCell") as! DishEditeTagCell
            cell.setCellData(modelArr: dataModel.tagList)
            
            cell.selectBlock = { [unowned self] (_) in
                ///选择规格
                self.tagView.selectArr = dataModel.tagList
                self.tagView.appearAction()
            }
            
            cell.deleteBlock = { [unowned self] (par) in
                ///删除规格
                dataModel.tagList = par as! [DishDetailTagModel]
                table.reloadData()
            }
            
            return cell
        }
        
        if indexPath.section == 24 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageCell") as! DishEditeImageCell
            cell.setCellData(titStr: "Dish picture".local, imgUrl: dataModel.showListUrl, picImage: up_DishPic)
    
            cell.selectImgBlock = { [unowned self] (img) in
                    
                cropVC.cropImg = img
                cropVC.cropRatio = 1
                navigationController?.pushViewController(cropVC, animated: true)
            }
            
            return cell
        }
        
        if indexPath.section == 25 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageDetailCell") as! DishEditeImageDetailCell
            cell.setCellData(titStr: "Dish detail picture".local, imgUrl: dataModel.showDetailUrl, picImage: up_DishDetailPic)
            
            cell.selectImgBlock = { [unowned self] (img) in
                cropVC.cropImg = img
                cropVC.cropRatio = 3 / 2
                navigationController?.pushViewController(cropVC, animated: true)
            }
            return cell
        }
        
        if indexPath.section == 26 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailAddSpecCell") as! DishDetailAddSpecCell
            return cell
        }


        if indexPath.section == 27 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailSpecInfoCell") as! DishDetailSpecInfoCell
            cell.setCellData(model: dataModel.specList[indexPath.row], idx: indexPath.row + 1)
            
            cell.clickEditeSpecBlock = { [unowned self] (type) in
                
                ///编辑规格
                let nextVC = MenuDishAddSpecController()
                nextVC.dataModel = self.dataModel.specList[indexPath.row]
                nextVC.dishModel = self.dataModel
                nextVC.number = indexPath.row + 1
                nextVC.isAdd = false
                navigationController?.pushViewController(nextVC, animated: true)
            }
            
            cell.clickEditeOptionBlock = { [unowned self] (idx) in
                ///编辑选项
                let nextVC = MenuDishAddOptionController()
                nextVC.dataModel = self.dataModel.specList[indexPath.row].optionList[idx]
                nextVC.curSpecModel = self.dataModel.specList[indexPath.row]
                nextVC.dishModel = self.dataModel
                nextVC.number = idx + 1
                nextVC.isAdd = false
                navigationController?.pushViewController(nextVC, animated: true)
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 26 {
            ///添加规格
            let nextVC = MenuDishAddSpecController()
            nextVC.isAdd = true
            nextVC.dishModel = dataModel
            nextVC.number = dataModel.specList.count + 1
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    deinit {
        print("\(self.classForCoder)销毁")
    }
    

}


extension MenuDishEditeController {
    
    
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesDetail(id: dishID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            dataModel = DishDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            dataModel.updateModle()
            table.reloadData()
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //保存
    func saveAction_Net() {
        
        HUD_MB.loading("", onView: view)
        if isAdd {
            //添加菜品
            dataModel.dishesType = dishType
            HTTPTOOl.addDish(model: dataModel).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        } else {
            HTTPTOOl.editeDish(model: dataModel).subscribe(onNext: {[unowned self] (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: {[unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        }
    }
    
    
    
    private func uploadImg_Net(img: UIImage, type: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.uploadDishImages(images: [img]) { [unowned self] result in
            HUD_MB.dissmiss(onView: self.view)
            
            if type == "1" {
                dataModel.listUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
            }
            if type == "2" {
                dataModel.detailUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
            }
            
        } failure: { [unowned self] error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }
    }
}
