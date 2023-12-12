//
//  SelectSizeController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/14.
//

import UIKit
import RxSwift



class SelectSizeController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let bag = DisposeBag()
    
    
    var isSearchVC: Bool = false
    
    ///菜品是否可以购买
    var canBuy: Bool = false
    ///菜品ID
    var dishesID: String = ""
    ///购物车ID  空为添加。不为空更新
    var cartID: String = ""
    ///选择数量
    var dishCount: Int = 1
    
    var deskID: String = ""
    
    private var info_H: CGFloat = 0
    

    private var dishModel = DishModel() {
        didSet {
            self.selecIdxArr.removeAll()
            for _ in dishModel.specification {

                ///选中下标的占位数字
                self.selecIdxArr.append([])
            }
        }
    }
        
    ///选中的规格选项下标
    private var selecIdxArr: [[Int]] = []
    
    
    
    private lazy var b_view: DishDetailBottmView = {
        let view = DishDetailBottmView()
        view.setButTitleType(canBuy: canBuy, cartID: self.cartID)
        view.clickAddBlock = { [unowned self] (_) in
            self.clickAddOrderAction()
        }
        return view
    }()
    
    private lazy var t_view: DishDetailInfoView = {
        let view = DishDetailInfoView()
        
        view.countBlock = { [unowned self] (count) in
            self.dishCount = count as! Int
            self.b_view.moneyLab.text = self.manager.selectedComboDishMoney(dishModel: self.dishModel, count: count as! Int)
        }
        return view
    }()


    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        but.backgroundColor = .black.withAlphaComponent(0.5)
        but.layer.cornerRadius = 35 / 2
        return but
    }()
    
    
    private lazy var mainTable: GestureTableView = {
        let tableView = GestureTableView()
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
        tableView.bounces = false

        //tableView.register(SizeHeaderCell.self, forCellReuseIdentifier: "SizeHeaderCell")
        tableView.register(SpecificationsCell.self, forCellReuseIdentifier: "SpecificationsCell")
        
        return tableView
    }()
    
    private let manager = MenuOrderManager()

    
    
    override func setViews() {
        self.naviBar.isHidden = true
        loadDishedDetail_Net()
        
    }
    
    private func setUpUI() {
        
        view.backgroundColor = HCOLOR("#F7F7F7")
        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(bottomBarH + 50)
        }
        
        view.addSubview(mainTable)
        mainTable.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(b_view.snp.top)
        }
        
        t_view.setCellData(model: dishModel, selectCount: dishCount, canBuy: canBuy)
        mainTable.addSubview(t_view)
        t_view.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(S_W)
            $0.height.equalTo(info_H)
            $0.top.equalToSuperview().offset(-info_H)
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func clickAddOrderAction() {
        
        if PJCUtil.checkLoginStatus() {
            if !manager.dishSizeIsSelected(dishModel: dishModel, selectIdxArr: selecIdxArr) {
                HUD_MB.showWarnig("Required option not completed", onView: self.view)
                return
            }
            self.addOrder_Net()
        }
    }
    
    
    //MARK: - 网络请求
    ///提交
    private func addOrder_Net() {
        HUD_MB.loading("", onView: view)
        let selectOption = manager.getSizeDicbySelected(selectIdxArr: selecIdxArr, dishModel: dishModel)
        
        if self.cartID == "" {
            //添加购物车
            HTTPTOOl.addShoppingCart(dishesID: dishModel.dishID, buyNum: String(dishCount), type: "2", optionList: selectOption, deskID: deskID).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.showSuccess("Success!", onView: self.view)
            
                //发送通知刷新点餐页面
                if self.isSearchVC {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchRefresh"), object: nil)
                    
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
                }
                
                self.navigationController?.popViewController(animated: true)
            
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)

        } else {
            HTTPTOOl.updateCartNum(buyNum: dishCount, cartID: cartID).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.showSuccess("Success!", onView: self.view)
                //发送通知刷新点餐页面
                if isSearchVC {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchRefresh"), object: nil)
                    
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
                }

                self.navigationController?.popViewController(animated: true)
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        
        
        
    }
    
    ///获取菜品详情
    private func loadDishedDetail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loadDishesDetail(dishesID: dishesID, deskID: deskID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            let model = DishModel()
            model.updateModel(json: json["data"])
            self.dishModel = model
            
            b_view.moneyLab.text =  manager.selectedComboDishMoney(dishModel: dishModel, count: dishCount)
            
            //计算菜品详情视图的高度
            let str = "Allergen: " + self.dishModel.allergen
            let g_h = str.getTextHeigh(BFONT(13), S_W - 130)
            let d_h = self.dishModel.des.getTextHeigh(SFONT(13), S_W - 120)
            let n_h = self.dishModel.name_C.getTextHeigh(BFONT(17), S_W - 50)
            
            if canBuy && model.isGiveOne {
                info_H = (R_W(375) * (9/16)) + g_h + d_h + n_h + 50 + 30
            } else {
                info_H = (R_W(375) * (9/16)) + g_h + d_h + n_h + 50
            }
            
            mainTable.contentInset = UIEdgeInsets(top: self.info_H, left: 0, bottom: 0, right: 0)
            mainTable.contentOffset = CGPoint(x: 0, y: -info_H)
            self.setUpUI()
            
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}


extension SelectSizeController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishModel.specification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dishModel.specification[indexPath.row]
        return CGFloat((model.optionArr.count + 1)) * 40 + 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationsCell") as! SpecificationsCell
        cell.setCellData(model: dishModel.specification[indexPath.row], idxArr: selecIdxArr[indexPath.row])
        
        cell.selectBlock = { [unowned self] (idxArr) in
            self.selecIdxArr[indexPath.row] = idxArr as! [Int]
            self.b_view.moneyLab.text = manager.selectedSizeDishMoney(dishModel: self.dishModel, selectIdxArr: selecIdxArr, count: self.dishCount)
        }
        
        return cell
    }
}
