//
//  TimeListAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/6.
//

import UIKit
import RxSwift

class TimeListAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    ///1外卖 2小超市
    var stroreKind: String = ""

    private let bag = DisposeBag()
    
    var clickTimeBlock: VoidBlock?
    
    var timeArr: [String] = []
    
    var storeID: String = ""
    //1 外卖 2 自取
    var type: String = ""

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
            $0.size.equalTo(CGSize(width: 200, height: 300))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    override func appearAction() {
        PJCUtil.getWindowView().addSubview(self)
        
        if stroreKind != "2" {
            loadData_Net()
        }

    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    func setTimeArr(arr: [String]) {
        timeArr = arr
        table.reloadData()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getChooseTimeList(storeID: storeID, type: type).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.backView)
            
            var tArr: [String] = []
            for jsonData in json["data"].arrayValue {
                tArr.append(jsonData["deliveryTime"].stringValue)
            }
            
            self.timeArr = tArr
            self.table.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        cell.tlab.text = timeArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickTimeBlock?(timeArr[indexPath.row])
        self.disAppearAction()
    }
}


class TextCell: BaseTableViewCell {

    let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
