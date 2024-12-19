//
//  StoreSearchController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/29.
//

import UIKit
import RxSwift
import MJRefresh

class StoreSearchController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    private var page: Int = 1
    
    ///数据ModelArr
    private var dataArr: [StoreInfoModel] = []
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let searchImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("search_b")
        return img
    }()
    
    private let searchBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35 / 2
        view.backgroundColor = HCOLOR("#F2F2F2")
        return view
    }()
    
    private let searchBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Search", FONTCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private lazy var searchTF: UITextField = {
        let tf = UITextField()
        tf.setPlaceholder("What do you want to search", color: HCOLOR("#BBBBBB"))
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        return tf
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
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
        tableView.register(StoreTableCell.self, forCellReuseIdentifier: "StoreTableCell")
        return tableView
    }()
    


    override func setViews() {
        
        self.naviBar.isHidden = true
        
        view.backgroundColor =  HCOLOR("F7F7F7")
        
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        
        headView.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-2)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        headView.addSubview(searchBut)
        searchBut.snp.makeConstraints {
            $0.centerY.equalTo(backBut)
            $0.right.equalToSuperview()
            $0.width.equalTo(75)
            $0.height.equalTo(44)
        }
        
        headView.addSubview(searchBackView)
        searchBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-75)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(35)

        }
        
        searchBackView.addSubview(searchImg)
        searchImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)

        }
        
        searchBackView.addSubview(searchTF)
        searchTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
        }
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(headView.snp.bottom).offset(10)
        }


        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }
        
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        searchBut.addTarget(self, action: #selector(clickSearchAction), for: .touchUpInside)
        
        loadData_Net()        
    }
    

    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickSearchAction()  {
        if searchTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter your search content", onView: self.view)
            return
        }
        
        loadData_Net()
    }
      
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SET_H(225, 355) + 105 + 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableCell") as! StoreTableCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = StoreMenuOrderController()
        nextVC.storeID = dataArr[indexPath.row].storeID
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    ///获取店铺列表
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.searchStoreList(keyword: searchTF.text!, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, page: 1).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.page = 2
            var tempArr: [StoreInfoModel] = []
            for jsondata in json["data"].arrayValue {
                let model = StoreInfoModel()
                model.updateModel(json: jsondata)
                tempArr.append(model)
            }
            self.dataArr = tempArr
            
            if self.dataArr.count == 0 {
                self.table.addSubview(self.noDataView)
            } else {
                self.noDataView.removeFromSuperview()
            }
            
            self.table.reloadData()
            
            self.table.mj_header?.endRefreshing()
            self.table.mj_footer?.resetNoMoreData()

            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    private func loadDataMore_Net() {
        HTTPTOOl.searchStoreList(keyword: searchTF.text!, lat: UserDefaults.standard.local_lat!, lng: UserDefaults.standard.local_lng!, page: 1).subscribe(onNext: { (json) in
            
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = StoreInfoModel()
                    model.updateModel(json: jsonData)
                    self.dataArr.append(model)
                }
                self.table.reloadData()
                self.table.mj_footer?.endRefreshing()
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()
        }).disposed(by: bag)
        
    }

    

    
}
