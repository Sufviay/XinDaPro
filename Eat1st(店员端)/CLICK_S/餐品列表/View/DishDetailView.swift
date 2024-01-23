//
//  DishDetailView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/16.
//

import UIKit
import RxSwift



class DishDetailView: BaseAlertView, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    var dishID: String = ""
    var deskID: String = ""
    ///购买数量
    var buyNum: Int = 1
    
    //购物车添加菜品
    var addBlock: VoidBlock?
    //编辑购物车
    var editBlock: VoidBlock?
    
    var isEdit: Bool = false
    
    ///当是编辑状态时有值
    var cartSelectItemArr: [CartDishItemModel] = []
    var cartAttachArr: [CartDishItemModel] = []
    var cartEditIdx: Int = 0

    ///菜品附加
    var attachDataArr: [AttachClassifyModel] = []
    
    private var sectionNum: Int = 0
    
    ///菜品详情数据
    private var detailModel = DishModel()

    
    ///选择的规格选项的下标
    private var selectSpecIdxArr: [[Int]] = []
    
    ///选择的套餐的下标
    private var selectComboIdxArr: [[Int]] = []
    
    ///选择的附加菜品
    private var selectAttachArr: [AttachModel] = []
    

    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "ADD", HCOLOR("#000000"), BFONT(13), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", HCOLOR("#FEC501"), BFONT(13), .white)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 2
        but.layer.borderColor = HCOLOR("#FEC501").cgColor
        return but
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DishDetailNameCell.self, forCellReuseIdentifier: "DishDetailNameCell")
        tableView.register(DishDetailCountCell.self, forCellReuseIdentifier: "DishDetailCountCell")
        tableView.register(DishDetailAllregenCell.self, forCellReuseIdentifier: "DishDetailAllregenCell")
        tableView.register(DishDetailSpecAndComboCell.self, forCellReuseIdentifier: "DishDetailSpecAndComboCell")
        tableView.register(DishDetailAttachCell.self, forCellReuseIdentifier: "DishDetailAttachCell")
        return tableView
    }()
    
    

    
    override func setViews() {
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
            $0.top.equalToSuperview().offset(bottomBarH + 30)
        }
        
        backView.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.left.equalTo(backView.snp.centerX).offset(10)
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.right.equalTo(backView.snp.centerX).offset(-10)
        }

        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(addBut.snp.top).offset(-15)
        }
        
        
        
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
    }

    
    @objc private func clickAddAction() {
        //判断菜品的规格 和 套餐是否选择完全
    
        if dishIsRequired() {
            
            
            var optionArr: [OptionModel] = []
            var comArr: [ComboDishesModel] = []
            
            //选择的规格选项数组
            if detailModel.dishesType == "1" {
                
                for (specIdx, idxArr) in selectSpecIdxArr.enumerated() {
                    
                    for optionIdx in idxArr {
                        let model = detailModel.specList[specIdx].optionList[optionIdx - 1]
                        optionArr.append(model)
                    }
                }
                
            }
            
            if detailModel.dishesType == "2" {
                
                for (comIdx, idxArr) in selectComboIdxArr.enumerated() {
                    
                    for dishIdx in idxArr {
                        let model = detailModel.comboSpecList[comIdx].comboDishesList[dishIdx - 1]
                        comArr.append(model)
                    }
                }
                
            }
            
            if !isEdit {
                let info: [String: Any] = ["num": buyNum, "opt": optionArr, "com": comArr, "att": selectAttachArr, "dish": detailModel]
                addBlock?(info)
            } else {
                let info: [String: Any] = ["num": buyNum, "opt": optionArr, "com": comArr, "att": selectAttachArr, "idx": cartEditIdx, "dish": detailModel]
                editBlock?(info)
            }
            
            disAppearAction()
    
        } else {
            HUD_MB.showWarnig("Required option not completed", onView: backView)
        }
        
        
    }
    
    
    ///判断菜品选项是否选择齐全
    private func dishIsRequired() -> Bool {
        
        if detailModel.dishesType == "1" {
            //单品
            for (idx, spec) in detailModel.specList.enumerated() {
                let arr = selectSpecIdxArr[idx]
                if spec.required == "2" {
                    if arr.count == 0 {
                        return false
                    }
                }
            }
            return true
        }
        
        if detailModel.dishesType == "2" {
            //套餐 每个都需要选择
            for (idx, combo) in detailModel.comboSpecList.enumerated() {
                let arr = selectComboIdxArr[idx]
                
                if combo.comboDishesList.count != 0 {
                    
                    if arr.count == 0 {
                        return false
                    }
                }
            }
            return true

        }
        return true
        
    }
    
    
    @objc private func clickCancelAction() {

        disAppearAction()
    }
    
    override func disAppearAction() {
        super.disAppearAction()
        buyNum = 1
        sectionNum = 0
        isEdit = false
        selectAttachArr.removeAll()
        selectSpecIdxArr.removeAll()
        selectComboIdxArr.removeAll()
        table.reloadData()
    }
    
    
    override func appearAction() {
        super.appearAction()
        loadData_Net()
    }
    
    
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if detailModel.allergen == "" {
                return 0
            }
        }
        
        if section == 3 {
            //规格
            return detailModel.specList.count
        }
        
        if section == 4 {
            //套餐
            return detailModel.comboSpecList.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return detailModel.detail_Name_H
        }
        if indexPath.section == 1 {
            return 35
        }
        if indexPath.section == 2 {
            return detailModel.allergen_H
        }
        if indexPath.section == 3 {
            return detailModel.specList[indexPath.row].cell_H
        }
        if indexPath.section == 4 {
            return detailModel.comboSpecList[indexPath.row].cell_H
        }
        
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailNameCell") as! DishDetailNameCell
            cell.setCellData(model: detailModel)
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCountCell") as! DishDetailCountCell
            cell.setCellData(money: D_2_STR(detailModel.price), buyNum: buyNum)
            
            cell.countBlock = { [unowned self] (count) in
                buyNum = count
            }
            
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailAllregenCell") as! DishDetailAllregenCell
            cell.setCellData(allergenStr: detailModel.allergen)
            return cell
        }
        if indexPath.section == 3 || indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailSpecAndComboCell") as! DishDetailSpecAndComboCell
            if indexPath.section == 3 {
                cell.setCellDataWith(spec: detailModel.specList[indexPath.row], idxArr: selectSpecIdxArr[indexPath.row])
            }
            if indexPath.section == 4 {
                cell.setCellDataWith(combo: detailModel.comboSpecList[indexPath.row], idxArr: selectComboIdxArr[indexPath.row])
            }
            
            
            cell.selectBlock = { [unowned self] (idxArr) in
                if indexPath.section == 3 {
                    selectSpecIdxArr[indexPath.row] = idxArr as! [Int]
                }
                if indexPath.section == 4 {
                    selectComboIdxArr[indexPath.row] = idxArr as! [Int]
                }
            }
    
            return cell
        }
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailAttachCell") as! DishDetailAttachCell
            cell.setCellData(modelArr: attachDataArr, selectAttach: selectAttachArr)
            
            cell.selectBlock = { [unowned self] (attArr) in
                selectAttachArr = attArr as! [AttachModel]
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }

    
}


extension DishDetailView {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getDishesDetail(deskID: deskID, dishID: dishID).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.dissmiss(onView: backView)
            detailModel.updateDetailModel(json: json["data"])
            
            
            for _ in detailModel.specList {
                selectSpecIdxArr.append([])
            }
            
            for _ in detailModel.comboSpecList {
                selectComboIdxArr.append([])
            }
            
            
            if isEdit {
                getSelectIdxArr()
            }

            sectionNum = 6
            table.reloadData()
            
//            //获取菜品附加分类列表
//            HTTPTOOl.getAttachClassifyList().subscribe(onNext: { [unowned self] (json) in
//
//                var tarr: [AttachClassifyModel] = []
//                for jsondata in json["data"].arrayValue {
//                    let model = AttachClassifyModel()
//                    model.updateModel(json: jsondata)
//                    tarr.append(model)
//                }
//                attachDataArr = tarr
//
//                //获取菜品附加的列表
//                HTTPTOOl.getAttachList().subscribe(onNext: { [unowned self] (json) in
//                    HUD_MB.dissmiss(onView: backView)
//
//                    for jsondata in json["data"].arrayValue {
//                        let model = AttachModel()
//                        model.updateModel(json: jsondata)
//                        //根据分类ID 插入附加分类中
//                        for cmodel in attachDataArr {
//                            if cmodel.classifyId == model.classifyId {
//                                cmodel.attachList.append(model)
//                            }
//                        }
//                    }
//
//                    if isEdit {
//                        getSelectIdxArr()
//                    }
//
//                    sectionNum = 6
//                    table.reloadData()
//
//                }, onError: { [unowned self] (error) in
//                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
//                }).disposed(by: bag)
//
//            }, onError: { [unowned self] (error) in
//                HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
//            }).disposed(by: bag)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
    
    ///通过购物车中选择的ItemID 还原选择的下标数组
    private func getSelectIdxArr() {
        
        if detailModel.dishesType == "1" {
            
            for item in cartSelectItemArr {
                for (specIdx, spec) in detailModel.specList.enumerated() {
                    for (opidx, op) in spec.optionList.enumerated() {
                        if op.optionId == item.itemID {
                            selectSpecIdxArr[specIdx].append(opidx + 1)
                        }
                    }
                }
            }
        }
        
        if detailModel.dishesType == "2" {
            
            for item in cartSelectItemArr {
                for (comIdx, com) in detailModel.comboSpecList.enumerated() {
                    for (dishidx, dish) in com.comboDishesList.enumerated() {
                        if dish.dishesComboRelId == item.itemID {
                            selectComboIdxArr[comIdx].append(dishidx + 1)
                        }
                    }
                }
            }

        }
        
        
        for item in cartAttachArr {
            for c_model  in attachDataArr {
                for model in c_model.attachList {
                    if model.attachId == item.itemID {
                        selectAttachArr.append(model)
                    }
                }
            }
        }
        
    }
    
}
