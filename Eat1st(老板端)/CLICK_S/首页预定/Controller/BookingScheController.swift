//
//  BookingScheController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit
import RxSwift
import MJRefresh

class BookingScheController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let bag = DisposeBag()
    
    //private var tableList: [TableModel] = []
    //弹窗中的日期
    private var dateList_Alert: [DateModel] = []
    ///快捷方式中的日期
    private var dateList_view: [DateModel] = []
    
    ///页面数据
    private var dataModel = BookChartDataModel()
    
    
    //选择的日期
    private var selectDate = DateModel() {
        didSet {
            dateLab.text = selectDate.yearDate
            loadBookData_Net()
        }
    }
    
    
    private lazy var selectAlert: SelecItemAlert =  {
        let alert = SelecItemAlert()
        alert.selectBlock = { [unowned self] dic in
            let info = dic as! [String: Any]
            selectDate = dateList_Alert[(info["idx"] as! Int)]
            dateView.setData(timeList: dateList_view, curDate: selectDate.yearDate)
        }
        return alert
    }()

    
    

    private let dateBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(11), .left)
        lab.text = "2024-11-23"
        return lab
    }()
    
    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sj_show")
        return img
    }()
    
    
    
    private lazy var dateView: DateSelectView = {
        let view = DateSelectView()
        view.selectItemBlock = { [unowned self] (idx) in
            selectDate = dateList_view[idx]
        }
        return view
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
        tableView.register(ChartBackTableCell.self, forCellReuseIdentifier: "ChartBackTableCell")
        return tableView
    }()
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "ADD", HCOLOR("#465DFD"), BFONT(15), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.layer.cornerRadius = 10
        but.setImage(LOIMG("dis_add"), for: .normal)
        return but
    }()


    private lazy var detailAlert: BookingDeatilAlert = {
        let alert = BookingDeatilAlert()
        return alert
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addNotificationCenter()
        loadData_Net()
        
    }
    
    private func setUpUI() {
        view.addSubview(dateBut)
        dateBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(30)
            $0.top.equalToSuperview().offset(5)
        }
        
        dateBut.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        dateBut.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 6))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        view.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(65)
            $0.top.equalTo(dateBut.snp.bottom).offset(10)
        }
        view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.height.equalTo(40)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(dateView.snp.bottom).offset(15)
            $0.bottom.equalTo(addBut.snp.top).offset(-15)
        }
    
        
        dateBut.addTarget(self, action: #selector(clickDateAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)

        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            loadBookData_Net()
        }
        
    }
    
    
    @objc private func clickDateAction() {
        selectAlert.appearAction()
    }
    
    
   @objc private func clickAddAction() {
       loadBookStatus_Net()
    }

    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "bookList"), object: nil)
    }
    
    deinit {
        print("\(self.classForCoder)销毁")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("bookList"), object: nil)
    }
    
    @objc func refresh() {
        loadBookData_Net()
    }
    
}


extension BookingScheController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataModel.lineCount) * 45 + 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartBackTableCell") as! ChartBackTableCell
        cell.setCellData(model: dataModel)
        cell.clickBlock = { [unowned self] (model) in
            detailAlert.setData(model: model as! BookingContentModel)
            detailAlert.appearAction()
        }
        return cell
    }

}


extension BookingScheController {
    
    
    //获取餐桌和预约日期
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
//        HTTPTOOl.getDeskList(page: 1).subscribe(onNext: { [unowned self] (json) in
//            //餐桌
//            var tArr: [TableModel] = []
//            for jsonData in json["data"].arrayValue {
//                let model = TableModel()
//                model.updateModel(json: jsonData)
//                tArr.append(model)
//            }
//            tableList = tArr
            
            HTTPTOOl.getStoreBookingTime(date: "").subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: view)
                //日期
                let curDate = json["data"]["localDate"].stringValue.changeDate(formatter: "yyyy-MM-dd") ?? Date()
                let nextCount = json["data"]["maxDayNum"].intValue
                dateList_Alert = curDate.getSomeOneDateModelWith(count: nextCount)
                dateList_view = curDate.getSomeOneDateModelWith(count: 7)
                
                selectDate = dateList_Alert.first ?? DateModel()
                selectAlert.setDateModelData(dateList: dateList_Alert)
                dateView.setData(timeList: dateList_view, curDate: selectDate.yearDate)
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }).disposed(by: bag)
//        }, onError: { [unowned self] (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
//        }).disposed(by: bag)
    }
    
    
    private func loadBookData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getBookingDataInCharts(date: selectDate.yearDate).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            table.mj_header?.endRefreshing()
            dataModel.updateModel(json: json)
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadBookStatus_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreBookingStatus().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            if json["data"]["reserveStatus"].stringValue == "2" {
                //开启了
                let nextVC = AddBookingController()
                navigationController?.pushViewController(nextVC, animated: true)
            } else {
                //未开启
                HUD_MB.showWarnig("The reservation function is disabled", onView: view)
            }
            
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
    }
    
}



