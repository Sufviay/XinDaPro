//
//  OrderListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/7/18.
//

import UIKit
import RxSwift


class OrderListController: HeadBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var userID: String = ""
    
    private var dataArr: [OrderDetailModel] = []
    
    private let bag = DisposeBag()
    
    
    private var page: Int = 1
    
    private var dateType: String = "3"
    
    //默認當前月
    private var startDate: String = Date().getString("yyyy-MM") + "-01"
    private var endDate: String = DateTool.getMonthLastDate(monthStr: Date().getString("yyyy-MM"))

    
    private var selectType = TypeModel(id: "", name: "All".local)
//    private var selectOrderStatus = TypeModel(id: "", name: "All".local)
//    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
        
    private let typeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = BACKCOLOR_3
        but.clipsToBounds = true
        but.layer.cornerRadius = 5
        return but
    }()

    
    private let xlImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl_b")
        return img
    }()

    
    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "All".local
        return lab
    }()
    
    
    private lazy var typeAlert: SelectTypeAlert = {
        let view = SelectTypeAlert()
        view.alertType = .platformType
        view.selectBlock = { [unowned self] (par) in
            selectType.id = (par as! TypeModel).id
            selectType.name = (par as! TypeModel).name
            typeLab.text = selectType.name
            loadData_Net()
        }
        
        return view
    }()
    
    
    
    //篩選框
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        view.initFiltrateViewDateType(dateType: "3")
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
        
            if str == "Week".local {
                dateType = "2"
            }
            if str == "Day".local {
                dateType = "1"
            }
            if str == "Month".local {
                dateType = "3"
            }
        }
        
        
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (arr) in
            let dateArr = arr as! [String]
            print(dateArr[0])
            print(dateArr[1])
            
            if dateType == "3" {
                //月
                startDate = dateArr[0] + "-01"
                endDate = DateTool.getMonthLastDate(monthStr: dateArr[0])
            } else if dateType == "1" {
                startDate = dateArr[0]
                endDate = dateArr[0]

            } else {
                startDate = dateArr[0]
                endDate = dateArr[1]
            }
            
            loadData_Net()
        }
        
        return view
    }()



    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    

    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        //tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OrderListCell.self, forCellReuseIdentifier: "OrderListCell")
        return tableView
    }()



    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Orders".local
    }

    
    
    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.top.equalToSuperview().offset(25)
        }
        
        backView.addSubview(typeBut)
        typeBut.snp.makeConstraints {
            $0.top.equalTo(filtrateView.snp.bottom).offset(5)
            $0.height.equalTo(45)
            $0.right.left.equalTo(filtrateView)
        }

        
        typeBut.addSubview(xlImg1)
        xlImg1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }

        
        typeBut.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }

        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalTo(typeBut.snp.bottom).offset(10)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }


        
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        typeBut.addTarget(self, action: #selector(clickTypeAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickTypeAction() {
        typeAlert.appearAction()
    }
    
    
    
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].orderListCell_H
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell") as! OrderListCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = OrderDetailController()
        nextVC.orderID = dataArr[indexPath.row].id
        nextVC.souceType = dataArr[indexPath.row].source
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HTTPTOOl.getAllOrderList(start: startDate, end: endDate, source: selectType.id, userID: userID, payType: "", status: "", page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            var tArr: [OrderDetailModel] = []
            for jsonData in json["data"].arrayValue {
                let model = OrderDetailModel()
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
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getAllOrderList(start: startDate, end: endDate, source: selectType.id, userID: userID, payType: "", status: "", page: page).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = OrderDetailModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_footer?.endRefreshing()
        }).disposed(by: bag)
    }

        

    
    
}
