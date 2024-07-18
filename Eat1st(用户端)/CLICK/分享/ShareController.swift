//
//  ShareController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/6.
//

import UIKit
import RxSwift
import MJRefresh



class ShareController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    private var dataArr: [ShareRecordModel] = []
    
    ///分页
    private var page: Int = 1

    ///分享URL
    private var shareUrl: String = ""
    
    private var sectionNum: Int = 0
    
    
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
        tableView.bounces = true
        tableView.register(ShareNameCell.self, forCellReuseIdentifier: "ShareNameCell")
        tableView.register(ShareLinkCell.self, forCellReuseIdentifier: "ShareLinkCell")
        tableView.register(ShareReferrerHeaderCell.self, forCellReuseIdentifier: "ShareReferrerHeaderCell")
        tableView.register(ShareFooterCell.self, forCellReuseIdentifier: "ShareFooterCell")
        tableView.register(ShareReferrerListCell.self, forCellReuseIdentifier: "ShareReferrerListCell")
        return tableView
    }()
    
    
    override func setNavi() {
        naviBar.headerBackColor = MAINCOLOR
        naviBar.leftImg = LOIMG("nav_back")
        naviBar.rightBut.isHidden = true
        naviBar.headerTitle = "SHARE"
    }
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
        
    }
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }

    
    private func setUpUI() {
        view.backgroundColor = MAINCOLOR
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            loadDataMore_Net()
        }
        

    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if dataArr.count == 0 {
                return 0
            }
        }
        if section == 3 {
            return dataArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        
        if indexPath.section == 1 {
            //40 + 210 + 40 + 20 + 70
            let url_H = shareUrl.getTextHeigh(BFONT(11), S_W - 130)
            return 380 + 30 + url_H
            
        }
        if indexPath.section == 2 {
            return 55
        }
        
        if indexPath.section == 3 {
            return 55
        }
        
        if indexPath.section == 4 {
            return 20
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShareNameCell") as! ShareNameCell
            return cell
        }

        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShareLinkCell") as! ShareLinkCell
            cell.setCellData(url: shareUrl)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShareReferrerHeaderCell") as! ShareReferrerHeaderCell
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShareReferrerListCell") as! ShareReferrerListCell
            cell.setCellData(model: dataArr[indexPath.row])
            return cell
        }
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShareFooterCell") as! ShareFooterCell
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    

    //MARK: - 获取分享ID
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getShareIDAndList(page: 1).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            page = 2
            sectionNum = 5
            shareUrl = SHAREURL(json["data"]["shareId"].stringValue)
            var tarr: [ShareRecordModel] = []
            for jsonData in json["data"]["shareList"].arrayValue {
                let model = ShareRecordModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            dataArr = tarr
            table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getShareIDAndList(page: page).subscribe(onNext: {[unowned self] (json) in
            
            

            if json["data"]["shareList"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"]["shareList"].arrayValue {
                    let model = ShareRecordModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_footer?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
}
