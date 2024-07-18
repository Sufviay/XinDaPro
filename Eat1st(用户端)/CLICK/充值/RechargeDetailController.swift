//
//  RechargeDetailController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/15.
//

import UIKit
import SwiftyJSON
import RxSwift
import MJRefresh


 
class RechargeModel: NSObject {
    
    ///充值或消费金额[...]
    var amount: Double = 0
    ///时间[...]
    var createTime: String = ""
    ///明细类型（1充值，2消费 3退款4平台赠送5平台减扣）[...]
    var detailType: String = ""
    ///赠送金额（当detailType=1时有值）[...]
    var giftAmount: Double = 0
    ///剩余金额[...]
    var subAmount: Double = 0
    ///操作说明
    var remark: String = ""
    
    var remark_H: CGFloat = 0
    
    
    
    func updateModel(json: JSON) {
        amount = json["amount"].doubleValue
        createTime = json["createTime"].stringValue
        detailType = json["detailType"].stringValue
        giftAmount = json["giftAmount"].doubleValue
        subAmount = json["giftAmount"].doubleValue
        remark = json["remark"].stringValue
        
        
        if remark != "" {
            
            remark_H = remark.getTextHeigh(SFONT(10), S_W - 90) + 55
        }
        
    }
    
}



class RechargeDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var storeID: String = ""
    var storeName: String = ""
    
    private let bag = DisposeBag()

    private var dataArr: [RechargeModel] = []

    ///分页
    private var page: Int = 1
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()

    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("card")
        return img
    }()
    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#50321A"), BFONT(16), .left)
        lab.text = "CURRENT BALANCE"
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#50321A"), BFONT(24), .left)
        lab.text = ""
        return lab
    }()
    
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        return img
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1.5
        return view
    }()

    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "DETAILS"
        return lab
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
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
        tableView.bounces = true
        tableView.register(RechargeCell.self, forCellReuseIdentifier: "RechargeCell")
        tableView.register(RechargeRemarkCell.self, forCellReuseIdentifier: "RechargeRemarkCell")
        return tableView
    }()

    
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    override func setNavi() {
        naviBar.headerTitle = storeName
        naviBar.leftImg = LOIMG("nav_back")
        naviBar.rightBut.isHidden = true
    }
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }

    
    private func setUpUI() {
        
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(350), height: SET_H(152, 350)))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
        }
        
        
        headImg.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.centerY.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(25)
        }
        
        headImg.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(5)
        }

        
        headImg.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalTo(sImg.snp.top).offset(-15)
        }
    
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 3, height: 16))
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(headImg.snp.bottom).offset(10)
        }
        
        view.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerY.equalTo(line)
            $0.left.equalTo(line.snp.right).offset(10)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            loadDataMore_Net()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model = dataArr[section]
        
        if model.remark == "" {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 55
        } else {
            return dataArr[indexPath.section].remark_H
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RechargeCell") as! RechargeCell
            cell.setCellData(model: dataArr[indexPath.section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RechargeRemarkCell") as! RechargeRemarkCell
            cell.setCellData(model: dataArr[indexPath.section])
            return cell
        }
        
    }
    
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getUserRechargeAmount(storeID: storeID).subscribe(onNext: { [unowned self] (json1) in
            
            HUD_MB.loading("", onView: view)
            HTTPTOOl.getUserRechargeDetail(page: 1, type: "3", storeID: storeID).subscribe(onNext: { [unowned self] (json2) in
                HUD_MB.dissmiss(onView: view)
                
                page = 2
                moneyLab.text = D_2_STR(json1["data"]["amount"].doubleValue)
                
                var tArr: [RechargeModel] = []
                for jsonData in json2["data"]["detailList"].arrayValue {
                    let model = RechargeModel()
                    model.updateModel(json: jsonData)
                    tArr.append(model)
                }
                dataArr = tArr
                if dataArr.count == 0 {
                    table.addSubview(noDataView)
                } else {
                    noDataView.removeFromSuperview()
                }
                table.reloadData()
                table.mj_header?.endRefreshing()
                table.mj_footer?.resetNoMoreData()

            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                table.mj_header?.endRefreshing()
            }).disposed(by: bag)

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getUserRechargeDetail(page: page, type: "3", storeID: storeID).subscribe(onNext: {[unowned self] (json) in

            if json["data"]["detailList"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                page += 1
                for jsonData in json["data"]["detailList"].arrayValue {
                    let model = RechargeModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
}
