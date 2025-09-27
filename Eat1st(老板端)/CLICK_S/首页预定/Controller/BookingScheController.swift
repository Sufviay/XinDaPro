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
    
    
    private lazy var calendarView: CalendarAlert = {
        let view = CalendarAlert()
        
        view.clickDateBlock = { [unowned self] (par) in
        
            
            let model = DateModel()
            model.updateModel(date: par)
            selectDate = model
            dateView.setData(timeList: dateList_view, curDate: selectDate.yearDate)
        }
        
        return view
    }()
    
    
    private let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_5
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let l_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "L:"
        return lab
    }()
    
    private let d_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "D:"
        return lab
    }()
    
    
    private let l_number: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "0"
        return lab
    }()
    
    private let d_number: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "0"
        return lab
    }()

    
    
    

    private let dateBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = BACKCOLOR_3
        but.layer.cornerRadius = 5
        return but
    }()
    
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
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
    
    
    private let timeHeaderView: BookingTimeView = {
        let view = BookingTimeView()
        return view
    }()
    
    
    
    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Add".local, MAINCOLOR, TIT_3, BACKCOLOR_3)
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
        
       // S_H - bottomBarH - statusBarH - 130  - 55
        
        view.addSubview(totalView)
        totalView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(135)
        }
        
        totalView.addSubview(l_lab)
        l_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        totalView.addSubview(d_lab)
        d_lab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(70)
        }
        
        totalView.addSubview(l_number)
        l_number.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(l_lab.snp.right).offset(3)
        }
        
        totalView.addSubview(d_number)
        d_number.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(d_lab.snp.right).offset(3)
        }
        
        
        
        view.addSubview(dateBut)
        dateBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalTo(totalView.snp.left).offset(-10)
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(15)
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
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(S_H - bottomBarH - statusBarH - 130  - 50)
            //$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            
        }
        
        
        view.addSubview(timeHeaderView)
        timeHeaderView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
            $0.top.equalTo(dateView.snp.bottom).offset(15)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(timeHeaderView.snp.bottom)
            $0.bottom.equalTo(addBut.snp.top).offset(-15)
        }
    
        
        dateBut.addTarget(self, action: #selector(clickDateAction), for: .touchUpInside)
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
        
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadBookData_Net(true)
        }
    }
    
    
    @objc private func clickDateAction() {
        
        calendarView.appearAction()
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
        return CGFloat(dataModel.lineCount) * 45
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
    
        //处理日期
        let curDateModel = DateModel()
        curDateModel.updateModel(date: Date())
        selectDate = curDateModel
        dateList_view = Date().getSomeOneDateModelWith(count: 30)
        dateView.setData(timeList: dateList_view, curDate: selectDate.yearDate)
        
    }
    
    
    private func loadBookData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getBookingDataInCharts(date: selectDate.yearDate).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            table.mj_header?.endRefreshing()
            dataModel.updateModel(json: json)
            l_number.text = String(dataModel.lunchNum)
            d_number.text = String(dataModel.dinnerNum)
            timeHeaderView.setData(timeArr: dataModel.timeArr)
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



