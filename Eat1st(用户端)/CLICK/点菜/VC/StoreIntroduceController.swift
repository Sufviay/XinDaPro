//
//  StoreIntroduceController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class StoreIntroduceController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var storeInfoModel = StoreInfoModel()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .black.withAlphaComponent(0.4)
        but.layer.cornerRadius = 20
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        return but
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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

        tableView.register(StoreIntroduceHeaderCell.self, forCellReuseIdentifier: "StoreIntroduceHeaderCell")
        tableView.register(StoreIntroduceAddressCell.self, forCellReuseIdentifier: "StoreIntroduceAddressCell")
        tableView.register(StoreLabCell.self, forCellReuseIdentifier: "StoreLabCell")
        tableView.register(WeekNameCell.self, forCellReuseIdentifier: "WeekNameCell")
        tableView.register(TimeSetInfoCell.self, forCellReuseIdentifier: "TimeSetInfoCell")
        return tableView
    }()
    
    
    override func setViews() {
        self.naviBar.isHidden = true
        setUpUI()
    }
    
    private func setUpUI() {
        
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension StoreIntroduceController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 + 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 || section == 0 {
            return 1
        } else {
            return storeInfoModel.storeOpenTime[section - 3].timeArr.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            let h1 = storeInfoModel.tags.getTextHeigh(SFONT(13), S_W - 40)
            let h2 = storeInfoModel.des.getTextHeigh(SFONT(14), S_W - 40)
            
            return  360 + h1 + h2
        }
        else if indexPath.section == 1 {
            
            let h = storeInfoModel.storeAddress.getTextHeigh(SFONT(14), S_W - 125) < 30 ? 30 : storeInfoModel.storeAddress.getTextHeigh(SFONT(14), S_W - 125)
            return h + 30
        }
        
        else if indexPath.section == 2 {
            return 40
        }
        
        else  {
            if indexPath.row == 0 {
                return 30
            } else {
                return 95
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "StoreIntroduceHeaderCell") as! StoreIntroduceHeaderCell
            cell.setCellData(model: self.storeInfoModel)
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = table.dequeueReusableCell(withIdentifier: "StoreIntroduceAddressCell") as! StoreIntroduceAddressCell
            cell.setCellData(model: storeInfoModel)
            
            return cell
        }
        else if indexPath.section == 2 {
            let cell = table.dequeueReusableCell(withIdentifier: "StoreLabCell") as! StoreLabCell
            return cell
        }
        
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeekNameCell") as! WeekNameCell
                cell.setCellData(model: storeInfoModel.storeOpenTime[indexPath.section - 3])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSetInfoCell") as! TimeSetInfoCell
                cell.setCellData(model: storeInfoModel.storeOpenTime[indexPath.section - 3].timeArr[indexPath.row - 1])
                return cell
            }
        }
    }
}
