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
    
    var dishModel = DishDetailModel()
    ///当前的规格
    var curSpecModel = DishDetailSpecModel()
    var dataModel = DishDetailOptionModel()
    
    var number = 0
    var isAdd = false
    
    
    ///如果是从菜品详情页面进入编辑选项页面直接进行保存
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
        if isAdd {
            self.biaoTiLab.text = "Option add"
        } else {
            self.biaoTiLab.text = "Option edit"
        }
        
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
        return 5
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
                cell.setCellData(titStr: "Simplified Chinese name", msgStr: dataModel.nameCn)
            }
            if indexPath.row == 2 {
                cell.setCellData(titStr: "Traditional Chinese name", msgStr: dataModel.nameHk)
            }
            if indexPath.row == 3 {
                cell.setCellData(titStr: "English name", msgStr: dataModel.nameEn)
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
            cell.titlab.text = "Price"
            cell.setCellData(money: dataModel.price, titStr: "Price")
            cell.editeEndBlock = { [unowned self] (text) in
                
                self.dataModel.price = text == "" ? "0" : text
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
        
        if dataModel.price == "" {
            dataModel.price = "0"
        }
        
        
        self.dataModel.updateModel()
        
        if isSave {
            //调用接口直接更新
            self.doUpdateAction_Net()
            
        } else {
            if isAdd {
                curSpecModel.optionList.append(dataModel)
            }
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addOption"), object: nil)
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    
    private func doUpdateAction_Net() {
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
    
    //删除选项
    private func deleteSpecOption_Net() {

        if curSpecModel.optionList.count == 1 && isSave {
            HUD_MB.showWarnig("The last option cannot be deleted!", onView: view)
            return
        }
        
        self.curSpecModel.optionList.remove(at: number - 1)
        if isSave {
            doUpdateAction_Net()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
