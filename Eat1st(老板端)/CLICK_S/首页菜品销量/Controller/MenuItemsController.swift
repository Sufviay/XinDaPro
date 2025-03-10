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
    
    private var selectClassifyID: String = ""
    
    //查询方式 1天，2周，3月
    private var dataType: String = "3"

    ///查询日期
    private var dateStr: String = DateTool.getDateComponents(date: Date()).month! >= 10 ? "\(DateTool.getDateComponents(date: Date()).year!)-\(DateTool.getDateComponents(date: Date()).month!)" : "\(DateTool.getDateComponents(date: Date()).year!)-0\(DateTool.getDateComponents(date: Date()).month!)"

    ///查询截止日期
    private var endDateStr: String = ""
        
    
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
            
            if str == "Week".local {
                self.dataType = "2"
            }
            if str == "Day".local {
                self.dataType = "1"
            }
            if str == "Month".local {
                self.dataType = "3"
            }
        }
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (arr) in
            let dateArr = arr as! [String]
            print(dateArr[0])
            print(dateArr[1])
            self.dateStr = dateArr[0]
            self.endDateStr = dateArr[1]
            loadData_Net()
        }
        
        return view
    }()

    private let classifyBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F6F6F6")
        but.clipsToBounds = true
        but.layer.cornerRadius = 5
        return but
    }()
    
    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl_b")
        return img
    }()
    
    
    private let classifyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "All"
        return lab
    }()
    
    
    private let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F5F8FF")
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let totalLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(14), .left)
        lab.text = "Total:"
        return lab
    }()
    
    private let totalNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#222222"), BFONT(16), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = ""
        return lab
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

    
    private lazy var classifyAlert: StatisClassifyAlert = {
        let alert = StatisClassifyAlert()
        alert.selectBlock = { [unowned self] (par) in
            let dic: [String: String] = par as! [String: String]
            selectClassifyID = dic["id"]!
            classifyLab.text = dic["name"]!
            loadData_Net()
        }
        return alert
    }()
    
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        self.loadData_Net()

    }
    
    
    private func setUpUI() {
        
        
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
            $0.width.equalTo(130)
        }
        
        
        totalView.addSubview(totalLab)
        totalLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(12)
        }
        
        totalView.addSubview(totalNum)
        totalNum.snp.makeConstraints {
            $0.bottom.equalTo(totalLab.snp.bottom).offset(1)
            $0.left.equalTo(totalLab.snp.right).offset(5)
        }
        
        view.addSubview(classifyBut)
        classifyBut.snp.makeConstraints {
            $0.left.right.height.equalTo(filtrateView)
            $0.right.equalTo(totalView.snp.left).offset(-10)
            $0.top.equalTo(filtrateView.snp.bottom).offset(10)
        }
        
        
        classifyBut.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }
        
        classifyBut.addSubview(classifyLab)
        classifyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-18)

        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(classifyBut.snp.bottom).offset(15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
        
        classifyBut.addTarget(self, action: #selector(clickClassifyAction), for: .touchUpInside)
        
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
    }
    
    
    
    @objc private func clickClassifyAction() {
        classifyAlert.appearAction()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 2 {
            return 0
        }
        if section == 0 {
            return dishArr.count
        }
        if section == 1 {
            return 0
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
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            if self.dataType != "1" {
//                let nextVC = DishChartController()
//                nextVC.type = dataType
//                nextVC.dateStr = self.dateStr
//                nextVC.endDateStr = self.endDateStr
//                nextVC.dishModel = dishArr[indexPath.row]
//                self.navigationController?.pushViewController(nextVC, animated: true)
//            }
//        }
//    }
}

extension MenuItemsController {
    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
       
        HTTPTOOl.getStaticClassifyDishesSales(id: selectClassifyID, type: dataType, start: dateStr, end: endDateStr).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [DishModel] = []
            for jsonData in json["data"]["dishesList"].arrayValue {
                let model = DishModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            dishArr = tArr
            
            if dishArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            
            table.reloadData()
            table.mj_header?.endRefreshing()
            totalNum.text = json["data"]["totalNum"].stringValue == "" ? "0" : json["data"]["totalNum"].stringValue
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
            totalNum.text = "0"
        }).disposed(by: self.bag)
        
    }
    
    
    
    private func updateData_Net()  {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getStaticClassifyDishesSales(id: selectClassifyID, type: dataType, start: dateStr, end: endDateStr).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            var tArr: [DishModel] = []
            for jsonData in json["data"]["dishesList"].arrayValue {
                let model = DishModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            self.dishArr = tArr
            
            if dishArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }

            self.table.mj_header?.endRefreshing()
            self.table.reloadData()
            totalNum.text = json["data"]["totalNum"].stringValue == "" ? "0" : json["data"]["totalNum"].stringValue
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
            totalNum.text = "0"
        }).disposed(by: self.bag)
    }
    
}
