//
//  FullGiftEditController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/12/17.
//

import UIKit
import RxSwift

class FullGiftEditController: LBBaseViewController, UITableViewDelegate, UITableViewDataSource {
    

    private let bag = DisposeBag()
    var dataModel = FullGiftModel() {
        didSet {
            dishDataModel.comboDishesList = dataModel.dishArr
        }
    }
    
    private var dishDataModel = DishDetailComboModel()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, MAINCOLOR, TIT_16, .clear)
        but.layer.cornerRadius = 14
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        return but
    }()

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_16, MAINCOLOR)
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
        tableView.register(TitleAndButtonCell.self, forCellReuseIdentifier: "TitleAndButtonCell")
        tableView.register(DishesAndDeleteCell.self, forCellReuseIdentifier: "DishesAndDeleteCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")

        return tableView
        
    }()


    
    
    
    override func setNavi() {
        leftBut.setImage(LOIMG("sy_back"), for: .normal)
        if dataModel.giftId == "" {
            biaoTiLab.text = "Add".local
        } else {
            biaoTiLab.text = "Edit".local
        }
        table.reloadData()
    }
    
    
    
    override func setViews() {
        setUpUI()
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSaveAction() {

        if dataModel.name == "" {
            HUD_MB.showWarnig("Please enter the Full gift name!".local, onView: view)
            return
        }
        if dataModel.price == "" {
            HUD_MB.showWarnig("Please enter the amount!".local, onView: view)
            return
        }
        if dishDataModel.comboDishesList.count == 0 {
            HUD_MB.showWarnig("Please choose the dish!".local, onView: view)
            return
        }
        if dataModel.giftId == "" {
            //添加
            addAction_Net()
        } else {
            //編輯
            editAction_Net()
        }
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            if dishDataModel.comboDishesList.count == 0 {
                return 0
            }
        }
        if section == 4 {
            return dishDataModel.comboDishesList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            return 85
        }
        if indexPath.section == 2 {
            return 100
        }
        if indexPath.section == 3 {
            return 50
        }
        if indexPath.section == 4 {
            let dishModel = dishDataModel.comboDishesList[indexPath.row]
            let h1 = dishModel.name1.getTextHeigh(TIT_14, S_W - 90)
            let h2 = dishModel.name2.getTextHeigh(TXT_14, S_W - 90)
            return h1 + h2 + 30
        }

        
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            cell.setCellData(titStr: "Full gift name".local, msgStr: dataModel.name)
            
            cell.editeEndBlock = { [unowned self] (str) in
                dataModel.name = str
            }

            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.setCellData(money: dataModel.price, titStr: "Amount".local)
            
            cell.editeEndBlock = { [unowned self] (price) in
                dataModel.price = price
            }
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndButtonCell") as! TitleAndButtonCell
            cell.inLab.text = "Add Dishes".local
            cell.titlab.text = "Full gift dishes".local
            cell.clickAddBlock = { [unowned self] (str) in
                let editdishVC = MenuComboEditDishController()
                editdishVC.pageType = .coupon
                editdishVC.comboModel = dishDataModel
                navigationController?.pushViewController(editdishVC, animated: true)
            }
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            cell.titlab.text = "Dishes List".local
            cell.sLab.isHidden = true
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishesAndDeleteCell") as! DishesAndDeleteCell
            let dishModel = dishDataModel.comboDishesList[indexPath.row]
            cell.setCellData(name1: dishModel.name1, name2: dishModel.name2)
            cell.clickDeleteBlock = { [unowned self] _ in
                //删除
                dishDataModel.comboDishesList.remove(at: indexPath.row)
                table.reloadData()
            }
            return cell
        }
        
        
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    private func addAction_Net() {
        HUD_MB.loading("", onView: view)
        
        var dishArr: [Int64] = []
        for model in dishDataModel.comboDishesList {
            dishArr.append(model.dishesId)
        }
        
        HTTPTOOl.addFullGift(name: dataModel.name, price: dataModel.price, dishList: dishArr, status: "1").subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success".local, onView: view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    private func editAction_Net() {
        HUD_MB.loading("", onView: view)
        
        var dishArr: [Int64] = []
        for model in dishDataModel.comboDishesList {
            dishArr.append(model.dishesId)
        }
        
        HTTPTOOl.editFullGift(id: dataModel.giftId, name: dataModel.name, price: dataModel.price, dishList: dishArr, status: dataModel.status).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success".local, onView: view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
    
}
