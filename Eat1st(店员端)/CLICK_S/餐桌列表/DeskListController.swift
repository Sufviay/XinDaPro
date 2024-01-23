//
//  DeskListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/11.
//

import UIKit
import MJRefresh
import RxSwift

class DeskListController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let bag = DisposeBag()
    
    private var dataArr: [DeskModel] = []
    
    private var attachDataArr: [AttachClassifyModel] = []
    
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
        return view
    }()
    
    private let headView: DeskListHeadView = {
        let view = DeskListHeadView()
        return view
    }()
    
    private lazy var deskColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        layout.itemSize = CGSize(width: S_W - 30 , height: 110)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(DeskCell.self, forCellWithReuseIdentifier: "DeskCell")
        return coll
    }()
    
    
    
    override func setNavi() {
        naviBar.leftImg = LOIMG("nav_more")
        naviBar.headerTitle = "DINE IN"
        naviBar.rightBut.isHidden = true
        loadData_Net()
    }
    
    override func setViews() {
        setUpUI()
        getAttachData_Net()
    }
    
    
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("#F4F3F8")
        
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.right.equalToSuperview().offset(-14)
            $0.height.equalTo(35)
            $0.top.equalTo(naviBar.snp.bottom).offset(15)
        }
        
        view.addSubview(deskColleciton)
        deskColleciton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(headView.snp.bottom).offset(10)
        }
        
        deskColleciton.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
    }
    
    
    //展开侧拉
    override func clickLeftButAction() {
        sideBar.appearAction()
    }

}


extension DeskListController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeskCell", for: indexPath) as! DeskCell
        cell.setCellData(model: dataArr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.item]
        
        if model.deskStatus == .Empty  {
            //进入点餐页面
            let nextVC = DishListController()
            nextVC.attachDataArr = attachDataArr
            nextVC.titStr = model.deskName
            nextVC.deskID = model.deskId
            navigationController?.pushViewController(nextVC, animated: true)

            
        } else if model.deskStatus == .Occupied  {
            if (model.workNum + model.settleNum) != 0 {
                //进入订单列表
                let nextVC = DeskOrderListController()
                nextVC.attachDataArr = attachDataArr
                nextVC.titStr = model.deskName
                nextVC.deskID = model.deskId
                nextVC.deskStatus = model.deskStatus
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            //进入订单列表
            let nextVC = DeskOrderListController()
            nextVC.attachDataArr = attachDataArr
            nextVC.titStr = model.deskName
            nextVC.deskID = model.deskId
            nextVC.deskStatus = model.deskStatus
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }

}

extension DeskListController {
    
    //MARK: - 网络请求
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeskList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [DeskModel] = []
            for jsonData in json["data"].arrayValue {
                let model = DeskModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            deskColleciton.reloadData()
            deskColleciton.mj_header?.endRefreshing()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            deskColleciton.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    //MARK: - 请求附加数据
    
    func getAttachData_Net() {
        //获取菜品附加分类列表
        HTTPTOOl.getAttachClassifyList().subscribe(onNext: { [unowned self] (json) in

            var tarr: [AttachClassifyModel] = []
            for jsondata in json["data"].arrayValue {
                let model = AttachClassifyModel()
                model.updateModel(json: jsondata)
                tarr.append(model)
            }
            attachDataArr = tarr

            //获取菜品附加的列表
            HTTPTOOl.getAttachList().subscribe(onNext: { [unowned self] (json) in

                for jsondata in json["data"].arrayValue {
                    let model = AttachModel()
                    model.updateModel(json: jsondata)
                    //根据分类ID 插入附加分类中
                    for cmodel in attachDataArr {
                        if cmodel.classifyId == model.classifyId {
                            cmodel.attachList.append(model)
                        }
                    }
                }

            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }).disposed(by: bag)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
}
