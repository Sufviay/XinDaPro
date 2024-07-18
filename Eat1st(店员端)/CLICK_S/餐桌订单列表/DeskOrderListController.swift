//
//  DeskOrderListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/22.
//

import UIKit
import RxSwift


class DeskOrderListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    private let bag = DisposeBag()
    
    var attachDataArr: [AttachClassifyModel] = []
    
    var titStr: String = ""
    var deskID: String = ""
    var deskStatus: DeskStatus = .Empty {
        didSet {
            if deskStatus == .Settlement || deskStatus == .Settlement {
                addBut.isEnabled = false
            } else {
                addBut.isEnabled = true
            }
        }
    }
    
    
    private var dataArr: [OrderModel] = []
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Add", .black, BFONT(16), MAINCOLOR)
        but.layer.cornerRadius = 10
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OrderHeaderCell.self, forCellReuseIdentifier: "OrderHeaderCell")
        tableView.register(OrderFooderCell.self, forCellReuseIdentifier: "OrderFooderCell")
        tableView.register(OrderDishCell.self, forCellReuseIdentifier: "OrderDishCell")
        return tableView
    }()
    
    
    private var deleteSection: Int = 0
    private var deleteID: String = ""
    
    private lazy var pwdAlert: PasswordAlert = {
        let view = PasswordAlert()
        
        view.pwdBlock = { [unowned self] (pwd) in
            deleteDished_Net(id: deleteID, pwd: pwd, section: deleteSection)
        }
        
        return view
    }()
    

    override func setNavi() {
        naviBar.leftImg = LOIMG("nav_back_w")
        naviBar.rightBut.isHidden = true
        naviBar.headerTitle = titStr
    }
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
        addNotification()
    }
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("#F4F3F8")
        
        view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(-bottomBarH - 15)
        }
        

        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
            $0.top.equalTo(naviBar.snp.bottom).offset(15)
        }
        
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
        
    }
    
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickAddAction() {
        //进入点餐页面
        let nextVC = DishListController()
        nextVC.attachDataArr = attachDataArr
        nextVC.titStr = titStr
        nextVC.deskID = deskID
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    deinit {
        print("\(self.classForCoder) 销毁")
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
    }
    

    private func addNotification() {
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    
    @objc private func orientationDidChange() {
        
        switch UIDevice.current.orientation {
        case .unknown:
            print("未知")
        case .portrait:
            print("竖屏")
            orientationDidChangeUpdate()
        case .portraitUpsideDown:
            print("颠倒竖屏")
            orientationDidChangeUpdate()
        case .landscapeLeft:
            print("左旋转 横屏")
            orientationDidChangeUpdate()
        case .landscapeRight:
            print("右旋转 横屏")
            orientationDidChangeUpdate()
        case .faceUp:
            print("屏幕朝上")
        case .faceDown:
            print("屏幕朝下")
        default:
            break
        }
        
    }
    
    func orientationDidChangeUpdate() {
        
        DispatchQueue.main.async {
            print("----------W:\(UIScreen.main.bounds.width)\n----------H:\(UIScreen.main.bounds.height)")
            self.table.reloadData()
        }
    }
    
    
    

}

extension DeskOrderListController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].dishesArr.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        
        if indexPath.row == dataArr[indexPath.section].dishesArr.count + 1 {
            return 45
        }
        
        return dataArr[indexPath.section].dishesArr[indexPath.row - 1].cell_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHeaderCell") as! OrderHeaderCell
            cell.setCellData(model: dataArr[indexPath.section])
            return cell
        }
        
    
        if indexPath.row == dataArr[indexPath.section].dishesArr.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFooderCell") as! OrderFooderCell
            cell.setCellData(isShow: dataArr[indexPath.section].isShow)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDishCell") as! OrderDishCell
        cell.setCellData(model: dataArr[indexPath.section].dishesArr[indexPath.row - 1])
        
        
        cell.deleteBlock = { [unowned self] (id) in
            deleteSection = indexPath.section
            deleteID = id
            pwdAlert.appearAction()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == dataArr[indexPath.section].dishesArr.count + 1 || indexPath.row == 0 {
                    
            //点击展开或者关闭
            if dataArr[indexPath.section].isShow {
                //关闭
                dataArr[indexPath.section].isShow = false
                dataArr[indexPath.section].dishesArr.removeAll()
                table.reloadData()
            } else {
                //展开
                dataArr[indexPath.section].isShow = true
                loadDishesData_Net(section: indexPath.section)
            }
            
        }
    }
    
    
    
    
}


extension DeskOrderListController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeskOrderList(deskID: deskID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tarr: [OrderModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OrderModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            dataArr = tarr
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    private func loadDishesData_Net(section: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getOrderDetail(orderID: dataArr[section].orderId).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var danPinArr: [OrderDishModel] = []
            var taocanArr: [OrderDishModel] = []
            
            for jsondata in json["data"]["dishesList"].arrayValue {
                let model = OrderDishModel()
                model.updateModel(json: jsondata)
                
                if model.baleSort == "0" {
                    danPinArr.append(model)
                } else {
                    //套餐
                    //如果套餐数组中不存在相同的 baleSort 就创建一个 OrderDishModel
                    //如果存在 当作赠品 可删除
                    let arr = taocanArr.filter { $0.baleSort == model.baleSort }
                    if arr.count == 0 {
                        let newModel = OrderDishModel()
                        newModel.baleSort = model.baleSort
                        newModel.nameEn = json["data"]["baleNameEn"].stringValue
                        newModel.nameHk = json["data"]["baleNameHk"].stringValue
                        newModel.price = json["data"]["baleDishesPrice"].doubleValue
                        newModel.buyNum = 1
                        let attModel = OrderDishSelectItemModel()
                        attModel.updateModelByTaoCan(model: model)
                        newModel.attachList.append(attModel)
                        newModel.updateTaoCanModel_Hight()
                        taocanArr.append(newModel)
                        
                        
                    } else {
                        
                        let attModel = OrderDishSelectItemModel()
                        attModel.updateModelByTaoCan(model: model)
                        arr.first?.attachList.append(attModel)
                        arr.first?.updateTaoCanModel_Hight()
                    }
                }
            }

            dataArr[section].dishesArr = danPinArr + taocanArr
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //删除菜品
    private func deleteDished_Net(id: String, pwd: String, section: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteOrderDishes(orderDishesID: id, pwd: pwd).subscribe(onNext: { [unowned self] (json) in
            loadDishesData_Net(section: section)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
}
