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
    
        return tableView
        
    }()
    
    //选择标签
    private lazy var tagView: DishSelectTagsView = {
        let view = DishSelectTagsView()
        
        view.confirmBlock = { [unowned self] (par) in
            self.dataModel.tagList = par as! [DishDetailTagModel]
            self.table.reloadRows(at: [IndexPath(row: 14, section: 0)], with: .none)
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
            self.table.reloadRows(at: [IndexPath(row: 9, section: 0)], with: .none)
        }

        return view
    }()
    

    private lazy var cropVC: CropImageController = {
        let vc = CropImageController()
        
        vc.cropDoneBlock = { [unowned self] (img) in
            
            if vc.cropRatio == 1.0 {
                self.up_DishPic = img
                self.table.reloadRows(at: [IndexPath(row: 15, section: 0)], with: .none)
                self.uploadImg_Net(img: img!, type: "1")
            } else {
                self.up_DishDetailPic = img
                self.table.reloadRows(at: [IndexPath(row: 16, section: 0)], with: .none)
                self.uploadImg_Net(img: img!, type: "2")
            }
        }
        return vc
    }()
    
    

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Details"
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            return 80
        }
        if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 {
            return 115
        }
        if indexPath.row == 7 {
            if dataModel.limitBuy == "1" {
                return 110
            } else {
                return 160
            }
        }
        
        
        if indexPath.row == 8 {
            return 80
        }
        if indexPath.row == 9 {
            return 80
        }
        if indexPath.row == 13 {
            return 90
        }
        if indexPath.row == 14 {
            return 90
        }
        if indexPath.row == 15 || indexPath.row == 16 {
            return 125
        }
        
        return 40
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
                cell.setCellData(titStr: "Serial number", msgStr: dataModel.dishesCode)
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
            }
            
            return cell
        }
        
        if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeTextViewCell") as! DishEditeTextViewCell
            if indexPath.row == 4 {
                cell.setCellData(titStr: "Simplified Chinese description", msgStr: dataModel.remarkCn, isMust: false)
            }
            if indexPath.row == 5 {
                cell.setCellData(titStr: "Traditional Chinese description", msgStr: dataModel.remarkHk, isMust: false)
            }
            if indexPath.row == 6 {
                cell.setCellData(titStr: "English description", msgStr: dataModel.remarkEn, isMust: false)
            }
            
            if indexPath.row == 10 {
                cell.setCellData(titStr: "Chinese simplified allergen", msgStr: dataModel.allergenCn, isMust: true)
            }
            if indexPath.row == 11 {
                cell.setCellData(titStr: "Chinese traditional allergen", msgStr: dataModel.allergenHk, isMust: true)
            }
            if indexPath.row == 12 {
                cell.setCellData(titStr: "English allergen", msgStr: dataModel.allergenEn, isMust: true)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.row == 4 {
                    self.dataModel.remarkCn = text
                }
                if indexPath.row == 5 {
                    self.dataModel.remarkHk = text
                }
                if indexPath.row == 6 {
                    self.dataModel.remarkEn = text
                }
                if indexPath.row == 10 {
                    self.dataModel.allergenCn = text
                }
                if indexPath.row == 11 {
                    self.dataModel.allergenHk = text
                }
                if indexPath.row == 12 {
                    self.dataModel.allergenEn = text
                }
            }
                    
            return cell
        }
        
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishKuCunEditeCell") as! DishKuCunEditeCell
            cell.setCellData(type: dataModel.limitBuy, number: String(dataModel.limitNum))
            cell.clickTypeBlock = { [unowned self] (type) in
                self.dataModel.limitBuy = type
                self.table.reloadRows(at: [IndexPath(row: 7, section: 0)], with: .none)
            }
            
            cell.editeNumBlock = { [unowned self] (num) in
                self.dataModel.limitNum = Int(num) ?? 0
            }
            return cell
        }
        
        
        if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.setCellData(money: dataModel.price)
            cell.editeEndBlock = { [unowned self] (text) in
                self.dataModel.price = text == "" ? "0" : text
            }
            return cell
        }
        if indexPath.row == 9 {
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
        
        if indexPath.row == 13  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
                cell.setCellData(titStr: "Dishes state", l_str: "On menu", r_Str: "Off menu", statusID: dataModel.statusId)
            
            cell.selectBlock = { [unowned self] (status) in
                ///点选上下架 和 折扣
                self.dataModel.statusId = status
                self.table.reloadRows(at: [IndexPath(row: 13, section: 0)], with: .none)
            }
            
            return cell

        }

        if indexPath.row == 14 {
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
                self.table.reloadRows(at: [IndexPath(row: 14, section: 0)], with: .none)
            }
            
            return cell
        }
        
        if indexPath.row == 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageCell") as! DishEditeImageCell
            cell.setCellData(titStr: "Dish picture", imgUrl: dataModel.showListUrl, picImage: up_DishPic)
    
            cell.selectImgBlock = { [unowned self] (img) in
                    
                self.cropVC.cropImg = img
                self.cropVC.cropRatio = 1
                self.navigationController?.pushViewController(cropVC, animated: true)
            }
            
            return cell
        }
        
        if indexPath.row == 16 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageDetailCell") as! DishEditeImageDetailCell
            cell.setCellData(titStr: "Dish Details picture", imgUrl: dataModel.showDetailUrl, picImage: up_DishDetailPic)
            
            cell.selectImgBlock = { [unowned self] (img) in
                self.cropVC.cropImg = img
                self.cropVC.cropRatio = 3 / 2
                self.navigationController?.pushViewController(cropVC, animated: true)
            }
            return cell
        }
        
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    deinit {
        print("bbbbbbbbbbbbbbbb")
    }
    

}


extension MenuDishEditeController {
    
    
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesDetail(id: dishID).subscribe(onNext: { [self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            self.dataModel = DishDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            self.dataModel.updateModle()
            self.table.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //保存
    func saveAction_Net() {
       
        ///校验信息
        if dataModel.nameCn == "" {
            HUD_MB.showWarnig("Please fill in the simplified Chinese name of the dish!", onView: self.view)
            return
        }
        
        if dataModel.nameHk == "" {
            HUD_MB.showWarnig("Please fill in the traditional Chinese name of the dish!", onView: self.view)
            return
        }
        
        if dataModel.nameEn == "" {
            HUD_MB.showWarnig("Please fill in the English name of the dish!", onView: self.view)
            return
        }
        
        if dataModel.dishesCode == "" {
            HUD_MB.showWarnig("Please fill in the serial number of the dish!", onView: self.view)
            return
        }
        
        if dataModel.price == "0" || dataModel.price == "" {
            HUD_MB.showWarnig("Please fill in the price of the dishes!", onView: self.view)
            return
        }
        
        if dataModel.classifyId == 0 {
            HUD_MB.showWarnig("Please fill in the food category!", onView: self.view)
            return
        }
        
        if dataModel.allergenCn == "" {
            HUD_MB.showWarnig("Please fill in the allergen in Simplified Chinese!", onView: self.view)
            return
        }
        
        if dataModel.allergenHk == "" {
            HUD_MB.showWarnig("Please fill in the allergen in traditional Chinese!", onView: self.view)
            return
        }
        
        if dataModel.allergenEn == "" {
            HUD_MB.showWarnig("Please fill in the allergen in English!", onView: self.view)
            return
        }
        
        if dataModel.statusId == "" {
            HUD_MB.showWarnig("Please select the available status of the dish!", onView: self.view)
            return
        }
        
        if dataModel.limitBuy == "2" {
            if dataModel.limitNum == 0 {
                HUD_MB.showWarnig("Place fill in the remaining quantity in stock!", onView: self.view)
                return

            }
        }
        
        
        if dataModel.showListUrl == "" && self.dataModel.listUrl == "" {
            HUD_MB.showWarnig("Please upload pictures of dishes!", onView: self.view)
            return
        }
        
        if dataModel.showDetailUrl == "" && self.dataModel.detailUrl == "" {
            HUD_MB.showWarnig("Please upload pictures of dishes!", onView: self.view)
            return
        }
        
        HUD_MB.loading("", onView: view)
        if isAdd {
            //添加菜品
            HTTPTOOl.addDish(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        } else {
            HTTPTOOl.editeDish(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        }
    }
    
    
    
    private func uploadImg_Net(img: UIImage, type: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.uploadDishImages(images: [img]) { result in
            HUD_MB.dissmiss(onView: self.view)
            
            if type == "1" {
                self.dataModel.listUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
            }
            if type == "2" {
                self.dataModel.detailUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
            }
            
        } failure: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }

    }
    
    
}
