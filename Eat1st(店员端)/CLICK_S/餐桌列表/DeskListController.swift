//
//  DeskListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/11.
//

import UIKit
import MJRefresh
import RxSwift

class DeskListController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let bag = DisposeBag()
    
    private var dataArr: [DeskModel] = []

    ///菜品附加数据
    private var attachDataArr: [AttachClassifyModel] = []
    ///菜品分类数据
    private var classifyData = ClassifyDataModel()
    
    
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
    
    
    
    private let refreshBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("refresh"), for: .normal)
        but.setTitle("Refresh", for: .normal)
        but.titleLabel?.font = SETFONT_B(11)
        but.setTitleColor(.white, for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return but
    }()

    
    private lazy var perNumAlert: SelectPersonNumAlert = {
        let alert = SelectPersonNumAlert()
        return alert
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
        //getClassifyData_Net()
        addNotification()
    }
    
    
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("#F4F3F8")
        
        naviBar.addSubview(refreshBut)
        refreshBut.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(90)
            $0.centerY.equalTo(naviBar.leftBut)
        }
        
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
        
        refreshBut.addTarget(self, action: #selector(clickRefreshAction), for: .touchUpInside)
    }
    
    
    @objc private func clickRefreshAction() {
        loadData_Net()
    }
    
    
    //展开侧拉
    override func clickLeftButAction() {
        sideBar.appearAction()
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
        deskColleciton.reloadData()
        perNumAlert.colleciton.reloadData()
        
        DispatchQueue.main.async {
            print("----------W:\(UIScreen.main.bounds.width)\n----------H:\(UIScreen.main.bounds.height)")
            self.sideBar.updateFrame()
        }
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
        
        
        print("----------W:\(UIScreen.main.bounds.width)\n----------H:\(UIScreen.main.bounds.height)")
        
        let model = dataArr[indexPath.item]
        
        if model.deskStatus == .Empty  {
            //进入点餐页面
            
            perNumAlert.appearAction()
            
            perNumAlert.selectCountBlock = { [unowned self] (arr) in
                
                let aNum = (arr as! [Int])[0]
                let cNum = (arr as! [Int])[1]
                
                let nextVC = DishListController()
                nextVC.attachDataArr = attachDataArr
                //nextVC.classifyData = classifyData
                nextVC.titStr = model.deskName
                nextVC.deskID = model.deskId
                nextVC.ad_Count = aNum
                nextVC.ch_Count = cNum
                navigationController?.pushViewController(nextVC, animated: true)

            }
            

            
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
    
    
    //设置每一个Item的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (UIScreen.main.bounds.width - 45) / 2, height: 130)
    
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
        HTTPTOOl.getAttchAndAttachClassify().subscribe(onNext: { [unowned self] (json) in

            var tarr: [AttachClassifyModel] = []
            for jsondata in json["data"]["classifyList"].arrayValue {
                let model = AttachClassifyModel()
                model.updateModel(json: jsondata)
                tarr.append(model)
            }
            attachDataArr = tarr

            for jsondata in json["data"]["attachList"].arrayValue {
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
    }
    
    
    
//    //MARK: - 获取菜品分类列表
//    private func getClassifyData_Net() {
//        HTTPTOOl.getDishesClassiftyList().subscribe(onNext: { [unowned self] (json) in
//            classifyData.updateModel(json: json["data"])
//        }, onError: { [unowned self] (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
//        }).disposed(by: bag)
//    }
}
