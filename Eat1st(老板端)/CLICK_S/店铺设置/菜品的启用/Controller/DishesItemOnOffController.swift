//
//  DishesItemOnOffController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/10.
//

import UIKit
import RxSwift

class DishesItemOnOffController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    
    private var dataArr: [F_DishModel] = []
    
    ///所有数据的个数
    private var allCount: Int = 0
    
    ///1上架。2下架
    private var type: String = "1"

    ///选中个数
    private var selectCount: Int = 0 {
        didSet {
            if type == "1" {
                self.b_but.setTitle("Take off menu - \(selectCount) item", for: .normal)
            } else {
                self.b_but.setTitle("Take on menu - \(selectCount) item", for: .normal)
            }
            
            if selectCount == allCount {
                self.isSelectAll = true
            } else {
                self.isSelectAll = false
            }

        }
    }
    
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
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    

    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Temporarily take items off your menu until the end of the day if you're running low or out of stock. Use the menu tool to add, edit or remove items from your menu"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private lazy var tagView: OnOffTagView = {
        let tag = OnOffTagView()
        tag.clickBlock = { [unowned self] (type) in
            
            if type == "on" {
                self.type = "1"
            } else {
                self.type = "2"
            }
            self.loadDishData_Net()
        }
        return tag
    }()
    
    
    private let b_but: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Take off menu -0item", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 10
        return but
    }()


    private let allImgBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("all_unsel"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    private let allBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Select all items", FONTCOLOR, BFONT(13), .clear)
        but.isHidden = true
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

//        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0
//        }
        tableView.register(DishesClassifyHeader.self, forHeaderFooterViewReuseIdentifier: "DishesClassifyHeader")
        tableView.register(DishesItemContentCell.self, forCellReuseIdentifier: "DishesItemContentCell")
        return tableView
        
    }()
    
    
    private lazy var noDataView: DishesNoDataView = {
        let view = DishesNoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "ltem availability"
    
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
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(titLab.snp.bottom).offset(20)
        }
        
        backView.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(b_but)
        b_but.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-25)
            $0.height.equalTo(50)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
        }
        
        backView.addSubview(allImgBut)
        allImgBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(tagView.snp.bottom).offset(10)
        }
        
        backView.addSubview(allBut)
        allBut.snp.makeConstraints {
            $0.centerY.equalTo(allImgBut)
            $0.left.equalTo(allImgBut.snp.right).offset(0)
            $0.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(allBut.snp.bottom).offset(10)
            $0.bottom.equalTo(b_but.snp.top).offset(-20)
        }

        
        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        self.b_but.addTarget(self, action: #selector(clickB_butAction), for: .touchUpInside)
        self.allBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)
        self.allImgBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)
    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickB_butAction() {
        self.setStatus_Net()
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
            self.selectCount = allCount
        } else {
            for model in dataArr {
                model.isSelectAll = false
                for tmodel in model.dishArr {
                    tmodel.isSelect = false
                }
            }
            self.selectCount = 0
        }
        self.table.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataArr[indexPath.section].dishArr[indexPath.row].isSelect = !dataArr[indexPath.section].dishArr[indexPath.row].isSelect
        
        self.selectCount = self.getSelectCount()
        self.table.reloadData()
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
        return  dataArr[indexPath.section].dishArr[indexPath.row].cell_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishesItemContentCell") as! DishesItemContentCell
        cell.setCellData(dish: dataArr[indexPath.section].dishArr[indexPath.row])
        
        cell.clickShowBlock = { [unowned self] (par) in
            
            if par == "show" {
                //请求菜品规格
                self.loadDishesOption_Net(section: indexPath.section, row: indexPath.row)
            }
            if par == "hide" {
                //清除菜品规格
                self.dataArr[indexPath.section].dishArr[indexPath.row].optionArr.removeAll()
                self.table.reloadData()
            }
            
        }
        
        cell.clickSelectBlock = { [unowned self] (_) in
            //点选菜品
            dataArr[indexPath.section].dishArr[indexPath.row].isSelect = !dataArr[indexPath.section].dishArr[indexPath.row].isSelect
            
            self.selectCount = self.getSelectCount()
            
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
        
        
        cell.clickSpecBlock = { [unowned self] (id) in
            //上下架规格
            self.setSpecStatus_Net(id: id, section: indexPath.section, row: indexPath.row)
        }
        
        cell.clickOptionBlock = { [unowned self] (id) in
            //上下架规格选项
            self.setOptionItemStatus_Net(id: id, section: indexPath.section, row: indexPath.row)
        }
        
        return cell
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
                self.selectCount = self.getSelectCount()
                self.table.reloadData()
            }
            
        }
        return header
    }

}



extension DishesItemOnOffController {
    
    //MARK: - 网络请求
    
    ///请求分类菜品
    private func loadDishData_Net() {
        HUD_MB.loading("", onView: view)
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
            
            self.setOnOffDataModelArr(d_arr: d_arr, c_arr: c_arr)
            self.table.reloadData()
            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    ///请求菜品的规格
    func loadDishesOption_Net(section: Int, row: Int) {
        
        let id = dataArr[section].dishArr[row].id
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesOptionList(id: id).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var tArr: [DishOptionModel] = []
            
            for jsonData in json["data"].arrayValue {
                let model = DishOptionModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            self.dataArr[section].dishArr[row].optionArr = tArr
            
            self.table.reloadData()
            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    
    ///设置菜品上下架
    private func setStatus_Net() {
        if self.selectCount == 0 {
            HUD_MB.showWarnig("Please choose your dishes！", onView: self.view)
            return
        }
        
        let dishesID = self.getSelectedDishData()
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setDishesOnOff(dishes: dishesID).subscribe(onNext: { (json) in
            self.loadDishData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    ///设置规格启用禁用
    private func setSpecStatus_Net(id: String, section: Int, row: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setSpecOnOffStatus(id: id).subscribe(onNext: { (json) in
            self.loadDishesOption_Net(section: section, row: row)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    ///设置规格选项启用禁用
    private func setOptionItemStatus_Net(id: String, section: Int, row: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setOptionItemOnOffStatus(id: id).subscribe(onNext: { (json) in
            self.loadDishesOption_Net(section: section, row: row)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}

extension DishesItemOnOffController {
    
    
    //菜品分类 初始化数据
    private func setOnOffDataModelArr(d_arr: [DishModel], c_arr: [F_DishModel]) {
        
        var arr: [F_DishModel] = c_arr
        
        for model in d_arr {
                            
            if model.statusID == type {
                for (idx, f_model) in c_arr.enumerated() {
                    
                    if f_model.id == model.c_id {
                        arr[idx].dishArr.append(model)
                    }
                }
            }
        }
        
        //去掉空的分类
        arr = arr.filter{ $0.dishArr.count != 0 }
        self.dataArr = arr
        
        //设置空数据视图
        if self.dataArr.count == 0 {
            noDataView.type = self.type
            self.table.addSubview(noDataView)
            self.allBut.isHidden = true
            self.allImgBut.isHidden = true
            self.b_but.isHidden = true
        } else {
            self.noDataView.removeFromSuperview()
            self.allBut.isHidden = false
            self.allImgBut.isHidden = false
            self.b_but.isHidden = false
        }
        
        
        //计算总的个数
        var t = 0
        for model in dataArr {
            t += model.dishArr.count
        }
        self.allCount = t
        
        self.selectCount = 0
        
        self.isSelectAll = false
    }
    
    
    //计算选中个数
    private func getSelectCount() -> Int {
        var t: Int = 0
        
        for model in dataArr {
            for tmodel in model.dishArr {
                if tmodel.isSelect {
                    t += 1
                }
            }
        }
        return t
    }
    
    //生成选中菜品的id数据
    private func getSelectedDishData() -> [[String: String]] {
        
        var par: [[String: String]] = []
        
        for model in dataArr {
            for tmodel in model.dishArr {
                if tmodel.isSelect {
                    let dic = ["dishesId": tmodel.id]
                    par.append(dic)
                }
            }
        }
        
        return par
        
    }
    
    
}
