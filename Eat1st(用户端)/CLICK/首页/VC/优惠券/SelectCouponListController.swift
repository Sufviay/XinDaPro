//
//  SelectCouponListController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/25.
//

import UIKit
import RxSwift


protocol SelectCouponDelegate {
    
    func didSelectedCoupon(coupon: CouponModel)
}



class SelectCouponListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: SelectCouponDelegate?
    
    private let bag = DisposeBag()
    private var dataArr: [CouponModel] = []

    ///菜品原价 - 菜品优惠的价格
    var dishesPrice: String = ""
    var storeID: String = ""
    
    
    var selectCoupon = CouponModel() {
        didSet {
            if selectCoupon.couponId == "" {
                self.moneyLab.text = "0"
            } else {
                self.moneyLab.text = D_2_STR(selectCoupon.couponAmount)
            }
        }
    }
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 20
        but.setCommentStyle(.zero, "Confirm", MAINCOLOR, BFONT(17), .white)
        return but
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.text = "£"
        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .left)
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.text = "0.00"
        lab.setCommentStyle(HCOLOR("333333"), BFONT(20), .left)
        return lab
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(SelectCouponListCell.self, forCellReuseIdentifier: "SelectCouponListCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    override func setNavi() {
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.headerTitle = "Coupon"
        self.naviBar.rightBut.isHidden = true
        self.loadData_Net()
    }
    
    override func setViews() {
        setUpUI()
        
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
     
        view.backgroundColor = HCOLOR("#F7F7F7")
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
        }
        
        bottomView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 110, height: 40))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
        }
        
        
        bottomView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        bottomView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.bottom.equalTo(slab).offset(3)
            $0.left.equalTo(slab.snp.right).offset(2)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top).offset(-10)
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
        }
        
        confirmBut.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        
    }
    
    @objc private func clickConfirm() {
        
        if selectCoupon.couponType == "3" && selectCoupon.selCouponUserDishesId == "" {
            HUD_MB.showWarnig("Please select a dish!", onView: self.view)
            return
        }
        
        self.delegate?.didSelectedCoupon(coupon: selectCoupon)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func loadData_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getAvabliableCouponList(dishesPrice: dishesPrice, storeID: storeID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var tarr1: [CouponModel] = []
            var tarr2: [CouponModel] = []
            for jsonData in json["data"].arrayValue {
                
                let model = CouponModel()
                model.updateModel(json: jsonData)
                
                if model.status == "1" {
                    tarr1.append(model)
                } else {
                    tarr2.append(model)
                }
                
            }
            
            self.dataArr = tarr1 + tarr2
            
            if self.dataArr.count == 0 {
                self.table.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }

            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

}

extension SelectCouponListController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cell_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCouponListCell") as! SelectCouponListCell
        
        cell.setCellData(model:  dataArr[indexPath.row], selectModel: selectCoupon)
        
        //点击规格
        cell.clickRuleBlock = { [unowned self] (_) in
            self.dataArr[indexPath.row].ruleIsOpen = !self.dataArr[indexPath.row].ruleIsOpen
            self.table.reloadData()
        }
        
        //展开菜品
        cell.clickDishesMoreBlock = { [unowned self] (_) in
            dataArr[indexPath.row].dishIsOpen = !dataArr[indexPath.row].dishIsOpen
            table.reloadData()
        }

        //点击选择优惠券
        cell.clickCouponBlock = { [unowned self] (_) in
            let model = dataArr[indexPath.row]
            
            if model.status == "1" {
                
                if selectCoupon.couponId == model.couponId {
                    selectCoupon = CouponModel()

                } else {
                    selectCoupon = model
                    if selectCoupon.couponType == "3" {
                        model.dishIsOpen = true
                    }
                    
                }
                
                self.table.reloadData()
            }
        }
        
        //点选菜品
        cell.clickCouponDishBlock = { [unowned self] (arr) in
            
            let strArr = arr as! [String]
            
            let name = strArr[0]
            let id = strArr[1]
            
            
            if id != "" && selectCoupon.couponId == "" {
                selectCoupon = dataArr[indexPath.row]
            }
        
            selectCoupon.selDishesName = name
            selectCoupon.selCouponUserDishesId = id
            
            table.reloadData()
        }
        
        
        return cell
    }
    
    
}
