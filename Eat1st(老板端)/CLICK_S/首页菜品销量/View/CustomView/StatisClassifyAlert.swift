//
//  StatisClassifyAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/16.
//

import UIKit
import RxSwift


class StatisClassifyAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource  {

    private let bag = DisposeBag()

    private var dataArr: [F_DishModel] = []
    
    var selectBlock: VoidBlock?
    
    
    //private var selectIdx: Int = 0
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
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
        tableView.bounces = true
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        return tableView
    }()

    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 360))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    override func appearAction() {
        loadData_Net()
        super.appearAction()
    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 50
        } else {
            
            let h = dataArr[indexPath.row - 1].name1.getTextHeigh(BFONT(15), 160) + 30
            return (h > 50 ? h : 50)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        cell.tlab.textAlignment = .left
        //let isSelect = indexPath.row == selectIdx ? true : false
        let tStr: String = indexPath.row == 0 ? "All" : dataArr[indexPath.row - 1].name1
        cell.setCellData(str: tStr, isSelect: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //selectIdx = indexPath.row
        //tableView.reloadData()
        
        
        let id = indexPath.row == 0 ? "" : dataArr[indexPath.row - 1].id
        let name = indexPath.row == 0 ? "All" : dataArr[indexPath.row - 1].name1
        let info = ["id": id, "name": name]
        selectBlock?(info)
        disAppearAction()
    }
//    
//    func setData(classifyArr: [F_DishModel]) {
//        dataArr = classifyArr
//        table.reloadData()
//    }
    
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getStaticClassifyList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            var tarr: [F_DishModel] = []
            for jsonData in json["data"].arrayValue {
                let model = F_DishModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
            dataArr = tarr
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
}


