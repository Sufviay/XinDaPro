//
//  StoreTimeSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit
import RxSwift
import MJRefresh

class StoreTimeSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {


    private let bag = DisposeBag()

    
    //时间
    private var timeModel = OpenHoursModel()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_4, .left)
        lab.text = "Opening time".local
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        img.image = GRADIENTCOLOR(HCOLOR("#28B1FF"), HCOLOR("#2B8AFF"), CGSize(width: 70, height: 3))
        return img
    }()
    
    
    private let setBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "SET >".local, MAINCOLOR, TIT_5, .clear)
        return but
    }()

    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
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
                
        tableView.register(WeekNameCell.self, forCellReuseIdentifier: "WeekNameCell")
        tableView.register(TimeSetInfoCell.self, forCellReuseIdentifier: "TimeSetInfoCell")
        
        return tableView
        
    }()
    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
    }
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Opening hours".local
        loadData_Net()
    }
    
    
    private func setUpUI() {
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titLab.snp.bottom).offset(5)
            $0.size.equalTo(CGSize(width: 70, height: 3))
        }
        
        backView.addSubview(setBut)
        setBut.snp.makeConstraints {
            $0.centerY.equalTo(titLab)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 70, height: 40))
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        self.setBut.addTarget(self, action: #selector(clickSetAction), for: .touchUpInside)
    }
    
    
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSetAction() {
        //设置
        let nextVC = StoreTimeListController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    //MARK: - 网络请求
    private func loadData_Net(_ isLoading: Bool = false) {
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        HTTPTOOl.getStoreOpeningHours().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            self.timeModel.updateModel(json: json["data"])
            
            self.table.reloadData()
            table.mj_header?.endRefreshing()
        
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    

}

extension StoreTimeSettingController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return timeModel.timeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return timeModel.timeList[section].timeArr.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 40
        }

        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekNameCell") as! WeekNameCell
            cell.setCellData(model: timeModel.timeList[indexPath.section])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSetInfoCell") as! TimeSetInfoCell
        cell.setCellData(model: timeModel.timeList[indexPath.section].timeArr[indexPath.row - 1])
        return cell
    }
    
}
