//
//  PromotionDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/20.
//

import UIKit
import RxSwift

class PromotionDetailController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    var id: String = ""
    
    private var sectionNum: Int = 0
    
    private var dataModel = CouponModel()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
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
        
        tableView.register(DishDetailMsgCell.self, forCellReuseIdentifier: "DishDetailMsgCell")
        tableView.register(PromotionDetailDishCell.self, forCellReuseIdentifier: "PromotionDetailDishCell")
        tableView.register(SelectThreeButCell.self, forCellReuseIdentifier: "SelectThreeButCell")
        tableView.register(EditBFBInPutCell.self, forCellReuseIdentifier: "EditBFBInPutCell")
        tableView.register(PriceDesCell.self, forCellReuseIdentifier: "PriceDesCell")
        tableView.register(TitleAndButtonCell.self, forCellReuseIdentifier: "TitleAndButtonCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(DishesAndDeleteCell.self, forCellReuseIdentifier: "DishesAndDeleteCell")
        tableView.register(SelectFourButCell.self, forCellReuseIdentifier: "SelectFourButCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(StartAndEndDateCell.self, forCellReuseIdentifier: "StartAndEndDateCell")
        tableView.register(InputTFCell.self, forCellReuseIdentifier: "InputTFCell")
        tableView.register(SelectCell.self, forCellReuseIdentifier: "SelectCell")
        tableView.register(DishEditeClassifyCell.self, forCellReuseIdentifier: "DishEditeClassifyCell")
        return tableView
        
    }()

    
    override func setNavi() {
        leftBut.setImage(LOIMG("sy_back"), for: .normal)
        biaoTiLab.text = "Detail".local
    }

    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
                
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 || section == 4 {
            //折扣
            if dataModel.couponType == "1" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 5  {
            //减钱
            if dataModel.couponType == "2" {
                return 1
            } else {
                return 0
            }
        }

        if section == 6 {
            //贈菜
            if dataModel.couponType == "3" {
                return dataModel.dishesArr.count
            } else {
                return 0
            }
        }
        
        if section == 8 || section == 9 {
            if dataModel.startDate != "" && dataModel.endDate != "" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 10 {
            if dataModel.effectiveDay != "" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 13 {
            if dataModel.ruleType != "5" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 15 {
            return dataModel.issueDateArr.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            let h = dataModel.couponName.getTextHeigh(TXT_1, S_W - 80)
            return h + 50
        }
        
        if indexPath.section == 6 {
            let h = dataModel.dishesArr[indexPath.row].getTextHeigh(TXT_1, S_W - 125) + 20
            return h
        }
        
        if indexPath.section == 11 {
            let h = dataModel.tagStr.getTextHeigh(TXT_1, S_W - 80)
            return h + 50
        }

        
        if indexPath.section == 15 {
            return 35
        }
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 7 || indexPath.section == 8 || indexPath.section == 9 || indexPath.section == 10 || indexPath.section == 11 || indexPath.section == 12 || indexPath.section == 13 || indexPath.section == 14 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
            
            if indexPath.section == 0 {
                cell.setCellData(titStr: "Promotion name".local, msgStr: dataModel.couponName)
            }
            if indexPath.section == 1 {
                cell.setCellData(titStr: "Min order amount for use".local, msgStr: "£" + dataModel.dishesMinPrice)
            }
            if indexPath.section == 2 {
                
                var msg = ""
                if dataModel.couponType == "1" {
                    msg = "p_Discount".local
                }
                if dataModel.couponType == "2" {
                    msg = "p_Money".local
                }
                if dataModel.couponType == "3" {
                    msg = "p_Dish".local
                }
                
                cell.setCellData(titStr: "Coupon type".local, msgStr: msg)
            }
            
            if indexPath.section == 3 {
                cell.setCellData(titStr: "Discount percentage".local, msgStr: dataModel.couponScale + "%")
            }
            if indexPath.section == 4 {
                cell.setCellData(titStr: "Max amount for discount".local, msgStr: "£" + dataModel.couponLimitPrice)
            }
            
            if indexPath.section == 5 {
                cell.setCellData(titStr: "Amount for discount".local, msgStr: "£" + dataModel.couponAmount)
            }
            
            if indexPath.section == 7 {
                
                var msg = ""
                if dataModel.endDate != "" && dataModel.startDate != "" {
                    msg = "Fix date".local
                }
                if dataModel.effectiveDay != "" {
                    msg = "Days from get".local
                }
                
                cell.setCellData(titStr: "Promotion validity".local, msgStr: msg)
            }
            
            if indexPath.section == 8 {
                cell.setCellData(titStr: "Start Data".local, msgStr: dataModel.startDate)
            }
            
            if indexPath.section == 9 {
                cell.setCellData(titStr: "End Data".local, msgStr: dataModel.endDate)
            }
            
            if indexPath.section == 10 {
                cell.setCellData(titStr: "Validity days".local, msgStr: dataModel.effectiveDay)
            }
            
            if indexPath.section == 11 {
                cell.setCellData(titStr: "Customer Tags".local, msgStr: dataModel.tagStr)
            }
            
            if indexPath.section == 12 {
                var msg = ""
                if dataModel.ruleType == "1" {
                    msg = "One week".local
                }
                if dataModel.ruleType == "2" {
                    msg = "Two weeks".local
                }
                if dataModel.ruleType == "3" {
                    msg = "Four weeks".local
                }
                if dataModel.ruleType == "4" {
                    msg = "Month".local
                }
                if dataModel.ruleType == "5" {
                    msg = "Immediately".local
                }
                cell.setCellData(titStr: "Cycle type".local, msgStr: msg)
            }
            
            if indexPath.section == 13 {
                var msg = ""
                if dataModel.ruleType == "4" {
                    msg = dataModel.ruleDay
                } else {
                    if dataModel.ruleDay == "1" {
                        msg = "Monday".local
                    }
                    if dataModel.ruleDay == "2" {
                        msg = "Tuesday".local
                    }
                    if dataModel.ruleDay == "3" {
                        msg = "Wednesday".local
                    }
                    if dataModel.ruleDay == "4" {
                        msg = "Thursday".local
                    }
                    if dataModel.ruleDay == "5" {
                        msg = "Friday".local
                    }
                    if dataModel.ruleDay == "6" {
                        msg = "Saturday".local
                    }
                    if dataModel.ruleDay == "7" {
                        msg = "Sunday".local
                    }
                }
                
                cell.setCellData(titStr: "Cycle time".local, msgStr: msg)
            }
            
            if indexPath.section == 14 {
                var msg = ""
                if dataModel.deadline == "" {
                    msg = "Indefinitely".local
                } else {
                    msg = dataModel.deadline
                }
                
                cell.setCellData(titStr: "Finish date".local, msgStr: msg)
            }
            
            return cell
        }
        
        if indexPath.section == 6 || indexPath.section == 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionDetailDishCell") as! PromotionDetailDishCell
            if indexPath.section == 6 {
                cell.setCellData(titStr: "Dish name".local + ":", msgStr: dataModel.dishesArr[indexPath.row])
            }
            if indexPath.section == 15 {
                cell.setCellData(titStr: "Issue date".local + ":", msgStr: dataModel.issueDateArr[indexPath.row])
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }

    
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getCouponDetail(id: id).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            dataModel.updateModel(json: json["data"])
            sectionNum = 16
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
}
