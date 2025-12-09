//
//  FirstPageOrderController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/12/6.
//

import UIKit
import RxSwift


class FirstPageOrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userID: String = ""
    private var dataArr: [OrderDetailModel] = []

    private let bag = DisposeBag()
    private var page: Int = 1
    //查询方式 1天，2周，3月
    private var dateType: String = "3"

    //默認當前月
    private var startDate: String = Date().getString("yyyy-MM") + "-01"
    private var endDate: String = DateTool.getMonthLastDate(monthStr: Date().getString("yyyy-MM"))
    
    private var selectType = TypeModel(id: "", name: "All".local)
    

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
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    
    private lazy var typeAlert: SelectTypeAlert = {
        let view = SelectTypeAlert()
        view.alertType = .mealTime
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

    
    private let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F8FF")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let totalLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_5, .left)
        lab.text = "Price:".local
        return lab
    }()
    
    
    private let totalNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "0"
        return lab
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


    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadData_Net()
        
    }
    
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        view.addSubview(totalView)
        totalView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(filtrateView)
            $0.top.equalTo(filtrateView.snp.bottom).offset(10)
            $0.width.equalTo(175)
        }
        
        
        totalView.addSubview(totalLab)
        totalLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(12)
            $0.width.equalTo(("Price:".local.getTextWidth(TIT_5, 15) + 1))
        }
        
        totalView.addSubview(totalNum)
        totalNum.snp.makeConstraints {
            $0.bottom.equalTo(totalLab.snp.bottom).offset(1)
            $0.left.equalTo(totalLab.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-5)
        }

        view.addSubview(typeBut)
        typeBut.snp.makeConstraints {
            $0.left.height.equalTo(filtrateView)
            $0.right.equalTo(totalView.snp.left).offset(-10)
            $0.top.equalTo(filtrateView.snp.bottom).offset(10)
        }
        
        
        typeBut.addSubview(xlImg1)
        xlImg1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }
        
        typeBut.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)

        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(typeBut.snp.bottom).offset(15)
            //$0.bottom.equalTo(view.snp.bottom).offset(-25 - bottomBarH)
            $0.height.equalTo(S_H - statusBarH - bottomBarH - 255)
        }
        
        typeBut.addTarget(self, action: #selector(clickClassifyAction), for: .touchUpInside)
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        table.mj_footer = CustomRefreshFooter() { [unowned self] in
            loadDataMore_Net()
        }



    }
    
    @objc private func clickClassifyAction() {
        typeAlert.appearAction()
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
        HTTPTOOl.getAllOrderList(start: startDate, end: endDate, source: "", userID: userID, payType: "", status: "", timePeriod: selectType.id, page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            
            
            var price: Double = 0
            price = json["data"]["totalPrice"].doubleValue
            totalNum.text = "£" + D_2_STR(price)
            
            var tArr: [OrderDetailModel] = []
            for jsonData in json["data"]["list"].arrayValue {
                let model = OrderDetailModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            dataArr = tArr
            if dataArr.count == 0 {
                table.layoutIfNeeded()
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
        HTTPTOOl.getAllOrderList(start: startDate, end: endDate, source: "", userID: userID, payType: "", status: "", timePeriod: selectType.id, page: page).subscribe(onNext: { [unowned self] (json) in
            
            if json["data"]["list"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"]["list"].arrayValue {
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
