//
//  OccupyController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit
import RxSwift

class OccupyController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
        
    var storeID: String = ""
    
    var storeName: String = ""
    
    var storeDes: String = ""
        
    private var occupyInfo = OccupyInfoModel()
    
    private var submitModel = OccupyModel()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        tableView.register(OccupyStoreInfoCell.self, forCellReuseIdentifier: "OccupyStoreInfoCell")
        tableView.register(OccupyPersonInfoCell.self, forCellReuseIdentifier: "OccupyPersonInfoCell")
        tableView.register(OccupyDateCell.self, forCellReuseIdentifier: "OccupyDateCell")
        tableView.register(OccupyLabCell.self, forCellReuseIdentifier: "OccupyLabCell")
        tableView.register(OccupyTimeCell.self, forCellReuseIdentifier: "OccupyTimeCell")
        return tableView
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("F7F7F7")
        return view
    }()
    
    private let submitBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", FONTCOLOR, BFONT(15), MAINCOLOR)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    //日历弹窗
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
    
        view.clickDateBlock = { [unowned self] (par) in
            print(par)
            
            if par != submitModel.date {
                submitModel.date = par
                submitModel.reserveId = ""
                loadTimeList_Net()
            }
        }
        
        return view
    }()

    
    private lazy var numView: OccupyNumView = {
        let view = OccupyNumView()
        
        view.selectBlock = { [unowned self] (num) in
            submitModel.reserveNum = num as! Int
            submitModel.reserveId = ""
            table.reloadData()
        }
        
        return view
    }()
    
    
    override func setNavi() {
        naviBar.headerTitle = "Booking"
        naviBar.leftImg = LOIMG("nav_back")
        naviBar.rightBut.isHidden = true
    }

    override func setViews() {
        setUpUI()
        loadTimeList_Net()
    }
    
    
    private func setUpUI() {
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom)
            $0.height.equalTo(10)
        }
        
        view.addSubview(submitBut)
        submitBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(submitBut.snp.top).offset(-10)
            $0.top.equalTo(line.snp.bottom)
        }
        
        submitBut.addTarget(self, action: #selector(clickSubmitAction), for: .touchUpInside)
        
    }
    
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickSubmitAction() {
    
        
        if submitModel.name == "" {
            HUD_MB.showWarnig("Please fill in your name.", onView: view)
            return
        }
        
        if submitModel.phone == "" {
            HUD_MB.showWarnig("Please fill in the phone number.", onView: view)
            return
        }
        
        if submitModel.email == "" {
            HUD_MB.showWarnig("Please fill in the email.", onView: view)
            return

        }
        
        if submitModel.reserveId == "" {
            HUD_MB.showWarnig("Please select time.", onView: view)
            return
        }
        
        submitOccupy_Net()
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let name_H = storeName.getTextHeigh(BFONT(18), S_W - 40)
            let des_H = storeDes.getTextHeigh(SFONT(13), S_W - 40)
            return name_H + des_H + 43
        }
        
        if indexPath.row == 1 {
            return 140
        }
        
        if indexPath.row == 2 {
            return 90
        }
        
        if indexPath.row == 3 {
            return 55
        }
        
        if indexPath.row == 4 {
            return occupyInfo.time_H
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OccupyStoreInfoCell") as! OccupyStoreInfoCell
            cell.setCellData(name: storeName, des: storeDes)
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OccupyPersonInfoCell") as! OccupyPersonInfoCell
            cell.setCellData(model: submitModel)
            cell.editNameBlock = { [unowned self] (str) in
                submitModel.name = str
            }
            
            cell.editPhoneBlock = { [unowned self] (str) in
                submitModel.phone = str
            }
            
            cell.editEmailBlock = { [unowned self] (str) in
                submitModel.email = str
            }
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OccupyDateCell") as! OccupyDateCell
            cell.setCellData(model: submitModel)
            
            cell.clickNumBlock = { [unowned self] _ in
                numView.appearAction()
            }
            
            cell.clickDateBlock = { [unowned self] _ in
                
                calendarView.maxCount = occupyInfo.maxDayNum
                calendarView.appearAction()
            }
            
            return cell
        }
        
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OccupyLabCell") as! OccupyLabCell
            return cell
        }
        
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OccupyTimeCell") as! OccupyTimeCell
            cell.setCellData(arr: occupyInfo.timeList, selID: submitModel.reserveId, inputNum: submitModel.reserveNum)
            cell.selectTimeBlock = { [unowned self] (id) in
                submitModel.reserveId = id
            }
            return cell
        }
        
        
        
        let cell = UITableViewCell()
        return cell
    }

}


extension OccupyController {
    
    //MARK: - 网络请求
    private func loadTimeList_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getCanOccpuyTimeList(id: storeID, date: submitModel.date).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            occupyInfo.updateModel(json: json["data"])
    
            if submitModel.date == "" {
                submitModel.date = occupyInfo.localDate
            }
            
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    //MARK: - 提交
    private func submitOccupy_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doUserOccupy(model: submitModel).subscribe(onNext: { [unowned self] (json) in
            
            var views: [UIViewController] = navigationController!.viewControllers
            views.removeLast()
            views.append(OccupySuccessController())
            navigationController?.setViewControllers(views, animated: true)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
        
    }
    
    
}
