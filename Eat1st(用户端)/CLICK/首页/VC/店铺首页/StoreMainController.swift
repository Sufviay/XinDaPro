//
//  StoreMainController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/8.
//

import UIKit
import RxSwift

class StoreMainController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {


    private let bag = DisposeBag()
    
    ///店铺ID
    var storeID: String = ""
    ///店铺信息
    private var dataModel = StoreInfoModel()
    
    ///是否是点击店铺列表进入的
    var isClickList: Bool = false
    
    ///售卖类型 1外卖，2自取，3堂食
    var saleTypeArr: [String] = []
    
    private var sectionNum: Int = 0
    
    
    ///自定义的导航栏
    private lazy var headerBar: DineInNavBarView = {
        let view = DineInNavBarView()
        view.backBut.backgroundColor = .black.withAlphaComponent(0.4)
        view.backBut.layer.cornerRadius = 7

        view.backBut.snp.remakeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.top.equalToSuperview().offset(statusBarH + 7)
            $0.left.equalToSuperview().offset(10)
        }
        
        view.setData(isHavePay: false)
        
        if isClickList {
            view.backBut.setImage(LOIMG("nav_back_w"), for: .normal)
        } else {
            view.backBut.setImage(LOIMG("nav_cbl_w"), for: .normal)
        }
        
        view.backBlock = { [unowned self] _ in
            
            if isClickList {
                navigationController?.popViewController(animated: true)
            } else {
                sideBar.appearAction()
            }
        }
                
        view.amountBlock = { [unowned self] _ in
            let amountVC = RechargeDetailController()
            amountVC.storeID = storeID
            amountVC.storeName = dataModel.name
            navigationController?.pushViewController(amountVC, animated: true)
        }
        
        view.payBlock = { [unowned self] _ in
            
            if UserDefaults.standard.isAgree {
                let payVC = PayCodeController()
                payVC.storeID = storeID
                navigationController?.pushViewController(payVC, animated: true)
            } else {
                //弹出法律条文页面
                let webVC = AgreeTermsController()
                webVC.titStr = "APP Terms and Conditions"
                webVC.webUrl = TCURL
                webVC.storeID = storeID
                self.present(webVC, animated: true, completion: nil)
            }
        }
        
        return view
    }()
    
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
        view.isHome = false
        return view
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
        tableView.register(StoreFirstHeadCell.self, forCellReuseIdentifier: "StoreFirstHeadCell")
        tableView.register(StoreMidInfoCell.self, forCellReuseIdentifier: "StoreMidInfoCell")
        tableView.register(MenuVipCell.self, forCellReuseIdentifier: "MenuVipCell")
        tableView.register(StoreFirstPageButCell.self, forCellReuseIdentifier: "StoreFirstPageButCell")
        tableView.register(StoreMainVipButCell.self, forCellReuseIdentifier: "StoreMainVipButCell")
        tableView.register(StoreDiscountCell.self, forCellReuseIdentifier: "StoreDiscountCell")
        return tableView
    }()

    
    override func setViews() {
        
        view.backgroundColor = .white
        setUpUI()
        //addNotificationCenter()
    }
    
    override func setNavi() {
        loadData_Net()
        loadCanBookingStatus_Net()
        //getWalletMoney_Net()
    }
    
    override func didAppear() {
        if isClickList {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    
    
    private func setUpUI() {
        
        naviBar.isHidden = true
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        view.addSubview(headerBar)
        headerBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }

    }
    
    
    @objc private func clickCBLAction()  {
        sideBar.appearAction()
    }
    
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.Store_MainPageData(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
            
            dataModel.updateModel(json: json["data"])
            sectionNum = 6
            //获取充值信息
            HTTPTOOl.getUserVip(storeID: storeID).subscribe(onNext: { [unowned self] (json2) in
                HUD_MB.dissmiss(onView: view)
                dataModel.isVip = json2["data"]["vipType"].stringValue == "2" ? true: false
                dataModel.vipAmount = D_2_STR(json2["data"]["amount"].doubleValue)
                table.reloadData()
            }, onError: { [unowned self] (error) in
                HUD_MB.showMessage(ErrorTool.errorMessage(error), self.view)
            }).disposed(by: bag)
        }, onError: { [unowned self] (error) in
            HUD_MB.showMessage(ErrorTool.errorMessage(error), self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func loadCanBookingStatus_Net() {
        HTTPTOOl.isCanBooking(storeID: storeID).subscribe(onNext: { [unowned self] (json) in
            if json["data"]["reserveStatus"].stringValue == "2" {
                //是
                dataModel.isOpenBooking = true
            }
            if json["data"]["reserveStatus"].stringValue == "1" {
                //否
                dataModel.isOpenBooking = false
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showMessage(ErrorTool.errorMessage(error), self.view)
        }).disposed(by: bag)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            if !dataModel.isVip {
                return 0
            }
        }
        
        if section == 2 {
            if !dataModel.isRegDiscount {
                return 0
            }
        }
        
        return 1
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return SET_H(220, 375)
        }
        if indexPath.section == 1 {
            return 110
        }
        
        if indexPath.section == 2 {
            return 75
        }
        
        if indexPath.section == 3 {
            return SET_H(50, 345) + 10
        }
        
        if indexPath.section == 4 {
            return 95
        }
        
        if indexPath.section == 5 {
            return 220
        }
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFirstHeadCell") as! StoreFirstHeadCell
            cell.setCellData(imgStr: self.dataModel.coverImg)
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreMidInfoCell") as! StoreMidInfoCell
            cell.setCellData(model: self.dataModel)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDiscountCell", for: indexPath)
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuVipCell") as! MenuVipCell
            cell.setCellData(model: dataModel, canClick: false)
            return cell
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreMainVipButCell") as! StoreMainVipButCell
            cell.setCellData(amount: dataModel.vipAmount)
            
            cell.clickBlock = { [unowned self] (type) in
                if type == "code" {
                    //付款码
                    if UserDefaults.standard.isAgree {
                        let payVC = PayCodeController()
                        payVC.storeID = storeID
                        payVC.storeName = dataModel.name
                        navigationController?.pushViewController(payVC, animated: true)
                    } else {
                        //弹出法律条文页面
                        let webVC = AgreeTermsController()
                        webVC.titStr = "APP Terms and Conditions"
                        webVC.webUrl = TCURL
                        webVC.storeID = storeID
                        self.present(webVC, animated: true, completion: nil)
                    }
                }
                
                if type == "book" {
                    
                    if dataModel.isOpenBooking {
                        let nextVC = OccupyController()
                        nextVC.storeID = dataModel.storeID
                        nextVC.storeName = dataModel.name
                        nextVC.storeDes = dataModel.des
                        navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        showSystemAlert("Alert", "Table booking function turned off", "OK")
                    }
                }
                
                if type == "record" {
                    let amountVC = RechargeDetailController()
                    amountVC.storeID = dataModel.storeID
                    amountVC.storeName = dataModel.name
                    navigationController?.pushViewController(amountVC, animated: true)
                }
                
                if type == "share" {
                    let nextVC = ShareController()
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            
            return cell
        }
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreFirstPageButCell") as! StoreFirstPageButCell
            cell.setCellData(data: dataModel, isDinein: isClickList, typeArr: saleTypeArr)
            
            cell.clickBlock = { [unowned self] (type) in
                if type == "order" {
                    let nextVC =  OrderListController()
                    navigationController?.pushViewController(nextVC, animated: true)
                }
                
                if type == "dinein" {
                    //打开扫一扫
                    clickSaoYiSaoAction(storeID: storeID)
                }
                
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            //展示充值码
            if UserDefaults.standard.isAgree {
                let payVC = PayCodeController()
                payVC.storeID = storeID
                navigationController?.pushViewController(payVC, animated: true)
            } else {
                //弹出法律条文页面
                let webVC = AgreeTermsController()
                webVC.titStr = "APP Terms and Conditions"
                webVC.webUrl = TCURL
                webVC.storeID = storeID
                self.present(webVC, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - 扫一扫
    private func clickSaoYiSaoAction(storeID: String) {
        //绑定店铺
        
        if PJCUtil.checkLoginStatus() {
            let scanVC = ScanViewController()
            var style = LBXScanViewStyle()
            style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
            style.colorAngle = MAINCOLOR
            scanVC.scanStyle = style
//            if storeID == "" {
//                scanVC.isClickStore = false
//            } else {
//                scanVC.isClickStore = true
//            }
//
            scanVC.clickWaiMaiBlock = { [unowned self] (_) in
                let nextVC = StoreMenuOrderController()
                nextVC.storeID = storeID
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
            
            ///https://share.eat1st.co.uk/store/detail/?storeId=1558386586135650305&deskId=1111111111

            
            scanVC.scanFinshBlock = { [unowned self] (str) in
                
                print("---------------------\(str)")
                
                let scanStr = str as! String
                if scanStr != "" {
                    
                    var storeID = ""
                    var deskID = ""
                    
                    let arr1 = scanStr.components(separatedBy: "?")

                    let str1 = arr1.last ?? ""

                    if str1 != "" {

                        let arr2 = str1.components(separatedBy: "&")

                        for tStr in arr2 {

                            let arr3 = tStr.components(separatedBy: "=")
                            if arr3.first ?? "" == "storeId" {
                                storeID = arr3.last ?? ""
                            }
                            if arr3.first ?? "" == "deskId" {
                                deskID = arr3.last ?? ""
                            }
                        }
                        
                        if deskID == "" && storeID != "" {
                            //店铺宣传
                            //进入店铺主页
                            let nextVC = StoreMainController()
                            nextVC.storeID = storeID
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                        
                        if deskID != "" && storeID != "" {
                            //扫码点餐
                            //验证桌号
                            HUD_MB.loading("", onView: view)
                            HTTPTOOl.checkDesk(storeID: storeID, deskID: deskID).subscribe(onNext: { [unowned self] json in
                                HUD_MB.dissmiss(onView: self.view)
                                
                                let dineInVC = DineInFirstController()
                                dineInVC.deskID = deskID
                                dineInVC.storeID = storeID
                                self.navigationController?.pushViewController(dineInVC, animated: true)
                                
                            }, onError: { [unowned self] error in
                                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
                            }).disposed(by: self.bag)
                        }

                    }
                }
            }
            scanVC.modalPresentationStyle = .fullScreen
            self.present(scanVC, animated: true, completion: nil)
        }
    }

    
}

