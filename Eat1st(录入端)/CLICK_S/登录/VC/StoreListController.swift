//
//  StoreListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2026/2/12.
//

import UIKit
import RxSwift
import SwiftyJSON

class StoreListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let bag = DisposeBag()
    
    var dataArr: [StoreModel] = []
    
    ///登录信息
    var logininfo: JSON?

    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(StoreInfoCell.self, forCellReuseIdentifier: "StoreInfoCell")
        return tableView
    }()

    
    
    
    override func setNavi() {
        naviBar.headerTitle = "Choose Store"
        naviBar.leftImg = LOIMG("nav_back")
    }
    
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }
    
    override func setViews() {
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(15)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let name = dataArr[indexPath.row].storeName
        let h = name.getTextHeigh(BFONT(14), S_W - 90) + 50
        return h
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell") as! StoreInfoCell
        
        let storeID = dataArr[indexPath.row].storeId
        let storeID_BD = UserDefaults.standard.storeID ?? ""
        let isSel = storeID == storeID_BD ? true : false
        cell.setCellData(name: dataArr[indexPath.row].storeName, isSelect: isSel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        UserDefaults.standard.storeID = model.storeId
        table.reloadData()
        
        //进行登录
        
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getInputDataStatus(date: "").subscribe(onNext: { [unowned self] (json) in
            UserDefaults.standard.userName = json["data"]["storeCode"].stringValue
            
            let model = FeeTypeResultModel.sharedInstance
            model.updateModel(json: json)
            
            if model.dayResultList.count == 0 {
                HUD_MB.showWarnig("There's no reporting date！", onView: self.view)
            } else {
                HUD_MB.showSuccess("Success!", onView: self.view)
                
                let firstDate = model.dayResultList.first!
                
                UserDefaults.standard.stepCount = firstDate.stepCount
                
                let subModel = DayDataModel()
                subModel.date = firstDate.date
                subModel.nameList = firstDate.nameList
                subModel.dayList = model.platTypeList

                
                if firstDate.saturday {
                    //是周六
                    if firstDate.writeDay {
                        // 已完成
                        let completeVC = CompletedController()
                        completeVC.dataModel = subModel
                        self.navigationController?.setViewControllers([completeVC], animated: true)
                    } else {
                        // 未填写

                        let firstVC = SaturdayController1()
                        firstVC.dataModel = subModel
                        firstVC.code = subModel.nameList[0]
                        self.navigationController?.setViewControllers([firstVC], animated: true)
                    }

                } else {
                    //不是周六
                    
                    if firstDate.writeDay {
                        // 已完成
                        let completeVC = CompletedController()
                        completeVC.dataModel = subModel
                        self.navigationController?.setViewControllers([completeVC], animated: true)
                    } else {
                        //未填写
                                    
                        if model.platTypeList.count == 0 {
                            
                            let firstVC = CashOutController()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            self.navigationController?.setViewControllers([firstVC], animated: true)
                        } else {
                            let firstVC = JustEatsController()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            self.navigationController?.setViewControllers([firstVC], animated: true)
                        }
                    }
                }
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)

        
        
    }
    
    
    
    
}



class StoreInfoCell: BaseTableViewCell {


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderColor = MAINCOLOR.cgColor
        return view
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_black")
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(50)
        }
        
    }
    
    func setCellData(name: String, isSelect: Bool) {
        nameLab.text = name
        
        if isSelect {
            backView.layer.borderWidth = 2
        } else {
            backView.layer.borderWidth = 0
        }
    }
    
}
