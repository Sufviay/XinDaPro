//
//  MealSelectSizeController.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/17.
//

import UIKit
import RxSwift

class MealSelectSizeController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let bag = DisposeBag()
    
    var dishesID: String = ""
    
    ///选择数量
    private var dishCount: Int = 1
    private var dishModel = DishModel()
    
    private var info_H: CGFloat = 0

    
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
        
        let w = (S_W - 60) / 3
        layout.itemSize = CGSize(width: w , height: w + 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(MenuComboDishCell.self, forCellWithReuseIdentifier: "MenuComboDishCell")
        return coll
    }()
    
    

    override func setViews() {
        view.backgroundColor = HCOLOR("F7F7F7")
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
            self.info_H = (R_W(375) * (9/16)) + g_h + d_h + n_h + 77
            self.setUpUI()
            
            
            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}



extension MealSelectSizeController {
    
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 4
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuComboDishCell", for: indexPath) as! MenuComboDishCell
        return cell
    }
    

}
