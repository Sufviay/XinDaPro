//
//  MenuGiftAddController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/28.
//

import UIKit
import RxSwift
import HandyJSON


class MenuGiftAddController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    var giftID: String = ""
    
    private var dataModel = GiftDetailModel()
    
    private var up_Pic: UIImage?
    
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
        tableView.register(DishEditeImageCell.self, forCellReuseIdentifier: "DishEditeImageCell")
        tableView.register(DishEditeClassifyCell.self, forCellReuseIdentifier: "DishEditeClassifyCell")
    
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
            self.table.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
        }

        return view
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Gift edit"
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            return 80
        }
        if indexPath.row == 4 {
            return 80
        }
        if indexPath.row == 5 {
            return 125
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
                cell.setCellData(titStr: "Serial number", msgStr: dataModel.giftCode)
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
                    self.dataModel.giftCode = text
                }
            }
    
            return cell
        }
        
        
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeClassifyCell") as! DishEditeClassifyCell
            let str = PJCUtil.getCurrentLanguage() == "en_GB" ? dataModel.classifyNameEn : dataModel.classifyNameHk
            cell.setCellData(c_msg: str)
            
            cell.selectBlock = { [unowned self] (_) in
                ///选择分类
                self.classifyView.selectID = String(dataModel.classifyId)
                self.classifyView.type = "fre"
                self.classifyView.appearAction()
            }
            
            return cell
        }
        
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeImageCell") as! DishEditeImageCell
            cell.setCellData(titStr: "Gift picture", imgUrl: dataModel.showImageUrl, picImage: up_Pic)


            cell.selectImgBlock = { [unowned self] (img) in
                
                let cropVC = CropImageController()
                cropVC.cropImg = img!
                cropVC.cropRatio = 1.0
                
                cropVC.cropDoneBlock = { [unowned self] (cImg) in
                    self.up_Pic = cImg!
                    self.table.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .none)
                    self.uploadImg_Net(img: cImg!)
                }
                
                self.navigationController?.pushViewController(cropVC, animated: true)
            }
            return cell
        }
        
        
        
        let cell = UITableViewCell()
        return cell
    }
    
}

extension MenuGiftAddController {
    //MARK: - 网络请求
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getGiftDetail(id: giftID).subscribe(onNext: { [self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            self.dataModel = GiftDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
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
//        if dataModel.giftCode == "" {
//            HUD_MB.showWarnig("Please fill in the serial number!", onView: self.view)
//            return
//        }
//        
//        if dataModel.classifyId == 0 {
//            HUD_MB.showWarnig("Please fill in the food category!", onView: self.view)
//            return
//        }
//        
//        if dataModel.showImageUrl == "" && self.dataModel.imageUrl == "" {
//            HUD_MB.showWarnig("Please upload picture!", onView: self.view)
//            return
//        }
//
        
        
        HUD_MB.loading("", onView: view)
        if isAdd {
            //添加菜品
            HTTPTOOl.addGift(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        } else {
            HTTPTOOl.editeGift(model: dataModel).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
    }
    
    
    private func uploadImg_Net(img: UIImage) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.uploadDishImages(images: [img]) { result in
            HUD_MB.dissmiss(onView: self.view)
            self.dataModel.imageUrl = result["data"].arrayValue[0]["imageUrl"].stringValue
        } failure: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }
    }
}
