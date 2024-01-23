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
                addBut.backgroundColor = HCOLOR("#FEC501").withAlphaComponent(0.5)
            } else {
                addBut.isEnabled = true
                addBut.backgroundColor = HCOLOR("#FEC501")
            }
        }
    }
    
    
    private var dataArr: [OrderModel] = []
    
    
    

    private let b_view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 70), byRoundingCorners: [.topLeft, .topRight ], radii: 10)
        return view
    }()
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "ADD", HCOLOR("#000000"), BFONT(17), HCOLOR("#FEC501"))
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
    
    

    override func setNavi() {
        naviBar.leftImg = LOIMG("nav_back_w")
        naviBar.rightBut.isHidden = true
        naviBar.headerTitle = titStr
    }
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("#F4F3F8")
        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(70 + bottomBarH)
        }
        
        b_view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(b_view.snp.top)
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
            return 75
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
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == dataArr[indexPath.section].dishesArr.count + 1 {
                    
            //点击展开或者关闭
            if dataArr[indexPath.section].isShow {
                //关闭
                dataArr[indexPath.section].isShow = false
                dataArr[indexPath.section].dishesArr.removeAll()
                table.reloadData()
            } else {
                //展开
                dataArr[indexPath.section].isShow = true
                loadDishesData_Net(orderID: dataArr[indexPath.section].orderId, section: indexPath.section)
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
    
    
    private func loadDishesData_Net(orderID: String, section: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeskOrderDishesList(orderID: orderID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tarr: [OrderDishModel] = []
            for jsondata in json["data"]["dishesList"].arrayValue {
                let model = OrderDishModel()
                model.updateModel(json: jsondata)
                tarr.append(model)
            }
            dataArr[section].dishesArr = tarr
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
}
