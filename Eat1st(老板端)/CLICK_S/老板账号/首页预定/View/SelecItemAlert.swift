//
//  SelecItemAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit

class SelecItemAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var selectBlock: VoidBlock?
    
    private var selectType: String = "num"
    private var strArr: [String] = []
    
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
    
    
    
    func setNumData() {
        strArr = ["1",  "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        selectType = "num"
        table.reloadData()
    }
    

    func setDateData(dateList: [String]) {
        strArr = dateList
        selectType = "date"
        table.reloadData()
    }
    
    
    func setTableData(tableList: [TableModel]) {
        strArr.removeAll()
        for model in tableList {
            strArr.append(model.deskName)
        }
        selectType = "table"
        table.reloadData()
    }
    
    
    func setDateModelData(dateList: [DateModel]) {
        strArr.removeAll()
        for model in dateList {
            strArr.append(model.yearDate)
        }
        table.reloadData()
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
        return strArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        cell.tlab.text = strArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = ["type": selectType, "idx": indexPath.row] as [String : Any]
        selectBlock?(dic)
        self.disAppearAction()
    }

}
