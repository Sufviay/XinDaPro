//
//  ExchangeJiFenController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/8.
//

import UIKit
import RxSwift
import MJRefresh

class ExchangeJiFenController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, SystemAlertProtocol {
    
    
    private let bag = DisposeBag()
    
    var storeID: String = ""
    var storeName: String = ""
    
    private var JiFenNumber: Int = 0 {
        didSet {
            self.jifenLab.text = String(JiFenNumber)
        }
    }

    private var dataArr: [ExchangeClassModel] = []
    
    private var selectIdx: Int = 0
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    private let headimg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("exchange_head")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(18), .center)
        lab.text = "Exchange"
        return lab
    }()
    
    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("exchange_back")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.init(name: "Helvetica-Bold", size: 17)
        lab.textColor = HCOLOR("333333")
        lab.text = "MY POINT"
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jf_next")
        return img
    }()
    
    private let jifenLab: UILabel = {
        let lab = UILabel()
        //lab.setCommentStyle(HCOLOR("#333333"), BFONT(35), .left)
        lab.font = UIFont.init(name: "Helvetica-Bold", size: 35)
        lab.textColor = HCOLOR("333333")
        lab.text = ""
        return lab
    }()
    

    private lazy var tagCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(JiFenTagCell.self, forCellWithReuseIdentifier: "JiFenTagCell")
        return coll
        
    }()

    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(JiFenExchangeCell.self, forCellReuseIdentifier: "JiFenExchangeCell")
        return tableView
    }()
    
    
    
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
        self.naviBar.isHidden = true
        
        view.backgroundColor = HCOLOR("F7F7F7")
        
        view.addSubview(headimg)
        headimg.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(SET_H(335, 375))
        }
        
    
        
        view.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalToSuperview().offset(statusBarH)
            $0.centerX.equalToSuperview()
        }
        
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(titlab)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 44 + 20)
            $0.height.equalTo((S_W - 20) * (90 / 355))
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.top.equalTo(backImg.snp.bottom).offset(10)
        }
        
        backImg.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(20)
        }
        
        backImg.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 5, height: 8))
            $0.centerY.equalTo(tlab).offset(-1)
            $0.left.equalTo(tlab.snp.right).offset(10)
        }
        
        backImg.addSubview(jifenLab)
        jifenLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(27)
            $0.top.equalTo(tlab.snp.bottom).offset(2)
        }
        
        backView.addSubview(tagCollection)
        tagCollection.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(tagCollection.snp.bottom)
        }
    

        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickDetailAction))
        backImg.addGestureRecognizer(tap)
        
    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickDetailAction() {
        let nextVC = JiFenDetailController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


extension ExchangeJiFenController {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JiFenTagCell", for: indexPath) as! JiFenTagCell
        
        let isSelect = selectIdx == indexPath.item ? true : false
        cell.setCellData(name: dataArr[indexPath.item].classifyName, isSelect: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let str = dataArr[indexPath.item].classifyName
        let w = str.getTextWidth(BFONT(15), 20) + 30
        return CGSize(width: w, height: 55)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectIdx != indexPath.item {
            selectIdx = indexPath.item
            
            if dataArr[selectIdx].couponList.count == 0 {
                self.table.addSubview(noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            
            collectionView.reloadData()
            table.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataArr.count != 0 && selectIdx <= dataArr.count {
            return dataArr[selectIdx].couponList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
        if dataArr.count != 0 && selectIdx <= dataArr.count {
            return dataArr[selectIdx].couponList[indexPath.row].cell_H
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JiFenExchangeCell") as! JiFenExchangeCell
        cell.setCellData(model: dataArr[selectIdx].couponList[indexPath.row], curJifen: self.JiFenNumber)
        
        cell.clickRuleBlock = { [unowned self] (_) in
            self.dataArr[self.selectIdx].couponList[indexPath.row].ruleIsOpen = !self.dataArr[self.selectIdx].couponList[indexPath.row].ruleIsOpen
            self.table.reloadData()
        }
        
        cell.clickExchangeBlock = { [unowned self] (_) in
            //兑换
            let id = self.dataArr[self.selectIdx].couponList[indexPath.row].pointsCouponId
            let exJifen = self.dataArr[self.selectIdx].couponList[indexPath.row].pointsNum
            
            self.showSystemChooseAlert("Alert", "Do you confirm the redeem?", "confirm", "cancel") {
                self.doExchange_Net(id: id, exNum: exJifen)
            } _: {}
        }
        return cell
    }
}


extension ExchangeJiFenController {

    //MARK: - 网络请求
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        HTTPTOOl.getJiFenCount().subscribe(onNext: { (json) in
            self.JiFenNumber = json["data"]["pointsNum"].intValue
            
            HTTPTOOl.getJiFenExchangeList(storeID: self.storeID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)

                var c_arr: [ExchangeClassModel] = []
                var t_arr: [JiFenExchangeModel] = []
                for jsondata in json["data"]["classify"].arrayValue {
                    let model = ExchangeClassModel()
                    model.updateModel(json: jsondata)
                    c_arr.append(model)
                }
                
                for jsondata in json["data"]["couponList"].arrayValue {
                    let model = JiFenExchangeModel()
                    model.canUseStore = self.storeName
                    model.updateModel(json: jsondata)
                    t_arr.append(model)
                }
                
                self.setDataArr(c_arr: c_arr, t_arr: t_arr)
                self.tagCollection.reloadData()
                self.table.reloadData()
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        

    }
    
    
    func setDataArr(c_arr: [ExchangeClassModel], t_arr: [JiFenExchangeModel]) {
        
        
        for model in c_arr {
            let arr = t_arr.filter { $0.classifyID == model.classifyID }
            model.couponList = arr
        }
        
        ///错误处理
        if c_arr.count == 0 {
            selectIdx = 0
            self.table.addSubview(noDataView)
        } else {
            if selectIdx > c_arr.count {
                selectIdx = 0
            }
            
            if c_arr[selectIdx].couponList.count == 0 {
                self.table.addSubview(noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
        }
        
        
        self.dataArr = c_arr
    }
    
    
    ///兑换优惠券
    private func doExchange_Net(id: String, exNum: Int) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.jiFenExchange(exID: id).subscribe(onNext: { (json) in
            
            //兑换成功 刷新积分
            self.JiFenNumber = self.JiFenNumber - exNum
            
            //刷新列表
            HTTPTOOl.getJiFenExchangeList(storeID: self.storeID).subscribe(onNext: { (json) in
                HUD_MB.showSuccess("Success", onView: self.view)
                
                var c_arr: [ExchangeClassModel] = []
                var t_arr: [JiFenExchangeModel] = []
                for jsondata in json["data"]["classify"].arrayValue {
                    let model = ExchangeClassModel()
                    model.updateModel(json: jsondata)
                    c_arr.append(model)
                }
                
                for jsondata in json["data"]["couponList"].arrayValue {
                    let model = JiFenExchangeModel()
                    model.canUseStore = self.storeName
                    model.updateModel(json: jsondata)
                    t_arr.append(model)
                }
                
                self.setDataArr(c_arr: c_arr, t_arr: t_arr)
                self.tagCollection.reloadData()
                self.table.reloadData()
            }, onError: { (error) in

                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}
