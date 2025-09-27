//
//  StoreTimeDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/4/23.
//

import UIKit
import RxSwift


class StoreTimeDetailController: HeadBaseViewController, UITableViewDataSource, UITableViewDelegate, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    var timeModel = DayTimeModel() {
        didSet {
            if timeModel.status == "1" {
                self.rightBut.isHidden = true
            } else {
                self.rightBut.isHidden = false
            }
        }
    }
    
    
    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_delete"), for: .normal)
        return but
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    
    private lazy var table: UITableView = {
        let tableView = UITableView()
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
                
        tableView.register(DishDetailEditeCell.self, forCellReuseIdentifier: "DishDetailEditeCell")
        tableView.register(Detail_OpeningTimeCell.self, forCellReuseIdentifier: "Detail_OpeningTimeCell")
        tableView.register(Detail_CoOrDeStausCell.self, forCellReuseIdentifier: "Detail_CoOrDeStausCell")
        tableView.register(Detail_CoOrDeTimeCell.self, forCellReuseIdentifier: "Detail_CoOrDeTimeCell")
        tableView.register(Detail_TimeStausCell.self, forCellReuseIdentifier: "Detail_TimeStausCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(Detail_TimeWeekCell.self, forCellReuseIdentifier: "Detail_TimeWeekCell")
        tableView.register(OpeningSelectDishCell.self, forCellReuseIdentifier: "OpeningSelectDishCell")
        return tableView
        
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Opening hours".local

    }
    
    
    override func setViews() {
        setUpUI()
    }
    
    
    private func setUpUI() {
        
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
                
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        
        leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        rightBut.addTarget(self, action: #selector(clickDeleteAciton), for: .touchUpInside)
        
    }

    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickDeleteAciton() {
        self.showSystemChooseAlert("Alert".local, "Delete or not".local, "YES".local, "NO".local) {
            self.deleteAction_Net()
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if timeModel.deStatus == "1" {
                return 2
            } else {
                return 1
            }
        }
        
        if section == 3 {
            if timeModel.coStatus == "1" {
                return 2
            } else {
                return 1
            }
        }
        
        if section == 6 {
            return 7
        }

        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let h1 = timeModel.timeName1.getTextHeigh(BFONT(17), S_W - 120)
            let h2 = timeModel.timeName2.getTextHeigh(SFONT(15), S_W - 120)
            return 25 + 15 + h1 + h2
        }
        if indexPath.section == 2 || indexPath.section == 3 {
            if indexPath.row == 1 {
                return 30
            }
        }
        if indexPath.section == 6 {
            return 40
        }
        if indexPath.section == 7 {
            return 60
        }

        return 45
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailEditeCell") as! DishDetailEditeCell
            cell.setCellData(name1: timeModel.timeName1, name2: timeModel.timeName2)
            cell.editeBlock = { [unowned self] (_) in
                //进入编辑菜品页面
                let editeVC = AddStoreTimeController()
                editeVC.timeModel = timeModel
                self.navigationController?.pushViewController(editeVC, animated: true)
            }
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Detail_OpeningTimeCell") as! Detail_OpeningTimeCell
            cell.setCelldata(start: timeModel.startTime, end: timeModel.endTime)
            return cell
        }
        
        if indexPath.section == 2 || indexPath.section == 3 {
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Detail_CoOrDeStausCell") as! Detail_CoOrDeStausCell
                if indexPath.section == 2 {
                    cell.setCellData(titStr: "Delivery".local, status: timeModel.deStatus)
                }
                if indexPath.section == 3 {
                    cell.setCellData(titStr: "Collection".local, status: timeModel.coStatus)
                }
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Detail_CoOrDeTimeCell") as! Detail_CoOrDeTimeCell
                if indexPath.section == 2 {
                    cell.setCellData(titStr: "Delivery time".local, min: timeModel.deMin, max: timeModel.deMax)
                }
                if indexPath.section == 3 {
                    cell.setCellData(titStr: "Collection time".local, min: timeModel.coMin, max: timeModel.coMax)
                }
                return cell
                
            }
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Detail_TimeStausCell") as! Detail_TimeStausCell
            cell.setCellData(status: timeModel.status)
            return cell
        }
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            cell.titlab.text = "Week".local
            cell.sLab.isHidden = true
            return cell
        }
        
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Detail_TimeWeekCell") as! Detail_TimeWeekCell
            let select = timeModel.timeSelectWeek.contains(indexPath.row + 1)
            cell.setCellData(idx: indexPath.row, select: select)
            return cell
        }
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningSelectDishCell") as! OpeningSelectDishCell
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 7 {
            //选择菜的信息
            let nextVC = StoreTimeBindingDishController()
            nextVC.timeID = timeModel.timeId
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    
    
    private func deleteAction_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteOpeningHours(timeID: timeModel.timeId).subscribe(onNext: { json in
            HUD_MB.showSuccess("Success", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}
