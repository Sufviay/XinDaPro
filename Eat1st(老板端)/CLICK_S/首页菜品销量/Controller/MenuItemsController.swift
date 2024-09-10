//
//  MenuItemsController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit
import RxSwift
import MJRefresh

class MenuItemsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let bag = DisposeBag()
    
    private var dishArr: [DishModel] = []
    
    //查询方式 1天，2周，3月
    private var dataType: String = "3"

    ///查询日期
    private var dateStr: String = DateTool.getDateComponents(date: Date()).month! >= 10 ? "\(DateTool.getDateComponents(date: Date()).year!)-\(DateTool.getDateComponents(date: Date()).month!)" : "\(DateTool.getDateComponents(date: Date()).year!)-0\(DateTool.getDateComponents(date: Date()).month!)"

    ///查询截止日期
    private var endDateStr: String = ""
    
    private var isAll: Bool = false

    
    private let topLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(20), .left)
        lab.text = "Top menu items"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()

    
    
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
            print(str as! String)
            
            if str as! String == "weeks" {
                self.dataType = "2"
            }
            if str as! String == "day" {
                self.dataType = "1"
            }
            if str as! String == "month" {
                self.dataType = "3"
            }
            
            dateStr = ""
            endDateStr = ""

        }
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (arr) in
            let dateArr = arr as! [String]
            print(dateArr[0])
            print(dateArr[1])
            self.dateStr = dateArr[0]
            self.endDateStr = dateArr[1]
            self.loadData_Net()
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
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
        tableView.register(LiveRepotingCell.self, forCellReuseIdentifier: "LiveRepotingCell")
        tableView.register(MenuItemMoreCell.self, forCellReuseIdentifier: "MenuItemMoreCell")
        tableView.register(MenuItemBottonCell.self, forCellReuseIdentifier: "MenuItemBottonCell")
        return tableView
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        self.loadData_Net()

    }
    
    
    private func setUpUI() {
        
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(47)
        }

        
        view.addSubview(topLab)
        topLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalTo(line.snp.top).offset(-7)
        }
        
        
        view.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
            $0.height.equalTo(S_H - bottomBarH - statusBarH - 130 - 110)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 2 {
            return 1
        }
        if section == 0 {
            if dishArr.count > 5 {
                if isAll {
                    return dishArr.count
                } else {
                    return 5
                }
            } else {
                return dishArr.count
            }

        }
        if section == 1 {
            if dishArr.count > 5 {
                return 1
            } else {
                return 0
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            var h1: CGFloat = 0
            var h2: CGFloat = 0
            
            let curL = PJCUtil.getCurrentLanguage()
            if curL == "en_GB" {
                h1  = dishArr[indexPath.row].name_En.getTextHeigh(BFONT(14), S_W - 170)
                h2 = dishArr[indexPath.row].name_Hk.getTextHeigh(SFONT(11), S_W - 170)
                
            } else {
                h1  = dishArr[indexPath.row].name_Hk.getTextHeigh(BFONT(14), S_W - 170)
                h2 = dishArr[indexPath.row].name_En.getTextHeigh(SFONT(11), S_W - 170)
            }

            let returnH = h1 + h2 + 25
            
            return returnH > 55 ? returnH : 55
        }
        if indexPath.section == 1 {
            return 50
        }
        if indexPath.section == 2 {
            return 100
        }
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as! MenuItemCell
            cell.setCellData(model: dishArr[indexPath.row], idx: indexPath.row)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemMoreCell") as! MenuItemMoreCell
            cell.setCellData(isShow: self.isAll)
            cell.clickBlock = { [unowned self] (_) in
                self.isAll = !isAll
                self.table.reloadData()
            }
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemBottonCell") as! MenuItemBottonCell
            
            cell.clickBlock = { [unowned self] (_) in
                self.table.setContentOffset(.zero, animated: true)
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.dataType != "1" {
                let nextVC = DishChartController()
                nextVC.type = dataType
                nextVC.dateStr = self.dateStr
                nextVC.endDateStr = self.endDateStr
                nextVC.dishModel = dishArr[indexPath.row]
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            

        }
    }
}

extension MenuItemsController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        
        if dateStr == "" {
            HUD_MB.showWarnig("Please select a date", onView: view)
            return
        }
        
        HTTPTOOl.getDishesReportingData(type: dataType, day: dateStr, endDay: endDateStr).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [DishModel] = []
            for jsonData in json["data"].arrayValue {
                let model = DishModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            self.dishArr = tArr
            self.table.mj_header?.endRefreshing()
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
        
    }
    
}
