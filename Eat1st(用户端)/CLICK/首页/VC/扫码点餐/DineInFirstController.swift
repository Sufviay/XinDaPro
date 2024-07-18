//
//  DineInFirstController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/14.
//

import UIKit
import RxSwift

class DineInFirstController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    ///餐桌ID
    var deskID: String = ""
    ///店铺ID
    var storeID: String = ""
    ///店铺信息模型
    private let storeInfo = StoreInfoModel()
    
    ///购物车的数据模型
    private var cartModel = CartDataModel()
    
    ///分类数据
    private var dataArr: [DineInClassifyModel] = []

    
    private let bag = DisposeBag()

    private let backView: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dineInBack")
        img.contentMode = .scaleToFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let backView_fl: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dineBack")
        img.contentMode = .scaleToFill
        img.isUserInteractionEnabled = true
        return img
    }()
    

    
    ///自定义的导航栏
    private lazy var headerBar: DineInNavBarView = {
        let view = DineInNavBarView()
        view.setData(isHavePay: true)
        
        view.backBlock = { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
                
        view.amountBlock = { [unowned self] _ in
            let amountVC = RechargeDetailController()
            amountVC.storeID = storeID
            amountVC.storeName = storeInfo.name
            navigationController?.pushViewController(amountVC, animated: true)
        }
        
        view.payBlock = { [unowned self] _ in
            
            if UserDefaults.standard.isAgree {
                
                let payVC = PayCodeController()
                payVC.storeID = storeID
                navigationController?.pushViewController(payVC, animated: true)
            } else {
                //弹出法律条文页面
                let webVC = AgreeTermsController()
                webVC.titStr = "APP Terms and Conditions"
                webVC.webUrl = TCURL
                webVC.storeID = storeID
                self.present(webVC, animated: true, completion: nil)
            }
        }
        
        return view
    }()

    
    
    private lazy var bottomBar: DineInBottomBar = {
        let view = DineInBottomBar()
    
        view.clickBlock = { [unowned self] (type) in
            if type == "grjl" {
                //个人记录
                print("个人记录")
                let nextVC = PersonalInfoController()
                nextVC.isInfoCenter = true
                nextVC.isCanEdite = false
                navigationController?.pushViewController(nextVC, animated: true)
                
            }
            if type == "lsjl" {
                //历史记录
                print("历史记录")
                let orderVC = OrderListController()
                PJCUtil.currentVC()?.navigationController?.pushViewController(orderVC, animated: true)
            }
            if type == "gwc" {
                //购物车
                print("购物车")
                if cartModel.dishesList.count != 0 {
                    cartView.appearAction()
                } else {
                    HUD_MB.showMessage("Please order")
                }
            }
            if type == "hjfwy" {
                //呼叫服务员
                print("呼叫服务员")
                callWaiter_Net()
            }
            
        }
        
        
        return view
    }()
    
    
    private lazy var headerView: DineInStoreInfoView = {
        let view = DineInStoreInfoView()
        return view
    }()
    
    ///底部价格栏
    private lazy var b_view: MenuBottomToolView = {
        let view = MenuBottomToolView()
        view.clickCheckBlock = { [unowned self] (_) in
            
            //判断购物车中是否有实效的商品
            var isHaveFailure: Bool = false
            for model in cartModel.dishesList {
                if model.isOn != "1" {
                    isHaveFailure = true
                    break
                }
            }
            
            if isHaveFailure {
                HUD_MB.showWarnig("Please delete unavailable items!", onView: self.view)
            } else {
                self.cartView.disAppearAction()
                let nextVC = ScanConfirmOrderController()
                nextVC.storeID = self.storeID
                nextVC.deskID = self.deskID
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
        
        view.clickCartBlock = { [unowned self] (_) in
            //弹出购购物车
            if cartModel.dishesList.count != 0 {
                if self.cartView.isHidden {
                    self.cartView.appearAction()
                } else {
                    self.cartView.disAppearAction()
                }
            }
        }
        
        return view
    }()

    
    ///购物车弹窗
    private lazy var cartView: MenuCartView = {
        let view = MenuCartView()
        view.storeID = self.storeID
        return view
    }()

    
    private lazy var colleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        let W = (S_W - 45) / 2
        layout.itemSize = CGSize(width: W , height: 100)
        layout.sectionInset = UIEdgeInsets(top: 25, left: 15, bottom: 20, right: 15)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(DineInClassifyCell.self, forCellWithReuseIdentifier: "DineInClassifyCell")
        
        return coll
    }()
    
    

    override func setNavi() {
        naviBar.isHidden = true
    }
    
    
    override func setViews() {
        setUpUI()
        loadDeskDetail_Net()
        loadStoreDetail_Net()
        addNotificationCenter()
    }
    

    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        view.addSubview(headerBar)
        headerBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        
        view.addSubview(headerView)
        
        view.addSubview(backView_fl)
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(bottomBarH + 75)
        }

        
        backView_fl.addSubview(colleciton)
        colleciton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        
        view.addSubview(cartView)
        
        cartView.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(10))
            $0.right.equalToSuperview().offset(-R_W(10))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 15)
            $0.height.equalTo(50)
        }
                
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DineInClassifyCell", for: indexPath) as! DineInClassifyCell
        cell.setCellData(model: dataArr[indexPath.item])
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderVC = DineInOrderController()
        orderVC.cartModel = cartModel
        orderVC.classifyID = dataArr[indexPath.item].dineClassifyId
        orderVC.deskID = deskID
        orderVC.storeID = storeID
        orderVC.isVip = storeInfo.isVip
        let name = dataArr[indexPath.item].name_C == "" ? dataArr[indexPath.item].dineName : dataArr[indexPath.item].name_C
        orderVC.titStr = name
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("cartRefresh"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pageRefresh"), object: nil)
        print("\(self.classForCoder)销毁了")
    }

}


extension DineInFirstController {
    
    
    
    //MARK: - 请求店铺详情
    private func loadStoreDetail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.Store_MainPageData(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
        
            storeInfo.updateModel(json: json["data"])
            loadUserVip_Net()
            loadClassifyList_Net()

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 请求餐桌信息
    private func loadDeskDetail_Net() {
        HTTPTOOl.getDeskDetail(id: deskID).subscribe(onNext: { [unowned self] (json1) in
            headerBar.titLab.text = "Table 餐桌:\(json1["data"]["deskName"].stringValue)"
        }).disposed(by: bag)
    }
    
    
    //MARK: - 用户的Vip
    private func loadUserVip_Net() {
        HTTPTOOl.getUserVip(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
            storeInfo.isVip = json["data"]["vipType"].stringValue == "2" ? true: false
            storeInfo.vipAmount = D_2_STR(json["data"]["amount"].doubleValue) 
            storeInfo.updateStoreInfo_H()
            headerView.setData(model: storeInfo)
            cartView.isVip = storeInfo.isVip
            remakeFrame()
        }).disposed(by: bag)
    }

    
    
//    //MARK: - 请求是否有首单优惠
//    private func loadStoreDetailFirstDiscount_Net() {
//        HTTPTOOl.getStoreDetailFirstDiscount(storeID: storeID).subscribe(onNext: { [unowned self] json in
//            storeInfo.isFirstDiscount = json["data"]["firstType"].stringValue == "2" ? true : false
//            //storeInfo.updateStoreInfo_H()
//            headerView.setData(model: storeInfo)
//            loadClassifyList_Net()
//            
//        }, onError: { [unowned self] (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }).disposed(by: self.bag)
//    }
    
    //MARK: - 请求菜品信息
    private func loadClassifyList_Net() {
    
        HTTPTOOl.getDineInClassifyList(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
            
            var tArr: [DineInClassifyModel] = []
            
            for jsonData in json["data"].arrayValue {
                let model = DineInClassifyModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            colleciton.reloadData()
            loadCartData_Net()
                        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
    private func remakeFrame() {
        headerView.snp.remakeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(0)
            $0.height.equalTo(storeInfo.scanContent_H)
        }
        
        backView_fl.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom).offset(5)
        }
    }
    
    //MARK: - 已添加购物车的菜品
    func loadCartData_Net() {
        
        HTTPTOOl.getAddedCartDishes(storeID: storeID, psType: "3").subscribe(onNext: { [unowned self] (json) in

            cartModel.updateModel(json: json)
        
            ///赋值购物车弹窗
            cartView.cartDataArr = cartModel.dishesList
                    
            
            ///更新底部购物车栏
            bottomBar.setBuyCount(number: cartModel.dishesNum)
            
            b_view.setValue(dishMoney: D_2_STR(cartModel.allPrice), buyCount: cartModel.dishesNum, discountType: cartModel.discountType, discountMoney: D_2_STR(cartModel.discountAmount), minOrder: "0", type: cartModel.deliveryType)

            HUD_MB.dissmiss(onView: self.view)

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

    
    //MARK: - 呼叫服务员
    private func callWaiter_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.callWaiterByDesk(deskID: deskID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Call successful", onView: view)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: bag)
    }

}



extension DineInFirstController {
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartDataRefresh(info:)), name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pageDataRefresh), name: NSNotification.Name(rawValue: "pageRefresh"), object: nil)
    }
    
    
    
    @objc private func cartDataRefresh(info: Notification) {
    
        let type = info.object as? String
        
        //如果接收到的type == "1" 不需要请求接口
        if type ?? "" == "1" {
            ///赋值购物车弹窗
            cartView.cartDataArr = self.cartModel.dishesList
            ///更新底部购物车栏
            bottomBar.setBuyCount(number: cartModel.dishesNum)
            b_view.setValue(dishMoney: D_2_STR(self.cartModel.allPrice), buyCount: self.cartModel.dishesNum, discountType: self.cartModel.discountType, discountMoney: D_2_STR(self.cartModel.discountAmount), minOrder: "0", type: self.cartModel.deliveryType)
            
        } else {
            loadCartData_Net()
        }
    }
    
    @objc private func pageDataRefresh() {
        loadStoreDetail_Net()
    }
    
}

    

    

