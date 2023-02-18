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
    
    var dishesID: String = ""
    
    ///选择数量
    private var dishCount: Int = 1
    private var dishModel = DishModel() {
        didSet {
            self.selectIdxArr.removeAll()
            for _ in dishModel.comboList {
                //let idx = 1000
                self.selectIdxArr.append(1000)
            }
            self.b_view.moneyLab.text = dishModel.discountType == "2" ? D_2_STR(dishModel.discountPrice) : D_2_STR(dishModel.price)
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
        return view
    }()

    private lazy var t_view: DishDetailInfoView = {
        let view = DishDetailInfoView()
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
        coll.register(MenuComboDishCell.self, forCellWithReuseIdentifier: "MenuComboDishCell")
        coll.register(DishDetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DishDetailHeaderCell")
        return coll
    }()
    
    

    override func setViews() {
        view.backgroundColor = .white
        self.naviBar.isHidden = true
            
        loadDishedDetail_Net()
        
    }
    
    private func setUpUI() {
        
        t_view.setCellData(model: self.dishModel, selectCount: self.dishCount)
        
        view.addSubview(t_view)
        t_view.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(info_H)
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        

        
        view.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(bottomBarH + 50)
        }
        
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(t_view.snp.bottom).offset(0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(b_view.snp.top)
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
            
    }
    
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickAddOrderAction() {
        
//        if PJCUtil.checkLoginStatus() {
//            if !manager.dishSizeIsSelected(dishModel: dishModel, selectIdxArr: selecIdxArr) {
//                HUD_MB.showWarnig("Required option not completed", onView: self.view)
//                return
//            }
//            self.addOrder_Net()
//        }
    }

}


extension MealSelectSizeController {
    ///获取菜品详情
    private func loadDishedDetail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loadDishesDetail(dishesID: dishesID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            let model = DishModel()
            model.updateModel(json: json["data"])
            self.dishModel = model
            
            //self.mainTable.reloadData()
            
            
            //计算菜品详情视图的高度
            let str = "Allergen: " + self.dishModel.allergen
            let g_h = str.getTextHeigh(BFONT(13), S_W - 130)
            let d_h = self.dishModel.des.getTextHeigh(SFONT(13), S_W - 120)
            let n_h = self.dishModel.name_C.getTextHeigh(BFONT(17), S_W - 50)
            self.info_H = (R_W(375) * (9/16)) + g_h + d_h + n_h + 50
            self.setUpUI()
            
                    
        }, onError: { (error) in
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


