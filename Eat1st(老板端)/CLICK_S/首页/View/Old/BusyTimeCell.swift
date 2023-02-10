//
//  BusyTimeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/2/18.
//

import UIKit

class BusyTimeCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {


    private var dataArr: [BusyTimeModel] = []
    
    var selectBlock: VoidBlock?
    
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
        tableView.register(BusyTimeSelectCell.self, forCellReuseIdentifier: "BusyTimeSelectCell")
        return tableView
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.text = "The current store is too busy"
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3

        
        return view
    }()

    override func setViews() {
        
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.5)
            $0.top.equalToSuperview().offset(45)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(55)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    
    //MARK: - delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusyTimeSelectCell") as! BusyTimeSelectCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        if !model.isSelect {
            self.selectBlock?(model.busyID)
        }
    }
    
    
    func setCellData(modelArr: [BusyTimeModel]) {
        self.dataArr = modelArr
        self.table.reloadData()
    }

}

