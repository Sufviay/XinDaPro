//
//  AddBookingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit
import RxSwift


class AddBookingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var submitModel = AddBookingModel()
    
    private var dateList: [String] = []
    private var tableList: [TableModel] = []
    private var timeList: [BookingTimeModel] = []
    
    private var rowNum: Int = 0
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 15
        return but
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
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
        tableView.sectionHeaderHeight = 65
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(DishEditeClassifyCell.self, forCellReuseIdentifier: "DishEditeClassifyCell")
        tableView.register(BookingTimeCell.self, forCellReuseIdentifier: "BookingTimeCell")
        tableView.register(BookingTimeNullCell.self, forCellReuseIdentifier: "BookingTimeNullCell")
        return tableView
        
    }()
    
    private lazy var selectAlert: SelecItemAlert =  {
        let alert = SelecItemAlert()
        alert.selectBlock = { [unowned self] dic in
            
            let info = dic as! [String: Any]
            let type = info["type"] as! String
            
            if type == "num" {
                submitModel.reserveNum = (info["idx"] as! Int) + 1
                //submitModel.reserveId = ""
                table.reloadData()
            }
            if type == "date" {
                submitModel.date = dateList[(info["idx"] as! Int)]
                submitModel.reserveId = ""
                loadTimeData_Net()
            }
        }
        return alert
    }()
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }

    
    private func setUpUI() {
        leftBut.setImage(LOIMG("sy_back"), for: .normal)
        biaoTiLab.text = "Booking"
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalTo(saveBut.snp.top).offset(-15)
        }
        
        
        leftBut.addTarget(self, action: #selector(clickLeftAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    @objc private func clickLeftAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSaveAction() {
        addBooking_Net()
    }



}

extension AddBookingController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            if timeList.count == 0 {
                return 300
            } else {
                let count = ceil(Double(timeList.count) / 3)
                return CGFloat(count) * 35 + (CGFloat(count) - 1) * 10 + 90
            }
        }
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            if indexPath.row == 0 {
                cell.setCellData(titStr: "Name", msgStr: submitModel.name)
            }
            if indexPath.row == 3 {
                cell.setCellData(titStr: "Contact way", msgStr: submitModel.phone)
            }
            
            if indexPath.row == 4 {
                cell.setCellData(titStr: "Email", msgStr: submitModel.email)
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                if indexPath.row == 0 {
                    submitModel.name = text
                }
                if indexPath.row == 3 {
                    submitModel.phone = text
                }
                
                if indexPath.row == 4 {
                    submitModel.email = text
                }
            }
            return cell
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeClassifyCell") as! DishEditeClassifyCell
            if indexPath.row == 1 {
                cell.setCellData_nor(titStr: "Party", msgStr: String(submitModel.reserveNum))
            }
            if indexPath.row == 2 {
                cell.setCellData_nor(titStr: "Date", msgStr: submitModel.date)
            }

            
            cell.selectBlock = { [unowned self] _ in
                
                if indexPath.row == 1 {
                    selectAlert.setNumData()
                }
                
                if indexPath.row == 2 {
                    selectAlert.setDateData(dateList: dateList)
                }
                
                selectAlert.appearAction()
            }
            return cell
        }
        
        if indexPath.row == 5 {
            
            if timeList.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTimeNullCell") as! BookingTimeNullCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTimeCell") as! BookingTimeCell
                cell.setCellData(timeList: timeList, inputCount: submitModel.reserveNum, timeID: submitModel.reserveId)
                
                cell.selectItemBlock = { [unowned self] (id) in
                    submitModel.reserveId = id
                }
                
                return cell
            }
        }
        
        
        let cell = UITableViewCell()
        return cell
    }
    

}



extension AddBookingController {
    
    //获取餐桌和预约日期
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeskList(page: 1).subscribe(onNext: { [unowned self] (json) in
            //餐桌
            var tArr: [TableModel] = []
            for jsonData in json["data"].arrayValue {
                let model = TableModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            tableList = tArr
            
            HTTPTOOl.getStoreBookingTime(date: "").subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: view)
                //日期
                submitModel.date = json["data"]["localDate"].stringValue
                let curDate = json["data"]["localDate"].stringValue.changeDate(formatter: "yyyy-MM-dd") ?? Date()
                let nextCount = json["data"]["maxDayNum"].intValue
                dateList = curDate.getSomeOneDateWith(count: nextCount)
                
                var tarr: [BookingTimeModel] = []
                for jsonData in json["data"]["timeList"].arrayValue {
                    let model = BookingTimeModel()
                    model.updateModel(json: jsonData)
                    tarr.append(model)
                }
                
                timeList = tarr
                rowNum = 6
                table.reloadData()
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }).disposed(by: bag)
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    private func loadTimeData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStoreBookingTime(date: submitModel.date).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)

            var tarr: [BookingTimeModel] = []
            for jsonData in json["data"]["timeList"].arrayValue {
                let model = BookingTimeModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            timeList = tarr
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)

    }
    
    private func addBooking_Net() {
        
        if submitModel.name == "" {
            HUD_MB.showWarnig("Please fill in the name", onView: view)
            return
        }
        
        if submitModel.phone == "" {
            HUD_MB.showWarnig("Please fill in the contact information", onView: view)
            return
        }
        
        if submitModel.email == "" {
            HUD_MB.showWarnig("Please fill in the Email", onView: view)
            return

        }
        if submitModel.reserveId == "" {
            HUD_MB.showWarnig("Please select time", onView: view)
            return
        }
        
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.addBooking(model: submitModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success", onView: view)
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
        
    }
    
}
