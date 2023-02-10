//
//  SetTimeBusyTimeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/9.
//

import UIKit

class SetTimeBusyTimeCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    private var dataArr: [BusyTimeModel] = []
    
    var selectBlock: VoidBlock?
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(20), .left)
        lab.text = "The current store is too busy"
        return lab
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
        tableView.register(BusyTimeSelectCell.self, forCellReuseIdentifier: "BusyTimeSelectCell")
        return tableView
    }()
    
    
    private let b_line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalTo(line.snp.top).offset(-5)
        }
        
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
        }
        
        
        contentView.addSubview(b_line)
        b_line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
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



class BusyTimeSelectCell: BaseTableViewCell {
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_sel")
        return img
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "60 minutes later"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(10)
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(45)
        }
    }
    
    
    func setCellData(model: BusyTimeModel) {
        self.tlab.text = model.busyName
        
        if model.isSelect {
            self.selectImg.image = LOIMG("busy_sel_b")
        } else {
            self.selectImg.image = LOIMG("busy_unsel_b")
        }

    }
    
    
}
