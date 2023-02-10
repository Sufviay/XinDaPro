//
//  CheckPSYLocalController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/26.
//

import UIKit
import GoogleMaps
import RxSwift
import SwiftyJSON


class RiderDeliveryModel {
    var address: String = ""
    var name: String = ""
    var dayNum: String = ""
    var orderID: String = ""
    var phone: String = ""
    var time: String = ""
    
    var userLat: Double = 0
    var userLng: Double = 0
    
    
    func updateModel(json: JSON) {
        self.address = json["address"].stringValue
        self.name = json["name"].stringValue
        self.dayNum = json["orderDayNum"].stringValue
        self.orderID = json["orderId"].stringValue
        self.phone = json["phone"].stringValue
        self.time = json["createTime"].stringValue
        
//        self.riderLat = json["riderLat"].doubleValue
//        self.riderLng = json["riderLng"].doubleValue
//        self.storeLat = json["storeLat"].doubleValue
//        self.storeLng = json["storeLng"].doubleValue
        self.userLat = json["userLat"].doubleValue
        self.userLng = json["userLng"].doubleValue
        
    }
    
}




class CheckPSYLocalController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    var riderID: String = ""
    
    var timer: Timer?
    
    private var pszDataArr: [RiderDeliveryModel] = []
    private var historyDataArr: [RiderDeliveryModel] = []
    
    private var selectIdx: Int = 0
    
    private var curRiderLat: Double = 0
    private var curRiderLng: Double = 0
    
    private var tRowCount: Int = 0


    private lazy var mapView: GMSMapView = {
            
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15)
        let map = GMSMapView.map(withFrame: .zero, camera: camera)
        map.isUserInteractionEnabled = false
        return map
    }()
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        return view
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private let refreshBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("refresh"), for: .normal)
        return but
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
        tableView.register(PSDetailHeaderCell.self, forCellReuseIdentifier: "PSDetailHeaderCell")
        tableView.register(PSZOrderCell.self, forCellReuseIdentifier: "PSZOrderCell")
        tableView.register(PSHistoryCell.self, forCellReuseIdentifier: "PSHistoryCell")
        tableView.register(NoDataCell.self, forCellReuseIdentifier: "NoDataCell")
        
        
        tableView.contentInset = UIEdgeInsets(top: 440, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -440)
        
        return tableView
    }()
    

    override func setViews() {
        
        self.naviBar.isHidden = true
        
        view.backgroundColor = .white
        
        setUpUI()
        getPSZ_Net()
        
    }
    
    override func viewDisappear() {
        invalidateTimer()
    }
    
    
    
    private func setUpUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(450)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        
        headView.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        headView.addSubview(refreshBut)
        refreshBut.snp.makeConstraints {
            $0.size.equalTo(backBut)
            $0.centerY.equalTo(backBut)
            $0.right.equalToSuperview().offset(-10)
        }
        
        self.backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.refreshBut.addTarget(self, action: #selector(clickRefreshAciton), for: .touchUpInside)
    }
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickRefreshAciton() {
        self.refreshMapView()
    }

    
    //MARK: - 定时相关
    private func startTimer() {
        print("startTimer")
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (_) in
            self.getRiderLocal_Net()
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    
    private func invalidateTimer() {
        
        print("结束上传！")
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
            print("invalidateTimer")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if pszDataArr.count == 0 && historyDataArr.count == 0 {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pszDataArr.count == 0 && historyDataArr.count == 0 {
            return tRowCount
            
        } else {
            if section == 0 {
                if pszDataArr.count == 0 {
                    return 0
                }
                return 1
            }
            if section == 2 {
                if historyDataArr.count == 0 {
                    return 0
                }
                return 1
            }
            
            if section == 1 {
                return pszDataArr.count
            }
            
            if section == 3 {
                if historyDataArr.count > 2 {
                    return 2
                }
                return historyDataArr.count
            }
            return 10

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if pszDataArr.count == 0 && historyDataArr.count == 0 {
            return 300
        } else {
            
            if indexPath.section == 0 || indexPath.section == 2 {
                return 50
            }
            
            if indexPath.section == 1 {
                
                let h = pszDataArr[indexPath.row].address.getTextHeigh(SFONT(13), S_W - 20 - 70)
                return h + 65
            }
            
            if indexPath.section == 3 {
                let h = historyDataArr[indexPath.row].address.getTextHeigh(SFONT(13), S_W - 20 - 70)
                return h + 75
            }
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pszDataArr.count == 0 && historyDataArr.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell") as! NoDataCell
            return cell
        } else {
            if indexPath.section == 0 || indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PSDetailHeaderCell") as! PSDetailHeaderCell
                if indexPath.section == 0 {
                    cell.setCellData(titStr: "Delivery Order")
                }
                if indexPath.section == 2 {
                    cell.setCellData(titStr: "Order History")
                }
                return cell
            }
            
            if  indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PSZOrderCell") as! PSZOrderCell
                let select = indexPath.row == selectIdx ? true : false
                cell.setCellData(model: pszDataArr[indexPath.row], isSelect: select)
                cell.clickBlock = { [unowned self] (_) in
                    //查看详情
                    let orderID = self.pszDataArr[indexPath.row].orderID
                    let detailVC = OrderDetailController()
                    detailVC.orderID = orderID
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
                return cell
            }
            
            if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PSHistoryCell") as! PSHistoryCell
                cell.setCellData(model: historyDataArr[indexPath.row])
                return cell
            }
            
            let cell = UITableViewCell()
            cell.contentView.backgroundColor = .red
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if pszDataArr.count == 0 && historyDataArr.count == 0 {
            return
        }
        
        if indexPath.section == 1 {
            if indexPath.row != selectIdx {
                //变样式
                selectIdx = indexPath.row
                self.table.reloadSections([1], with: .none)
                //刷新地图
                self.refreshMapView()
                
            }
        }
        
        if indexPath.section == 3 {
            //查看详情
            let orderID = historyDataArr[indexPath.row].orderID
            let detailVC = OrderDetailController()
            detailVC.orderID = orderID
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(statusBarH + 44) {
            self.headView.backgroundColor = .white.withAlphaComponent(1)
        } else {
            self.headView.backgroundColor = .white.withAlphaComponent(0)
        }
    }
    
    
    
    //MARK: - 网络请求
    private func getPSZ_Net()  {
    
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getRiderPSZOrderList(id: self.riderID).subscribe(onNext: { (json) in
            
            var tArr: [RiderDeliveryModel] = []
            
            for jsonData in json["data"].arrayValue {
                                
                let model = RiderDeliveryModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.pszDataArr = tArr
            
            if self.pszDataArr.count != 0 {
                //开启定时任务
                self.startTimer()
            }

            //请求历史
            self.getHistory_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    private func getHistory_Net() {
        HTTPTOOl.getRiderPSHistoryList(id: self.riderID, page: 1).subscribe(onNext: { (json) in
            
            var tArr: [RiderDeliveryModel] = []
            for jsonData in json["data"].arrayValue {
                let model = RiderDeliveryModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.historyDataArr = tArr
            
            //获取骑手位置
            
            if self.pszDataArr.count == 0 && self.historyDataArr.count == 0 {
                self.tRowCount = 1
            } else {
                self.tRowCount = 0
            }
            
            self.table.reloadData()
            self.getRiderLocal_Net()
            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - 获取骑手位置
    func getRiderLocal_Net() {
        HTTPTOOl.getRiderLocal(id: self.riderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.curRiderLat = json["data"]["lat"].doubleValue
            self.curRiderLng = json["data"]["lng"].doubleValue
            self.refreshMapView()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    
    
    
    //MARK: - 更新地图位置
    private func refreshMapView() {
        
        self.mapView.clear()
                
        let storeLat = UserDefaults.standard.storeLat ?? 0
        let storeLng = UserDefaults.standard.storeLng ?? 0
        
        //店铺坐标
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: storeLat, longitude: storeLng)
        marker1.title = "store"
        marker1.snippet = "store"
        marker1.icon = LOIMG("local_dp")
        marker1.map = mapView
        
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: curRiderLat, longitude: curRiderLng)
        marker2.title = "rider"
        marker2.snippet = "rider"
        marker2.icon = LOIMG("local_ps")

        if pszDataArr.count == 0 {
            //没有配送中的 显示店铺和骑手的位置
    
            if curRiderLat == 0 && curRiderLng == 0 {
                //HUD_MB.showWarnig("The location of delivery personnel is lost!", onView: self.view)
                let camera = GMSCameraPosition.camera(withLatitude: storeLat, longitude: storeLng, zoom: 15)
                mapView.camera = camera

            } else {
                marker2.map = mapView
                let northEast = CLLocationCoordinate2D(latitude: storeLat, longitude: storeLng)
                let southWest = CLLocationCoordinate2D(latitude: curRiderLat, longitude: curRiderLng)
                let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
                mapView.moveCamera(update)
            }
        } else {
            //有正在配送的订单
            let model = pszDataArr[selectIdx]
            
            let marker3 = GMSMarker()
            marker3.position = CLLocationCoordinate2D(latitude: model.userLat, longitude: model.userLng)
            marker3.title = "user"
            marker3.snippet = "user"
            marker3.icon = LOIMG("local_yh")
            marker3.map = mapView
            
            
            if curRiderLat == 0 && curRiderLng == 0 {
                //HUD_MB.showWarnig("The location of delivery personnel is lost!", onView: self.view)
                let northEast = CLLocationCoordinate2D(latitude: model.userLat, longitude: model.userLng)
                let southWest = CLLocationCoordinate2D(latitude: storeLat, longitude: storeLng)
                let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                
                
                let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
                mapView.moveCamera(update)
        
            } else {
                marker2.map = mapView
                let northEast = CLLocationCoordinate2D(latitude: model.userLat, longitude: model.userLng)
                let southWest = CLLocationCoordinate2D(latitude: curRiderLat, longitude: curRiderLng)
                let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
                mapView.moveCamera(update)
            }
        }
    }
}

