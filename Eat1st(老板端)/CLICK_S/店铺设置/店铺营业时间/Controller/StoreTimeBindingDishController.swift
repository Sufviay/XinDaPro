//
//  StoreTimeBindingDishController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/23.
//

import UIKit
import RxSwift

class StoreTimeBindingDishController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {


    private let bag = DisposeBag()

    var timeID: String = ""
    
    
    ///是否全选
    private var isSelectAll: Bool = false {
        didSet {
            
            if isSelectAll {
                self.allImgBut.setImage(LOIMG("all_sel"), for: .normal)
            } else {
                self.allImgBut.setImage(LOIMG("all_unsel"), for: .normal)
            }
        }
    }
    
    private var dataArr: [F_DishModel] = []
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), HCOLOR("465DFD"))
        but.clipsToBounds = true
        but.layer.cornerRadius = 14
        return but
    }()

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private let allImgBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("all_unsel"), for: .normal)
        return but
    }()
    
    private let allBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Select all items", FONTCOLOR, BFONT(13), .clear)
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
        
        tableView.sectionHeaderHeight = 65
        
        tableView.register(DishesClassifyHeader.self, forHeaderFooterViewReuseIdentifier: "DishesClassifyHeader")
        tableView.register(DishesItemCell.self, forCellReuseIdentifier: "DishesItemCell")
        return tableView
        
    }()
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Dishes"

    }
    
    
    

    
    override func setViews() {
        setUpUI()
        loadDishData_Net()
    }
    
    
    
    
    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(allImgBut)
        allImgBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(allBut)
        allBut.snp.makeConstraints {
            $0.centerY.equalTo(allImgBut)
            $0.left.equalTo(allImgBut.snp.right).offset(0)
            $0.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(allBut.snp.bottom).offset(10)
            $0.bottom.equalTo(saveBut.snp.top).offset(-10)
        }


        leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
        allBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)
        allImgBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)
    }

    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    @objc private func clickAllAction() {
        
        isSelectAll = !isSelectAll

        if isSelectAll {
            for model in dataArr {
                model.isShow = true
                model.isSelectAll = true

                for tmodel in model.dishArr {
                    tmodel.isSelect = true
                }
            }
        } else {
            for model in dataArr {
                model.isShow = false
                model.isSelectAll = false
                for tmodel in model.dishArr {
                    tmodel.isSelect = false
                }
            }
        }
        self.table.reloadData()
    
    }
    
    
    @objc private func clickSaveAction() {
        saveAction_Net()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if dataArr[section].isShow {
            return dataArr[section].dishArr.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  dataArr[indexPath.section].dishArr[indexPath.row].dish_H
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishesItemCell") as! DishesItemCell
        
        cell.setCellData(model: dataArr[indexPath.section].dishArr[indexPath.row])
        
        cell.isShowImg.isHidden = true
        
        cell.selectBlock = { [unowned self] (_) in
            //点选菜品
            dataArr[indexPath.section].dishArr[indexPath.row].isSelect = !dataArr[indexPath.section].dishArr[indexPath.row].isSelect

            ///判断当前分类是否全选
            //当前分类菜品总数
            let cunt_f = self.dataArr[indexPath.section].dishArr.count
            //当前分类以选择的菜品数量
            var s_count_f = 0
            for model in self.dataArr[indexPath.section].dishArr {
                if model.isSelect {
                    s_count_f += 1
                }
            }
            //如果选择的数量和总数相同 分类的全选为选中状态
            if cunt_f == s_count_f {
                self.dataArr[indexPath.section].isSelectAll = true
            } else {
                self.dataArr[indexPath.section].isSelectAll = false
            }
            self.table.reloadData()

        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点选菜品
        dataArr[indexPath.section].dishArr[indexPath.row].isSelect = !dataArr[indexPath.section].dishArr[indexPath.row].isSelect
        
        ///判断当前分类是否全选
        //当前分类菜品总数
        let cunt_f = self.dataArr[indexPath.section].dishArr.count
        //当前分类以选择的菜品数量
        var s_count_f = 0
        for model in self.dataArr[indexPath.section].dishArr {
            if model.isSelect {
                s_count_f += 1
            }
        }
        //如果选择的数量和总数相同 分类的全选为选中状态
        if cunt_f == s_count_f {
            self.dataArr[indexPath.section].isSelectAll = true
        } else {
            self.dataArr[indexPath.section].isSelectAll = false
        }
        self.table.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DishesClassifyHeader") as! DishesClassifyHeader
        header.setCellData(model: dataArr[section])
        header.clickBlock = { [unowned self] (type) in
            if type == "show" {
                //控制展开菜品
                self.dataArr[section].isShow = !self.dataArr[section].isShow
                self.table.reloadData()
            }
            if type == "select" {
                //全选菜品控制
                self.dataArr[section].isSelectAll = !self.dataArr[section].isSelectAll
                
                
                if self.dataArr[section].isSelectAll {
                    self.dataArr[section].isShow = true
                    for model in self.dataArr[section].dishArr {
                        model.isSelect = true
                    }
                } else {
                    for model in self.dataArr[section].dishArr {
                        model.isSelect = false
                    }
                }
                self.table.reloadData()
            }
            
        }
        return header
    }
    
    
    
    //MARK: - 网络请求
    
    ///请求分类菜品
    private func loadDishData_Net() {
       
        HTTPTOOl.getDishList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var c_arr: [F_DishModel] = []
            for c_jsonData in json["data"]["classifyList"].arrayValue {
                let model = F_DishModel()
                model.updateModel(json: c_jsonData)
                c_arr.append(model)
            }
            
            var d_arr: [DishModel] = []
            for d_jsonData in json["data"]["dishesList"].arrayValue {
                let model = DishModel()
                model.updateModel(json: d_jsonData)
                d_arr.append(model)
            }
            
            
            for model in d_arr {
                for f_model in c_arr {
                    if f_model.id == model.c_id {
                        f_model.dishArr.append(model)
                    }
                }
            }
            
            //去掉空的分类
            c_arr = c_arr.filter{ $0.dishArr.count != 0 }
            self.dataArr = c_arr
            self.getTimeDishes_Net(d_arr: d_arr)
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    ///获取关联菜品
    private func getTimeDishes_Net(d_arr: [DishModel]) {
        HTTPTOOl.getTimeBindingDishes(timeID: timeID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            for jsonData in json["data"].arrayValue {
                let dishID = jsonData["dishesId"].stringValue
                for d_model in d_arr {
                    if d_model.id == dishID {
                        d_model.isSelect = true
                    }
                }
            }
            
            for c_model in self.dataArr {
                if (c_model.dishArr.filter { !$0.isSelect }.count == 0){
                    c_model.isSelectAll = true
                } else {
                    c_model.isSelectAll = false
                }
            }
            
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

    ///保存菜品
    private func saveAction_Net() {
        var tarr: [[String: String]] = []
        
        for c_model in dataArr {
            for d_model in c_model.dishArr {
                if d_model.isSelect {
                    let dic = ["dishesId": d_model.id, "storeTimeId": timeID]
                    tarr.append(dic)
                }
            }
        }
        
        if tarr.count == 0 {
            HUD_MB.showWarnig("Please choose the dish!", onView: self.view)
            return
        }
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.saveTimeBindingDishes(timeID: timeID, dishes: tarr).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
}
