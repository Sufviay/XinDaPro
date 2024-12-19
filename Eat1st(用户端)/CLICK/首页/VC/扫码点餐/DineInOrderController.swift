//
//  DineInOrderController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/25.
//

import UIKit
import RxSwift

class DineInOrderController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, CAAnimationDelegate {


    ///分类ID
    var classifyID: String = ""
    ///餐桌ID
    var deskID: String = ""
    ///店铺ID
    var storeID: String = ""
    
    var titStr: String = ""
    
    ///是否是会员
    var isVip: Bool = false
    
    
    private var bag = DisposeBag()
    
    ///店铺菜品模型
    private var menuInfo = MenuModel()
    
    ///菜品模型
    //private var dataArr: [DishModel] = []
    
    ///购物车的数据模型
    var cartModel = CartDataModel()
    
    
    lazy var viewArray: [UIView] = {
        let viewArray: [UIView] = []
        return viewArray
    }()

    
    ///时间段视图
    private lazy var timeTabView: DineInTimeTabView = {
        let timeView = DineInTimeTabView()
        
        timeView.selectBlock = { [unowned self] (idx) in
            menuInfo.curTimeIdx = idx as! Int
            colleciton.setContentOffset(.zero, animated: false)
            ///刷新列表
            colleciton.reloadData()
        }

        
        return timeView
    }()
    
    
    
    private lazy var colleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let W = (S_W - 40) / 3
        layout.itemSize = CGSize(width: W , height: W + 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(DineInMenuDishCell_C.self, forCellWithReuseIdentifier: "DineInMenuDishCell_C")
        
        return coll
    }()
    
    
    
    
    ///底部价格栏
    private lazy var b_view: DineInBottomToolView = {
        let view = DineInBottomToolView()
        view.isHidden = true
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
        view.isSearchVC = true
        view.storeID = self.storeID
        view.isVip = self.isVip
        return view
    }()

    
    override func setNavi() {
        naviBar.rightBut.isHidden = true
        naviBar.leftImg = LOIMG("nav_back")
        naviBar.headerTitle = titStr
    }
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
        addNotificationCenter()
    }
    
    
    private func setUpUI() {
        
        view.addSubview(timeTabView)
        timeTabView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom)
            $0.height.equalTo(40)
        }
        
        view.addSubview(colleciton)
        colleciton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50 - 15 - 10)
        }
        
        cartView.cartDataArr = cartModel.dishesList
        view.addSubview(cartView)
        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH - 15)
            $0.height.equalTo(50)
        }
    }
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuInfo.pageDishesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = menuInfo.pageDishesArr[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DineInMenuDishCell_C", for: indexPath) as! DineInMenuDishCell_C
        cell.setCellData(model: model, canBuy: menuInfo.canBuy, isVip: isVip)
        
        
        cell.clickAddBlock = { [unowned self] (_) in
            if model.isSelect || model.dishesType == "2" {
                //进入详情页面
                if model.dishesType == "1" {
                    //单品
                    let nextVC = SelectSizeController()
                    nextVC.dishesID = model.dishID
                    nextVC.canBuy = menuInfo.canBuy
                    nextVC.deskID = self.deskID
                    nextVC.isSearchVC = true
                    nextVC.isVip = isVip
                    nextVC.deType = "3"
                    navigationController?.pushViewController(nextVC, animated: true)
                }
                if model.dishesType == "2" {
                    //套餐
                    let nextVC = MealSelectSizeController()
                    nextVC.dishesID = model.dishID
                    nextVC.canBuy = menuInfo.canBuy
                    nextVC.deskID = self.deskID
                    nextVC.isSearchVC = true
                    nextVC.isVip = isVip
                    nextVC.deskID = "3"
                    navigationController?.pushViewController(nextVC, animated: true)
                }

            } else {
                //直接在购物车加1
                //let count = par as! Int
                
                let rec = cell.convert (cell.goodsImg.frame, to: PJCUtil.getWindowView())
                addAnimation(rect: rec)
                if model.sel_Num == 0 {
                    //添加购物车
                    addCart_Net(dishesID: model.dishID, buyNum: 1)
                } else {
                    //更新购物车
                    updateCart_Net(cartID: model.cart[0].cartID, buyNum: model.sel_Num + 1)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击进入菜品详情页页面
        let model = menuInfo.pageDishesArr[indexPath.row]

        if model.dishesType == "1" {
            //单品
            if model.isOn == "1" {
                let nextVC = SelectSizeController()
                nextVC.dishesID = model.dishID
                nextVC.canBuy = menuInfo.canBuy
                nextVC.deskID = deskID
                nextVC.isSearchVC = true
                nextVC.isVip = isVip
                nextVC.deType = "3"
                //如果不是规格规格商品 且已添加到购物车中 需将数量带到下一页面
                if !model.isSelect && model.cart.count != 0 {
                    nextVC.cartID = model.cart[0].cartID
                    nextVC.dishCount = model.sel_Num
                }

                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        if model.dishesType == "2" {
            //套餐
            let nextVC = MealSelectSizeController()
            nextVC.dishesID = model.dishID
            nextVC.canBuy = menuInfo.canBuy
            nextVC.deskID = deskID
            nextVC.isSearchVC = true
            nextVC.isVip = isVip
            nextVC.deType = "3"
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SearchRefresh"), object: nil)
        print("\(self.classForCoder)销毁了")
    }
}

extension DineInOrderController {
    
    //MARK: - 网络请求
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDineInDishesList(classifyID: classifyID).subscribe(onNext: { [unowned self] (json) in

            ///初始化菜单页面的数据
            menuInfo.updateDineInModel(json: json)
            ///设置时间段
            if menuInfo.openTimeArr.count == 0 || menuInfo.openTimeArr.count == 1 {
                //没有时间段
                timeTabView.isHidden = true
                colleciton.snp.remakeConstraints {
                    $0.top.equalTo(naviBar.snp.bottom).offset(0)
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-bottomBarH - 50 - 15 - 10)
                }
            } else {
                timeTabView.isHidden = false
                colleciton.snp.updateConstraints {
                    $0.top.equalTo(naviBar.snp.bottom).offset(40)
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-bottomBarH - 50 - 15 - 10)
                }
            }
            
            timeTabView.setData(timeArr: menuInfo.openTimeArr, selectIdx: menuInfo.curTimeIdx)
            
            ///根据购物车 处理页面数据
            menuInfo.dealWithMenuDishesByCartData(cart_arr: cartModel.dishesList)
            
            ///更新底部购物车栏
            b_view.setValue(dishMoney: D_2_STR(cartModel.allPrice), buyCount: cartModel.dishesNum, discountType: cartModel.discountType, discountMoney: D_2_STR(cartModel.discountAmount), type: cartModel.deliveryType)

            b_view.isHidden = false
            colleciton.reloadData()
            HUD_MB.dissmiss(onView: view)

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    

    //MARK: - 获取已添加购物车的菜品
    func loadCartData_Net() {
        
        HTTPTOOl.getAddedCartDishes(storeID: storeID, psType: "3").subscribe(onNext: { [unowned self] (json) in

            self.cartModel.updateModel(json: json)
        
            ///赋值购物车弹窗
            self.cartView.cartDataArr = cartModel.dishesList
    
            ///根据购物车 处理页面数据
            self.menuInfo.dealWithMenuDishesByCartData(cart_arr: cartModel.dishesList)
                        
            ///更新底部购物车栏
            self.b_view.setValue(dishMoney: D_2_STR(cartModel.allPrice), buyCount: cartModel.dishesNum, discountType: cartModel.discountType, discountMoney: D_2_STR(cartModel.discountAmount), type: cartModel.deliveryType)

            //发送通知 点菜页面刷新数据
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: "1")
            
            self.b_view.isHidden = false
            self.colleciton.reloadData()
            HUD_MB.dissmiss(onView: self.view)

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 添加购物车
    private func addCart_Net(dishesID: String, buyNum: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.addShoppingCart(dishesID: dishesID, buyNum: "1", type: "2", optionList: [], deskID: deskID).subscribe(onNext: { [unowned self] (json) in
            self.loadCartData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - 修改购物车
    private func updateCart_Net(cartID: String, buyNum: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.updateCartNum(buyNum: buyNum, cartID: cartID).subscribe(onNext: { [unowned self] (json) in
            self.loadCartData_Net()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}

extension DineInOrderController {
    private func addNotificationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageRefresh), name: NSNotification.Name(rawValue: "SearchRefresh"), object: nil)
        
    }
    
    @objc private func pageRefresh() {
        loadCartData_Net()
    }

}

extension DineInOrderController {
    

    
    func addAnimation(rect: CGRect) {
        
        autoreleasepool{
            let squr = UIView()
            squr.backgroundColor = UIColor.red
            squr.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            squr.layer.cornerRadius = 25/2
            squr.layer.masksToBounds = true
            PJCUtil.getWindowView().addSubview(squr)
            //self.view.insertSubview(squr, aboveSubview: self.tableview)
            self.viewArray.append(squr)
            
        }
        let lastSquar = self.viewArray.last
        let path =  CGMutablePath()
        let beginPoint = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2)
        
        path.move(to: beginPoint)
                
        path.addQuadCurve(to:CGPoint(x: 70, y: S_H - bottomBarH - 60),  control: CGPoint(x: 150, y: rect.origin.y))
        
        //获取贝塞尔曲线的路径
        let animationPath = CAKeyframeAnimation.init(keyPath: "position")
        animationPath.path = path
        animationPath.rotationMode = CAAnimationRotationMode.rotateAuto
        
        //缩小图片到0
        let scale:CABasicAnimation = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.toValue = 0.3
        
        //组合动画
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animationPath,scale];
        animationGroup.duration = 0.2;
        animationGroup.fillMode = CAMediaTimingFillMode.forwards;
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        lastSquar!.layer.add(animationGroup, forKey:
            nil)
    }

    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let redview = self.viewArray.first
        redview?.isHidden = true
        self.viewArray.remove(at: 0)
        
    }
    
}
