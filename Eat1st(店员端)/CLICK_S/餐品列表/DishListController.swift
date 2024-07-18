//
//  DishListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit
import RxSwift
import MJRefresh


class DishListController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    private let bag = DisposeBag()
    
    
    var titStr: String = ""
    var deskID: String = ""
    
    ///附加菜品
    var attachDataArr: [AttachClassifyModel] = []
    ///分类数据
    private var classifyData = ClassifyDataModel()
    
    ///成人数量
    var ad_Count: Int = 0
    ///儿童数量
    var ch_Count: Int = 0
    
    ///所有的数据
    private var dataArr: [DishDisplayModel] = []
    ///用于展示的数据
    private var showDataArr: [DishDisplayModel] = []
    ///购物车中的菜品模型
    private var cartData = CartModel()
    
    ///菜品显示（1编号，2名称，3编号和名称）
    private var showType: String = "1"
    ///菜品列数
    private var colNum: Int = 4
    ///选择的分类
    private var selectID_C: String = ""
    
    private var selectIndexPath: IndexPath?
    
    
    private lazy var headerView: DishListHeaderView = {
        let view = DishListHeaderView()
        view.titLab.text = titStr
        view.clickHomeBlock = { [unowned self] (_) in
            navigationController?.popViewController(animated: true)
        }
        view.clickMenuBlock = { [unowned self] (_) in
            //打开筛选框
            sxView.appearAction()
        }
        
        view.clickShouqiBlock = { [unowned self] (_) in
            //全部收起分组
            for model in showDataArr {
                model.isShow = false
            }
            colleciton.reloadData()
        }
        
        view.clickScanBlock = { [unowned self] (_) in
            ///打开扫一扫
            scanAction()
        }
        
        return view
    }()
    
    ///底部购物车
    private lazy var b_cartView: CartConfirmView = {
        let view = CartConfirmView()
        
        view.clickCartBlock = { [unowned self]  (_) in
            if cartAlert.isHidden {
                cartAlert.appearAction()
            } else {
                cartAlert.disAppearAction()
            }
        }
        
        
        view.clickConfirmBlock = { [unowned self]  (_) in
            
            if cartAlert.isHidden {
                cartAlert.appearAction()
            } else {
                if cartData.dishesList.count != 0 {
                    cartAlert.disAppearAction()
                    createOrder_Net()
                }

            }
        }
        
        return view
    }()
    
    ///购物车弹窗
    private lazy var cartAlert: CartView = {
        let view = CartView()
        view.dataModel = cartData
        
        view.cleanAllBlock = { [unowned self] _ in
            //清除购物车
            b_cartView.updateData(price: "0", data: cartData)
        }
        
        view.deleteBlock = { [unowned self] _ in
            //删除菜品 计算菜品价格
            doCalOrder_Net()
        }
        
        view.editPriceBlock = { [unowned self] _ in
            //编辑菜品价格
            doCalOrder_Net()
        }
        
        view.detailBlock = { [unowned self] (idx) in
            //进入详情
            detailView.dishID = cartData.dishesList[idx].dishesId
            detailView.deskID = deskID
            detailView.buyNum = cartData.dishesList[idx].buyNum
            detailView.cartAttachArr = cartData.dishesList[idx].attachList
            detailView.cartSelectItemArr = cartData.dishesList[idx].itemList
            detailView.cartEditIdx = idx
            detailView.cartDishPrice = cartData.dishesList[idx].price
            detailView.isEdit = true
            detailView.appearAction()
        }
        
        return view
    }()
    
    private lazy var colleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(DishCollCell_Code.self, forCellWithReuseIdentifier: "DishCollCell_Code")
        coll.register(DishCollCell_Name.self, forCellWithReuseIdentifier: "DishCollCell_Name")
        coll.register(DishClassifyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DishClassifyHeader")

        return coll
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        return view
    }()

    private lazy var vipView: UserVipView = {
        let view = UserVipView()
        return view
    }()
    
    
    
    //筛选提示框
    private lazy var sxView: ScreenView = {
        let view = ScreenView()
        
        view.clickConfirmBlock = { [unowned self] info in
                
            let dic = info as! [String: Any]
            colNum = dic["num"] as! Int
            showType = dic["type"] as! String
            let selID = dic["cID"] as! String

            
            if selID != selectID_C {

                selectID_C = selID
                
                //通过ID进行筛选
                if selectID_C == "" {
                    showDataArr = dataArr.map { $0.copy() }
                } else {
                    filtrateDishes()
                }
                
                noDataView.removeFromSuperview()
                
                if showDataArr.count == 0 {
                    colleciton.addSubview(noDataView)
                    noDataView.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 300, height: 300))
                        $0.center.equalToSuperview()
                    }
                }
                
                colleciton.reloadData()
            }
        }
        
        return view
    }()
    

    
    //菜品详情
    private lazy var detailView: DishDetailView = {
        let view = DishDetailView()
        view.attachDataArr = attachDataArr
        
        //添加购物车菜品
        view.addBlock = { [unowned self] (info) in
            
            let dic = info as! [String: Any]
            let num = dic["num"] as! Int
            let selectOption = dic["opt"] as! [OptionModel]
            let selectCombo = dic ["com"] as! [ComboDishesModel]
            let selectAtt = dic["att"] as! [AttachModel]
            let dish = dic["dish"] as! DishModel
         
            dishAddCart(dish: dish, selectOption: selectOption, selectCombo: selectCombo, attach: selectAtt, buyNum: num)
            doCalOrder_Net()
        }
        
        
        //编辑购物车菜品
        view.editBlock = { [unowned self] (info) in
            let dic = info as! [String: Any]
            let num = dic["num"] as! Int
            let selectOption = dic["opt"] as! [OptionModel]
            let selectCombo = dic ["com"] as! [ComboDishesModel]
            let selectAtt = dic["att"] as! [AttachModel]
            let dish = dic["dish"] as! DishModel
            let idx = dic["idx"] as! Int
            
            //更新购物车数据
            cartData.dishesList[idx].updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: selectAtt)
            cartData.dishesList[idx].buyNum = num
            cartAlert.updateData()
            doCalOrder_Net()
        }
        
        return view
    }()
    
    override func setViews() {
        setUpUI()
        loadData_Net()
        addNotification()
    }
    
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("#F7F6FA")
        naviBar.isHidden = true
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + NAV_H())
        }

//        view.addSubview(vipView)
//        vipView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalTo(headerView.snp.bottom).offset(5)
//            $0.height.equalTo(100)
//        }
//        
        view.addSubview(colleciton)
        colleciton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 65 - 10)
        }
        

        view.addSubview(cartAlert)
        cartAlert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(b_cartView)
        b_cartView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(bottomBarH + 65)
        }
        
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
        colleciton.reloadData()
        sxView.collection.reloadData()
        DispatchQueue.main.async {
            print("----------W:\(UIScreen.main.bounds.width)\n----------H:\(UIScreen.main.bounds.height)")
            self.cartAlert.updateFrame()
        }
    }
    
    
    //MARK: - 扫一扫
    func scanAction() {
        let scanVC = ScanViewController()
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        style.colorAngle = MAINCOLOR
        scanVC.scanStyle = style
        
        scanVC.scanFinshBlock = { [unowned self] (str) in
            print(str)
        }
        
        scanVC.modalPresentationStyle = .fullScreen
        self.present(scanVC, animated: true, completion: nil)
        
    }

}


extension DishListController {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return showDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let model = showDataArr[section]
        
        if model.isShow {
            return showDataArr[section].dishesArr.count
        } else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = showDataArr[indexPath.section].dishesArr[indexPath.row]
        
        let isSel = indexPath == selectIndexPath ? true : false
        
        if showType == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollCell_Code", for: indexPath) as! DishCollCell_Code
            cell.setCellData(code: model.dishesCode, isSel: isSel)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollCell_Name", for: indexPath) as! DishCollCell_Name
            cell.setCellData(model: model, type: showType, colNum: colNum, isSel: isSel)
            return cell
        }
    }
    
    
    
    //设置分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            //分区头
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DishClassifyHeader", for: indexPath) as! DishClassifyHeader
            
            header.setCellData(titStr: showDataArr[indexPath.section].classifyName, isShow: showDataArr[indexPath.section].isShow)
            
            header.clickBlock = { [unowned self] (_) in
                showDataArr[indexPath.section].isShow = !showDataArr[indexPath.section].isShow
                collectionView.reloadData()
            }
            
            return header
        }

        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }

    //设置每一个Item的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = (UIScreen.main.bounds.width - CGFloat(colNum + 1) * 15) / CGFloat(colNum)
        var h: CGFloat = 0
        if showType == "1" {
            //编号
            h = 80
        } else {
            h = 115
        }
        return CGSize(width: w, height: h)
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectIndexPath = indexPath
        
        collectionView.reloadData()
        
        let dishMmodel = showDataArr[indexPath.section].dishesArr[indexPath.row]
        //如果是单品且无规格
        if dishMmodel.dishesType == "1" && dishMmodel.haveSpec == "2" {
            //直接加入购物车
            dishAddCart(dish: dishMmodel, selectOption: [], selectCombo: [], attach: [], buyNum: 1)
            doCalOrder_Net()
            
        } else {
            //进入菜品详情
            detailView.deskID = deskID
            detailView.dishID = dishMmodel.dishesId
            detailView.appearAction()
        }
    }
    
}

extension DishListController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDishesList(deskID: deskID).subscribe(onNext: { [unowned self] (json1) in
            
            //获取菜品分类数据
            HTTPTOOl.getDishesClassiftyList().subscribe(onNext: { [unowned self] (json2) in
                
                classifyData.updateModel(json: json2["data"])
                
                HUD_MB.dissmiss(onView: view)
                
                var tArr: [DishModel] = []
                for jsonData in json1["data"].arrayValue {
                    let model = DishModel()
                    model.updateModel(json: jsonData)
                    
                    if classifyData.waiterClassifyStatus == "1" {
                        //如果是多级分类开启了 要更新菜品的一级二级分类
                        for r_model in classifyData.relevanceList {
                            if r_model.dishesId == model.dishesId {
                                model.F_classifyIds.append(r_model.classifyOneId)
                                model.S_classifyIds.append(r_model.classifyTwoId)
                            }
                        }
                    }
                
                    tArr.append(model)
                }
                
                dealDishesData(dishesArr: tArr)
                
                if dataArr.count == 0 {
                    colleciton.addSubview(noDataView)
                    noDataView.snp.remakeConstraints {
                        $0.size.equalTo(CGSize(width: 300, height: 300))
                        $0.center.equalToSuperview()
                    }
                } else {
                    noDataView.removeFromSuperview()
                }
                colleciton.reloadData()
                //筛选框赋值
                sxView.allDishes = dataArr
                sxView.classifyData = classifyData
                sxView.appearAction()
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }).disposed(by: bag)
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    

    
    //MARK: - 下单计算价格 每次菜品添加购物车时需要调用，计算出菜品的价格
    private func doCalOrder_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCalOrder(deskID: deskID, dishesArr: cartData.dishesList).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            //更新价格 更新底部购物车
            b_cartView.updateData(price: D_2_STR(json["data"]["orderPrice"].doubleValue), data: cartData)
//            cartAlert.updateData(f_d_price: D_2_STR(json["data"]["dishesPrice"].doubleValue), ser_price: D_2_STR(json["data"]["servicePrice"].doubleValue))
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //MARK: - 下单
    private func createOrder_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCreateOrder(deskID: deskID, dishesArr: cartData.dishesList, adultNum: ad_Count, childNum: ch_Count).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            //下单成功
            
            let rootVC: UIViewController = navigationController?.viewControllers.first ?? DeskListController()
            let orderListVC = DeskOrderListController()
            orderListVC.deskID = deskID
            orderListVC.titStr = titStr
            orderListVC.deskStatus = .Process
            orderListVC.attachDataArr = attachDataArr
            
            navigationController?.setViewControllers([rootVC, orderListVC], animated: true)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)

    }
    
    
//    //MARK: - 获取用户会员信息
//    private func getUserVipInfo_Net(token: String) {
//        HUD_MB.loading("", onView: view)
//        HTTPTOOl.getUserByToken(token: token).subscribe(onNext: { [unowned self] (json) in
//            HUD_MB.dissmiss(onView: view)
//            //根据信息更新页面
//            
//            
//            
//        }, onError: { [unowned self] (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
//        }).disposed(by: bag)
//    }
}


extension DishListController {
    
    ///菜品添加购物车
    private func dishAddCart(dish: DishModel, selectOption: [OptionModel], selectCombo: [ComboDishesModel], attach: [AttachModel], buyNum: Int)  {
        
        /**
         判断添加的菜品在购物车中是合并数量还是 新的菜品
         合并的条件：
         菜品不为空 ,  最后一个菜品不是叫起状态， 当菜品的ID、菜品选的规格相同、菜品选择的套餐相同、菜品选择的附加、菜品的printSort也相同时合并， 数量+1
        */
        
        /**
         * 根据分隔线情况，给菜品设置分组参数
         * 如果“叫起”为开始，那么printSort从1（可能是100）开始计数，否则从2（可能是99）开始
         * 如果“叫起”为结束，那么printSort从99结束，否则正常计数结束
         * 如果只有一组printSort，开始时有“叫起”，结束时有“叫起”时：printSort = 100
         * 如果只有一组printSort，开始时没有“叫起”，结束时有“叫起”时 printSort = 99
         */
        
        if cartData.dishesList.count == 0 {
            //没有菜 创建购物车菜品直接添加
            let cartDishModel = CartDishModel()
            cartDishModel.updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: attach)
            cartDishModel.buyNum = buyNum
            
            //处理printSort
            if cartData.showJiaoqi {
                cartDishModel.printSort = 1
            } else {
                cartDishModel.printSort = 2
            }
            cartData.dishesList.append(cartDishModel)
            
        } else {
            //有菜 需要进行判断
            
            //如果最后一个菜品是叫起状态的 直接创建菜品添加
            if cartData.dishesList.last!.showJiaoqi {
                let cartDishModel = CartDishModel()
                cartDishModel.updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: attach)
                cartDishModel.buyNum = buyNum
                //printSort是最后一个菜的printSort+1
                cartDishModel.printSort = cartData.dishesList.last!.printSort + 1
                cartData.dishesList.append(cartDishModel)
            } else {
                //查看是否可以进行合并
                ///选择的规格ID拼接的字符串
                var specStr = ""
                for spec in selectOption {
                    specStr += spec.optionId + ","
                }
                ///选择的套餐ID拼接的字符串
                var comStr = ""
                for com in selectCombo {
                    comStr += com.dishesComboRelId + ","
                }
                ///选择的附加ID拼接的字符串
                var attStr = ""
                for att in attach {
                    attStr += att.attachId + ","
                }
                
                ///是否存在一样的菜品
                var isHave: Bool = false

                ///当前的 printSort 的值
                let curPrintSort = cartData.dishesList.last!.printSort
                

                for cartDish in cartData.dishesList {
                
                    ///菜品不为空 ,  最后一个菜品不是叫起状态， 当菜品的ID、菜品选的规格相同、菜品选择的套餐相同、菜品选择的附加、菜品的printSort也相同时合并， 数量+1
                        
                    var cartItemIDStr = ""
                    for model in cartDish.itemList {
                        cartItemIDStr += model.itemID + ","
                    }
    
                    
                    var cartAttIDStr = ""
                    for model in cartDish.attachList {
                        cartAttIDStr += model.itemID + ","
                    }
                    
                    if dish.dishesType == "1" {
                        //单品菜
                        ///规格用字符串进行比对
                        if cartDish.dishesId == dish.dishesId && cartDish.printSort == curPrintSort && cartItemIDStr == specStr && cartAttIDStr == attStr {
                            isHave = true
                            //购物车中数量添加
                            cartDish.buyNum += buyNum
                            break
                        }
                    } else {
                        //套餐
                        ///套餐用字符串进行比对
                        if cartDish.dishesId == dish.dishesId && cartDish.printSort == curPrintSort && cartItemIDStr == comStr && cartAttIDStr == attStr {
                            isHave = true
                            //购物车中数量添加
                            cartDish.buyNum += buyNum
                            break
                        }
                    }
                }
                
                if !isHave {
                    //不存在的菜 创建购物车菜品直接添加 printSort为最后一个菜品的值
                    let cartDishModel = CartDishModel()
                    cartDishModel.updateModel(model: dish, selectOption: selectOption, selectCombo: selectCombo, selectAttach: attach)
                    cartDishModel.buyNum = buyNum
                    //printSort是最后一个菜的printSort
                    cartDishModel.printSort = cartData.dishesList.last!.printSort
                    cartData.dishesList.append(cartDishModel)
                }
            }
        }
        
        cartAlert.updateData()
    }
}


extension DishListController {
    
    
    ///对菜品进行首字母分类
    private func dealDishesData(dishesArr: [DishModel]) {
        
        let charArr0: [String] = ["#"]
        let charArr1: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let charArr2: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51"]
        
        
        var tarr0: [DishDisplayModel] = []
        var tarr1: [DishDisplayModel] = []
        var tarr2: [DishDisplayModel] = []
        
        for str in charArr0 {
            let model = DishDisplayModel()
            model.classifyName = str
            tarr0.append(model)
        }
        
        for str in charArr1 {
            let model = DishDisplayModel()
            model.classifyName = str
            tarr1.append(model)
        }
        
        for str in charArr2 {
            let model = DishDisplayModel()
            model.classifyName = str
            tarr2.append(model)
        }


        
        //处理菜品数据
        for dish in dishesArr {
            print("_________________" + dish.dishesCode)
            
            if dish.dishesCode == "" {
                tarr0.first!.dishesArr.append(dish)
            } else {
                //提取首字母
                let first_C: String = dish.dishesCode.substring(to: 1)
                print(first_C)

                                
                var isContains: Bool = false
                
                for model in tarr1 {
                    if model.classifyName.localizedCaseInsensitiveContains(first_C) {
                        model.dishesArr.append(dish)
                        isContains = true
                    }
                }
                
                if !isContains {
                    //查找数字 去前两位
                    let s = dish.dishesCode.prefix(2)

                    print(s)
                    
                    let second_C: String = dish.dishesCode.substring(to: 2)
                    print("++++++++++++++++++" + second_C)
                    
                    for model in tarr2 {
                        if model.classifyName.localizedCaseInsensitiveContains(second_C) {
                            model.dishesArr.append(dish)
                            isContains = true
                        }
                    }
                }
                
                if !isContains {
                    //不包含
                    tarr0.first!.dishesArr.append(dish)
                }
            }
            
        }
        
        dataArr = tarr0.filter { $0.dishesArr.count != 0 } + tarr1.filter { $0.dishesArr.count != 0 } + tarr2.filter { $0.dishesArr.count != 0 }
        showDataArr = dataArr.map { $0.copy() }
        
    }
    
    ///筛选菜品
    private func filtrateDishes() {
        showDataArr = dataArr.map { $0.copy() }
        for model in showDataArr {
            if classifyData.waiterClassifyStatus == "1" {
                //开启服务员分类
                model.dishesArr = model.dishesArr.filter { $0.S_classifyIds.contains(selectID_C) }
            }
            
            if classifyData.waiterClassifyStatus == "2" {
                //关闭
                model.dishesArr = model.dishesArr.filter { $0.classifyId == selectID_C }
            }
        }
        
        showDataArr = showDataArr.filter { $0.dishesArr.count != 0 }
    }
    
}







//    ///菜品编码
//    private lazy var codeInputView: CodeView = {
//        let view = CodeView()
//        view.isHidden = true
//
//        view.codeFilterBlock = { [unowned self] info in
//
//            sxView.resetFilter()
//
//            let dic = info as! [String: Any]
//            screenKey = dic["key"] as! String
//            screenDataArr = dic["arr"] as! [DishModel]
//
//            noDataView.removeFromSuperview()
//
//            if screenKey != "" {
//                if screenDataArr.count == 0 {
//                    colleciton.addSubview(noDataView)
//                } else {
//                    noDataView.removeFromSuperview()
//                }
//            } else {
//                if allDataArr.count == 0 {
//                    colleciton.addSubview(noDataView)
//                } else {
//                    noDataView.removeFromSuperview()
//                }
//            }
//            colleciton.reloadData()
//        }
//
//        return view
//    }()







//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if section == 0 {
//            if screenKey == "" {
//                return 0
//            }
//            return 1
//        }
//
//        if section == 1 {
//            if screenKey == "" {
//                return allDataArr.count
//            }
//            return screenDataArr.count
//
//        }
//
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            if screenKey == "" {
//                return allDataArr[indexPath.row].dish_H
//            }
//            return screenDataArr[indexPath.row].dish_H
//        }
//
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DishesKeyWordsCell") as! DishesKeyWordsCell
//            cell.setCellData(key: screenKey)
//            return cell
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell") as! DishCell
//
//        var dishMmodel = DishModel()
//        if screenKey == "" {
//            dishMmodel = allDataArr[indexPath.row]
//        } else {
//            dishMmodel = screenDataArr[indexPath.row]
//        }
//
//         cell.setCellData(model: dishMmodel)
//
//        cell.clickDetailBlock = { [unowned self] (_) in
//            //进入菜品详情
//            detailView.deskID = deskID
//            detailView.dishID = dishMmodel.dishesId
//            detailView.appearAction()
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        var dishMmodel = DishModel()
//        if screenKey == "" {
//            dishMmodel = allDataArr[indexPath.row]
//        } else {
//            dishMmodel = screenDataArr[indexPath.row]
//        }
//
//        //如果是单品且无规格
//        if dishMmodel.dishesType == "1" && dishMmodel.haveSpec == "2" {
//            //直接加入购物车
//            dishAddCart(dish: dishMmodel, selectOption: [], selectCombo: [], attach: [], buyNum: 1)
//            doCalOrder_Net()
//
//        } else {
//            //进入菜品详情
//            detailView.deskID = deskID
//            detailView.dishID = dishMmodel.dishesId
//            detailView.appearAction()
//        }
//    }



//    @objc func clickCodeAction() {
//        if isShowCode {
//            isShowCode = false
//            codeBut.isSelect = isShowCode
//            codeInputView.isHidden = true
//            colleciton.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.top.equalTo(naviBar.snp.bottom).offset(10)
//                $0.bottom.equalToSuperview().offset(-bottomBarH - 65 - 10)
//            }
//        } else {
//            isShowCode = true
//            codeInputView.isHidden = false
//            codeBut.isSelect = isShowCode
//            colleciton.snp.remakeConstraints {
//                $0.left.right.equalToSuperview()
//                $0.top.equalTo(naviBar.snp.bottom).offset(10)
//                $0.bottom.equalTo(codeInputView.snp.top).offset(-10)
//            }
//        }
//    }
