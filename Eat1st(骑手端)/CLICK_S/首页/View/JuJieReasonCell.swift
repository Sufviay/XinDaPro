//
//  JuJieReasonCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/10.
//

import UIKit

class JuJieReasonCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    var selectBlock: VoidBlock?

    
    private var dataArr: [UnsuccessfulReasonModel] = []
    
    private var selectIdx: Int = 100
    
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
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ReasonOptionCell.self, forCellReuseIdentifier: "ReasonOptionCell")
        //tableView.layer.cornerRadius = 10
        return tableView
    }()


    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let h = dataArr[indexPath.row].name.getTextHeigh(SFONT(14), S_W - 70)
        return h + 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonOptionCell") as! ReasonOptionCell
        let select = selectIdx == indexPath.row ? true : false
        cell.setCellData(str: dataArr[indexPath.row].name, selected: select)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectIdx == indexPath.row {
            selectIdx = 100
        } else {
            selectIdx = indexPath.row
        }
        selectBlock?(selectIdx)
    }
    
    
    func setCellData(dataArr: [UnsuccessfulReasonModel], selectIdx: Int) {
        self.dataArr = dataArr
        self.selectIdx = selectIdx
        self.table.reloadData()
    }
    
}
