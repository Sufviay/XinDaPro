//
//  MealSelectSizeController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/17.
//

import UIKit
import RxSwift

class MealSelectSizeController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let bag = DisposeBag()
    
    private let manager = MenuOrderManager()
    
    var isSearchVC: Bool = false
    
    var dishesID: String = ""
    
    var canBuy: Bool = false
    
    var deskID: String = ""
    
    ///选择数量
    private var dishCount: Int = 1
    private var dishModel = DishModel() {
        didSet {
            self.selectIdxArr.removeAll()
            for _ in dishModel.comboList {
                //let idx = 1000
                self.selectIdxArr.append(1000)
            }
        }
    }
    
    private var info_H: CGFloat = 0
    
    //选中的菜品下标
    private var selectIdxArr: [Int] = []

    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        but.backgroundColor = .black.withAlphaComponent(0.5)
        but.layer.cornerRadius = 35 / 2
        return but
    }()
    
    
    private lazy var b_view: DishDetailBottmView = {
        let view = DishDetailBottmView()
        view.setButTitleType(canBuy: canBuy, cartID: "")
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
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.showsVerticalScrollIndicator = false
        coll.contentInsetAdjustmentBehavior = .never
        coll.register(MenuComboDishCell.self, forCellWithReuseIdentifier: "MenuComboDishCell")
        coll.register(DishDetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DishDetailHeaderCell")
        
        return coll
    }()
    
    

    override func setNavi() {
        
    }
    
    override func setViews() {
        view.backgroundColor = .white
        self.naviBar.isHidden = true
        loadDishedDetail_Net()
        
    }
    
    private func setUpUI() {
        
        
        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(bottomBarH + 50)
        }

        
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(b_view.snp.top)
        }
        
        
        t_view.setCellData(model: dishModel, selectCount: dishCount, canBuy: canBuy)
        collection.addSubview(t_view)
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
        
        //判断菜品是否选择齐全
        if PJCUtil.checkLoginStatus() {
            
            var canOrder: Bool = true
            
            for int in selectIdxArr {
                if int == 1000 {
                    HUD_MB.showWarnig("Required option not completed", onView: self.view)
                    canOrder = false
                    break
                }
            }
            
            if canOrder {
                self.addOrder_Net()
            }
            
        }
    }

}


extension MealSelectSizeController {
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
            
            self.collection.contentInset = UIEdgeInsets(top: self.info_H, left: 0, bottom: 0, right: 0)
            self.setUpUI()
            
                    
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 网络请求
    ///提交
    private func addOrder_Net() {
        HUD_MB.loading("", onView: view)
        let selectOption = manager.getComboDicBySelected(selectIdxArr: selectIdxArr, dishModel: dishModel)
        //添加购物车
        HTTPTOOl.addShoppingCart(dishesID: dishModel.dishID, buyNum: String(dishCount), type: "2", optionList: selectOption, deskID: deskID).subscribe(onNext: { [unowned self] (json) in
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



extension MealSelectSizeController {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dishModel.comboList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishModel.comboList[section].comboDishesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuComboDishCell", for: indexPath) as! MenuComboDishCell
        
        let isSelected = selectIdxArr[indexPath.section] == indexPath.item ? true : false
        cell.setCellData(model: dishModel.comboList[indexPath.section].comboDishesList[indexPath.item], isSelet: isSelected)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectIdxArr[indexPath.section] == indexPath.item {
            selectIdxArr[indexPath.section] = 1000
        } else {
            selectIdxArr[indexPath.section] = indexPath.item
        }
        collectionView.reloadData()
    }
    
    
    //设置每一个Item的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let c_w = (S_W - 60) / 3
        
        return CGSize(width: c_w, height: dishModel.comboList[indexPath.section].comboDishesList[indexPath.item].cell_H)
        
    }
    
    
    
    //设置分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            //分区头
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DishDetailHeaderCell", for: indexPath) as! DishDetailHeaderCell
            header.titlab.text = dishModel.comboList[indexPath.section].comboSpecName
            return header
            
        } else {
            //分区尾
            return UICollectionReusableView()
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let c_name = dishModel.comboList[section].comboSpecName
        let h = c_name.getTextHeigh(BFONT(24), S_W - 40)
        return CGSize(width: S_W, height: h + 20)
    }
}


