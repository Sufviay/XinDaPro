//
//  PromotionEditController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/18.
//

import UIKit
import RxSwift

class PromotionEditController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var submitModel = CouponModel()
    
    private var dishDataModel = DishDetailComboModel()
    
    ///有效类型 2时间段 1天数
    private var vaildType: String = ""
    
    ///规格停止执行类型 2日期 1永久
    private var deadlineType: String = ""
    
    ///選擇的標籤
    private var selectTag: TypeModel = {
        let model = TypeModel()
        model.id = ""
        if MyLanguageManager.shared.language == .Chinese {
            model.name = "全部"
        } else {
            model.name = "All"
        }
        return model
    }()
    
    private var timeType: String = ""

    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, MAINCOLOR, TIT_2, .clear)
        but.layer.cornerRadius = 14
        but.layer.borderColor = MAINCOLOR.cgColor
        but.layer.borderWidth = 2
        return but
    }()

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
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
        
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(DishEditePriceInPutCell.self, forCellReuseIdentifier: "DishEditePriceInPutCell")
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
        tableView.register(SelectTagCell.self, forCellReuseIdentifier: "SelectTagCell")
        tableView.register(SelectFiveButCell.self, forCellReuseIdentifier: "SelectFiveButCell")
        return tableView
        
    }()

    
    //日历弹窗
    private lazy var calendarView: CalendarAlert = {
        let view = CalendarAlert()
        view.clickDateBlock = { [unowned self] (par) in
            let date = par
            if timeType == "start" {
                submitModel.startDate = date.getString("yyyy-MM-dd")
            }
            if timeType == "end" {
                submitModel.endDate = date.getString("yyyy-MM-dd")
            }
            if timeType == "day" {
                submitModel.ruleDay =  String(Int(date.getString("dd")) ?? 0)
            }
            if timeType == "deadline" {
                submitModel.deadline = date.getString("yyyy-MM-dd")
            }
            table.reloadData()
        }
        return view
    }()

    
    private lazy var weekAlert: SelectWeekAlert = {
        let alert = SelectWeekAlert()

        alert.selectWeekBlock = { [unowned self] (par) in
            submitModel.ruleDay = par
            table.reloadData()
        }
        return alert
    }()
    
    
    private lazy var tagAlert: SelectTypeAlert = {
        let alert = SelectTypeAlert()
        alert.alertType = .customerTag
        
        alert.selectBlock = { [unowned self] (model) in
            selectTag = model as! TypeModel
            table.reloadData()
        }
        return alert
    }()
    
    
    
    override func setNavi() {
        leftBut.setImage(LOIMG("sy_back"), for: .normal)
        biaoTiLab.text = "Edit".local
        table.reloadData()
    }

    
    override func setViews() {
        setUpUI()
    }
    
    
    private func setUpUI() {
                
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
            
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(backView.snp.centerX).offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalTo(backView.snp.centerX).offset(10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }

        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(cancelBut.snp.top).offset(-10)
        }
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickCancelAction() {
        //取消
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSaveAction() {
        //保存
        if submitModel.couponType == "1" {
            //折扣
            submitModel.dishesIdList.removeAll()
            submitModel.couponAmount = ""
        }
        if submitModel.couponType == "2" {
            //满减
            submitModel.dishesIdList.removeAll()
            submitModel.couponScale = ""
            submitModel.couponLimitPrice = ""
        }
        if submitModel.couponType == "3" {
            //赠菜
            submitModel.couponScale = ""
            submitModel.couponLimitPrice = ""
            submitModel.couponAmount = ""
            
            var tArr: [Int64] = []
            for model in dishDataModel.comboDishesList {
                tArr.append(model.dishesId)
            }
            submitModel.dishesIdList = tArr
        }
        
        if vaildType == "2" {
            //时间段
            submitModel.effectiveDay = ""
        }
        if vaildType == "1" {
            //有效天数
            submitModel.startDate = ""
            submitModel.endDate = ""
        }
        
        if submitModel.ruleType == "5" {
            //立即發送
            submitModel.deadline = Date().getString("yyyy-MM-dd")
            submitModel.ruleDay = String(Int(Date().getString("dd")) ?? 0)
        }
        
        if deadlineType == "1" {
            //永久
            submitModel.deadline = ""
        }
        
        submitModel.tagId = selectTag.id
        
        saveAction_Net()
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 19
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 || section == 4 {
            //折扣
            if submitModel.couponType == "1" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 5  {
            //减钱
            if submitModel.couponType == "2" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 6 {
            return 0
        }
        
        
        if section == 7 {
            //赠菜
            if submitModel.couponType == "3" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 8 {
            if submitModel.couponType == "3" && dishDataModel.comboDishesList.count != 0 {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 9 {
            if submitModel.couponType == "3" {
                return dishDataModel.comboDishesList.count
            } else {
                return 0
            }
        }
        
        if section == 11 {
            if vaildType == "2" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 12 {
            if vaildType == "1" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 13 {
            return 0
        }
        
        
        if section == 16 {
            if submitModel.ruleType != "" && submitModel.ruleType != "5" {
                return 1
            } else {
                return 0
            }
        }
        
        if section == 17 {
            if submitModel.ruleType != "5" {
                return 1
            } else {
                return 0
            }
        }
        
        
        if section == 18 {
            if deadlineType == "2" && submitModel.ruleType != "5" {
                return 1
            } else {
                return 0
            }
        }
        
        return 1
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 {
            return 85
        }
        if indexPath.section == 2 {
            return 105
        }
        
        if indexPath.section == 6 {
            let h = "When the minimum eligible order amount is greater than 0, the discount amount must be less than this value.".local.getTextHeigh(TXT_3, S_W - 40) + 15
            return h
        }
        if indexPath.section == 7 {
            return 100
        }
        if indexPath.section == 8 {
            return 50
        }
    
        if indexPath.section == 9 {
            let dishModel = dishDataModel.comboDishesList[indexPath.row]
            let h1 = dishModel.name1.getTextHeigh(TIT_3, S_W - 90)
            let h2 = dishModel.name2.getTextHeigh(TXT_1, S_W - 90)
            return h1 + h2 + 30
        }
        
        if indexPath.section == 10 {
            return 90
        }
        
        if indexPath.section == 11 {
            return 65
        }
        
        if indexPath.section == 12 {
            return 60
        }
        
        if indexPath.section == 13 {
            let h = "The number of valid days is calculated by adding a specified number of days to the issue date.".local.getTextHeigh(TXT_3, S_W - 40) + 15
            return h
        }
        
        if indexPath.section == 14 {
            //標籤
            return 85
        }
        
        if indexPath.section == 15 {
            return 105
        }
        
        if indexPath.section == 16 {
            return 85
        }
        
        if indexPath.section == 17 {
            return 90
        }
        
        if indexPath.section == 18 {
            return 60
        }
        
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            cell.setCellData(titStr: "Promotion name".local, msgStr: submitModel.couponName)
            cell.editeEndBlock = { [unowned self] (str) in
                submitModel.couponName = str
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.setCellData(money: submitModel.dishesMinPrice, titStr: "Min order amount for use".local)
            cell.editeEndBlock = { [unowned self] (str) in
                submitModel.dishesMinPrice = str
            }
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectThreeButCell") as! SelectThreeButCell
            cell.setCellData(titStr: "Coupon type".local, str1: "p_Discount".local, str2: "p_Money".local, str3: "p_Dish".local, selectType: submitModel.couponType)
            cell.clickBlock = { [unowned self] (type) in
                submitModel.couponType = type
                table.reloadData()
            }
            
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditBFBInPutCell") as! EditBFBInPutCell
            cell.setCellData(titStr: "Discount percentage".local, msgStr: submitModel.couponScale)
            cell.editeEndBlock = { [unowned self] (str) in
                submitModel.couponScale = str
            }
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.setCellData(money: submitModel.couponLimitPrice, titStr: "Max amount for discount".local)
            cell.editeEndBlock = { [unowned self] (str) in
                submitModel.couponLimitPrice = str
            }
            return cell
        }
        
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            cell.setCellData(money: submitModel.couponAmount, titStr: "Amount for discount".local)
            cell.editeEndBlock = { [unowned self] (str) in
                submitModel.couponAmount = str
            }
            return cell
        }
        
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceDesCell") as! PriceDesCell
            cell.msgLab.text = "When the minimum eligible order amount is greater than 0, the discount amount must be less than this value.".local
            return cell
        }
        
        if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndButtonCell") as! TitleAndButtonCell
            cell.inLab.text = "Add Dishes".local
            cell.clickAddBlock = { [unowned self] (str) in
                let editdishVC = MenuComboEditDishController()
                editdishVC.pageType = .coupon
                editdishVC.comboModel = dishDataModel
                navigationController?.pushViewController(editdishVC, animated: true)
            }
            return cell
        }
        
        if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
            cell.titlab.text = "Dishes List".local
            cell.sLab.isHidden = true
            return cell
        }
        
        if indexPath.section == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishesAndDeleteCell") as! DishesAndDeleteCell
            let dishModel = dishDataModel.comboDishesList[indexPath.row]
            cell.setCellData(name1: dishModel.name1, name2: dishModel.name2)
            cell.clickDeleteBlock = { [unowned self] _ in
                //删除
                dishDataModel.comboDishesList.remove(at: indexPath.row)
                table.reloadData()
            }
            return cell
        }
        
        if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Promotion validity".local, l_str: "Fix date".local, r_Str: "Days from get".local, statusID: vaildType)
            cell.selectBlock = { [unowned self] type in
                vaildType = type
                table.reloadData()
            }
            return cell
        }
        
        if indexPath.section == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StartAndEndDateCell") as! StartAndEndDateCell
            cell.setCellData(startDate: submitModel.startDate, endDate: submitModel.endDate)
            cell.clickBlock = { [unowned self] type in
                timeType = type
                calendarView.appearAction()
            }
            return cell
        }
        
        if indexPath.section == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputTFCell") as! InputTFCell
            cell.setCellData(msg: submitModel.effectiveDay)
            cell.editeEndBlock = { [unowned self] str in
                submitModel.effectiveDay = str
            }
            return cell
        }
        
        if indexPath.section == 13 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceDesCell") as! PriceDesCell
            cell.msgLab.text = "The number of valid days is calculated by adding a specified number of days to the issue date."
            return cell
        }
        
        if indexPath.section == 14 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTagCell") as! SelectTagCell
            cell.setCellData(titStr: selectTag.name)
            
            cell.clickBlock = { [unowned self] _ in
                //選擇客戶標籤
                tagAlert.appearAction()
            }
            
            return cell
        }
        
        if indexPath.section == 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFiveButCell") as! SelectFiveButCell
            cell.setCellData(titStr: "Cycle type".local, str1: "Immediately".local , str2: "One week".local, str3: "Two weeks".local, str4: "Four weeks".local, str5: "Month".local, selectType: submitModel.ruleType)
            cell.clickBlock = { [unowned self] type in
                submitModel.ruleType = type
                
                if type == "4" {
                    timeType = "day"
                    calendarView.appearAction()
                }
                
                
                if submitModel.ruleType == "1" || submitModel.ruleType == "2" || submitModel.ruleType == "3" {
                    weekAlert.appearAction()
                }
                table.reloadData()
            }
            return cell
        }
        
        if indexPath.section == 16 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeClassifyCell") as! DishEditeClassifyCell
            var msg = ""
            if submitModel.ruleDay != "" {
                if submitModel.ruleType == "4" {
                    msg = submitModel.ruleDay
                } else {
                    //转换成周
                    if submitModel.ruleDay == "1" {
                        msg = "Monday".local
                    }
                    if submitModel.ruleDay == "2" {
                        msg = "Tuesday".local
                    }
                    if submitModel.ruleDay == "3" {
                        msg = "Wednesday".local
                    }
                    if submitModel.ruleDay == "4" {
                        msg = "Thursday".local
                    }
                    if submitModel.ruleDay == "5" {
                        msg = "Friday".local
                    }
                    if submitModel.ruleDay == "6" {
                        msg = "Saturday".local
                    }
                    if submitModel.ruleDay == "7" {
                        msg = "Sunday".local
                    }
                }
            }
            
            cell.setCellData_nor(titStr: "Cycle time".local, msgStr: msg)
            cell.selectBlock = { [unowned self] _ in
                if submitModel.ruleType == "4" {
                    //弹出日历
                    timeType = "day"
                    calendarView.appearAction()
                }
                if submitModel.ruleType == "1" || submitModel.ruleType == "2" || submitModel.ruleType == "3" {
                    //弹出周的选择
                    weekAlert.appearAction()

                }
            }
            
            return cell
        }
        
        if indexPath.section == 17 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Finish date".local, l_str: "Fix date".local, r_Str: "Indefinitely".local, statusID: deadlineType)

            cell.selectBlock = { [unowned self] (type) in
                deadlineType = type
                
                if type == "2" {
                    timeType = "deadline"
                    calendarView.appearAction()
                }
                
                table.reloadData()
            }
            
            return cell
        }
        
        if indexPath.section == 18 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell") as! SelectCell
            cell.setCellData(msg: submitModel.deadline)
            
            cell.clickSelectBlock = { [unowned self] _ in
                timeType = "deadline"
                calendarView.appearAction()
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    private func saveAction_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.addCoupon(model: submitModel).subscribe(onNext: { [unowned self] (json) in
            
            HUD_MB.showSuccess("Success".local, onView: view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }

    
    
}
