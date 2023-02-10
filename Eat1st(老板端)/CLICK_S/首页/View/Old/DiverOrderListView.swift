//
//  DiverOrderListView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/3/3.
//

import UIKit

import RxSwift

class DiverOrderListView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    var riderID: String = "" {
        didSet {
            self.getPSZ_Net()
        }
    }
    
    private var H: CGFloat = bottomBarH + R_H(470)
    
    private var pszDataArr: [RiderDeliveryModel] = []
    private var historyDataArr: [RiderDeliveryModel] = []
    
    private var tRowCount: Int = 0
//    private var selectIdx: Int = 0

    
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
        
        return tableView
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + R_H(470)), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)

        }
        
        
    }
    
    
    @objc func clickAction() {
        self.disAppearAction()
        //self.clickBlock?("")
     }
     
     
     @objc private func tapAction() {
         disAppearAction()
     }
    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(self.H)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 网络请求
    private func getPSZ_Net()  {
    
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getRiderPSZOrderList(id: self.riderID).subscribe(onNext: { (json) in
            
            var tArr: [RiderDeliveryModel] = []
            
            for jsonData in json["data"].arrayValue {
                                
                let model = RiderDeliveryModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.pszDataArr = tArr
            
            //请求历史
            self.getHistory_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
        
    }
    
    private func getHistory_Net() {
        HTTPTOOl.getRiderPSHistoryList(id: self.riderID, page: 1).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.backView)
            
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
                        
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
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
                //let select = indexPath.row == selectIdx ? true : false
                cell.setCellData(model: pszDataArr[indexPath.row], isSelect: true)
                //cell.clickBlock = { [unowned self] (_) in
                    //查看详情
//                    let orderID = self.pszDataArr[indexPath.row].orderID
//                    let detailVC = OrderDetailController()
//                    detailVC.orderID = orderID
//                    self.navigationController?.pushViewController(detailVC, animated: true)
                //}
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
            self.disAppearAction()
            let orderID = self.pszDataArr[indexPath.row].orderID
            let detailVC = OrderDetailController()
            detailVC.orderID = orderID
            PJCUtil.currentVC()?.navigationController?.pushViewController(detailVC, animated: true)

        }
        
        if indexPath.section == 3 {
            self.disAppearAction()
            let orderID = self.historyDataArr[indexPath.row].orderID
            let detailVC = OrderDetailController()
            detailVC.orderID = orderID
            PJCUtil.currentVC()?.navigationController?.pushViewController(detailVC, animated: true)
        }
    
    }

    
}
