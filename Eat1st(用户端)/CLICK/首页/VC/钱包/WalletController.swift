//
//  WalletController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/1/24.
//

import UIKit
import RxSwift
import SwiftyJSON
import MJRefresh



class WalletDetailModel {
    
    var amount: Double = 0
    var createTime: String = ""
    ///1消费，2退款，3赠送）
    var type: String = ""
    ///名称
    var name: String = ""
    ///id
    var orderID: String = ""
    
    func updateModel(json: JSON) {
        self.amount = json["amount"].doubleValue
        self.createTime = json["createTime"].stringValue
        self.type = json["detailType"].stringValue
        self.name = json["detailTypeName"].stringValue
        self.orderID = json["orderId"].stringValue
    }
    
}


class WalletController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    
    private let bag = DisposeBag()
    
    ///分页
    private var page: Int = 1
    
    private var dataArr: [WalletDetailModel] = []
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()


    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .center)
        lab.text = "Wallet"
        return lab
    }()
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("header_img")
        img.isUserInteractionEnabled = true
        return img
    }()

    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("wallet_back")
        img.isUserInteractionEnabled = true
        return img
    }()

    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "Balance"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(30), .left)
        lab.text = ""
        return lab
    }()
    
    private let toBuyBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "TO BUY", SFONTCOLOR, SFONT(10), .clear)
        but.isHidden = true
        return but
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("wallet_next"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()
    
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "DETAIL"
        return lab
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(WalletDetailCell.self, forCellReuseIdentifier: "WalletDetailCell")
        
        return tableView
        
    }()
    

    
    override func setViews() {
        
        self.naviBar.isHidden = true
        setUpUI()
        self.loadWallet_Net()
        addNotificationCenter()
    }
    
    
    
    private func setUpUI() {
        
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(SET_H(330, 375))
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.size.equalTo(CGSize(width: 50, height: 44))
            $0.top.equalToSuperview().offset(statusBarH)
        }
        
        
        view.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBut)
        }
        
        headImg.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 44 + 15)
            $0.height.equalTo(140)
        }
        
        backImg.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        backImg.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(65)
        }
        
        
        backImg.addSubview(toBuyBut)
        toBuyBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalToSuperview()
        }
        
        backImg.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.top.equalTo(backImg.snp.bottom).offset(15)
        }
        
        backView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: 6, height: 17))
            $0.top.equalToSuperview().offset(25)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalTo(lineView)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(55)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadWalletDetail_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadWalletDetailMore_Net()
        }
        
    
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        toBuyBut.addTarget(self, action: #selector(clickBuyAction), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickBuyAction), for: .touchUpInside)
        
    }

    

    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func clickBuyAction() {
        print("next")
    }
    
    //MARK: - 注册通知中心
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(walletRefresh), name: NSNotification.Name(rawValue: "wallet"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("wallet"), object: nil)
    }
    
    @objc func walletRefresh() {
        loadWallet_Net()
    }

        
    //MARK: - 网络请求
    private func loadWallet_Net()  {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getWalletAmount().subscribe(onNext: { (json) in
            self.moneyLab.text = "£" + D_2_STR(json["data"]["amount"].doubleValue)
            self.loadWalletDetail_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    //MARK: - 请求钱包明细
    private func loadWalletDetail_Net() {
        
        HTTPTOOl.getWalletDetail(page: 1).subscribe(onNext: { (json) in
            
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            

            var tArr: [WalletDetailModel] = []
            for jsonData in json["data"].arrayValue {
                let model = WalletDetailModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
            if self.dataArr.count == 0 {
                self.table.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            self.table.reloadData()
            self.table.mj_header?.endRefreshing()
            self.table.mj_footer?.resetNoMoreData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
        
    }
    
    
    private func loadWalletDetailMore_Net() {
        
        HTTPTOOl.getWalletDetail(page: self.page).subscribe(onNext: { (json) in
            
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = WalletDetailModel()
                    model.updateModel(json: jsonData)
                    self.dataArr.append(model)
                }
                self.table.reloadData()
                self.table.mj_footer?.endRefreshing()
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletDetailCell") as! WalletDetailCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    
}
