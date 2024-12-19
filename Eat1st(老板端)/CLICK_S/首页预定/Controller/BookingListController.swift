//
//  BookingListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit
import RxSwift
import MJRefresh

class BookingListController: UIViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    private let bag = DisposeBag()
    
    private var dataArr: [BookingContentModel] = []
    
    ///1new，2店家拒绝，3取消预定，4预定成功， 5顾客已到  ""为recrod
    private var listStatus: String = "4"
    
    private var page: Int = 1
    
    ///当前处理的预定编码
    private var dealUserReserveId: String = ""

    private let addBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "ADD", HCOLOR("#465DFD"), BFONT(15), HCOLOR("#8F92A1").withAlphaComponent(0.06))
        but.layer.cornerRadius = 10
        but.setImage(LOIMG("dis_add"), for: .normal)
        return but
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        view.layer.cornerRadius = 15

        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 5

        return view
    }()
    
    
    private lazy var tagView: ListTagView = {
        let view = ListTagView()
        view.selectTagItemBlock = { [unowned self] (idx) in
            table.setContentOffset(.zero, animated: true)
            if idx == 0 {
                listStatus = "4"
            }
            if idx == 1{
                listStatus = "5"
            }
            if idx == 2 {
                listStatus = "3"
            }
            if idx == 3 {
                listStatus = ""
            }
            loadData_Net()
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
        tableView.register(BookingListContentCell.self, forCellReuseIdentifier: "BookingListContentCell")
        tableView.register(BookingListButCell.self, forCellReuseIdentifier: "BookingListButCell")
        return tableView
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()
    
    private lazy var deskAlert: TableSelectAlert = {
        let view = TableSelectAlert()
        
        view.selectBlock = { [unowned self] (id) in
            doDeal_Net(id: dealUserReserveId, deskID: id, type: "4")
        }
        return view
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("aaaa")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addNotificationCenter()
        loadData_Net()
    }
    
    
    func setUpUI() {
        view.addSubview(addBut)
        addBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.height.equalTo(40)
        }
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(addBut.snp.top).offset(-10)
            $0.top.equalToSuperview().offset(5)
        }
        
        
        backView.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(35)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(tagView.snp.bottom)
        }
        
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            loadDataMore_Net()
        }
        
        addBut.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
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
        loadData_Net()
    }


}


extension BookingListController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        
        let model = dataArr[section]
        if model.reserveStatus == "5" {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 170
        }
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingListContentCell") as! BookingListContentCell
            cell.setCellDate(model: model)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingListButCell") as! BookingListButCell
            cell.setCellData(model: model)
            
            cell.clickCancelBlock = { [unowned self] (_) in
                //取消
                showSystemChooseAlert("Alert", "Cancel or not?", "YES", "NO") { [unowned self] in
                    doCancel_Net(id: dataArr[indexPath.section].userReserveId)
                }
            }
            
            cell.clickRejectBlock = { [unowned self] (_) in
                //拒绝
                showSystemChooseAlert("Alert", "Refuse or not?", "YES", "NO") { [unowned self] in
                    doDeal_Net(id: dataArr[indexPath.section].userReserveId, deskID: "", type: "2")
                }
            }
            
            cell.clickConfirmBlock = { [unowned self] (_) in
                //确认 弹出餐桌选择
                dealUserReserveId = dataArr[indexPath.section].userReserveId
                deskAlert.appearAction()
            }
            
            cell.clickReconfirmBlock = { [unowned self] (_) in
                //恢复
                doReconfirm_Net(id: dataArr[indexPath.section].userReserveId)
            }
            
            
            cell.clickCheckInBlock = { [unowned self] (_) in
                //checkIn
                doCheckIn_Net(id: dataArr[indexPath.section].userReserveId)
            }

            
            
            return cell
        }
        

    }
    
}


extension BookingListController {
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getUserBookingList(page: 1, type: listStatus).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.dissmiss(onView: view)
            page = 2
            var tArr: [BookingContentModel] = []
            for jsonData in json["data"].arrayValue {
                let model = BookingContentModel()
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
            table.mj_header?.endRefreshing()
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getUserBookingList(page: page, type: listStatus).subscribe(onNext: {[unowned self] (json) in

            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                page += 1
                for jsonData in json["data"].arrayValue {
                    let model = BookingContentModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }

    
    //取消预约
    private func doCancel_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCancelBooking(id: id).subscribe(onNext: { (json) in
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
    }
    
    
    //处理预约
    private func doDeal_Net(id: String, deskID: String, type: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doConfirmBooking(id: id, type: type, deskID: deskID).subscribe(onNext: { (json) in
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
    }
    
    //恢复预约
    private func doReconfirm_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doReconfimBooking(id: id).subscribe(onNext: { (json) in
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
    }
    
    
    //checkin预约
    private func doCheckIn_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doCheckinBooking(id: id).subscribe(onNext: { (json) in
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
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
