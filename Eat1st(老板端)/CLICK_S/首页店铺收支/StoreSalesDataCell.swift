//
//  StoreSalesDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/12/31.
//

import UIKit

class StoreSalesDataCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    private var dataModel = StoreSummaryModel()

    private let backView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        
        view.layer.shadowColor = HCOLOR("#252275").withAlphaComponent(0.3).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 5
        
        
        return view
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
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
        tableView.register(SaleContentCell.self, forCellReuseIdentifier: "SaleContentCell")
        return tableView
    }()

    
    
    override func setViews() {
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.titStrArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaleContentCell") as! SaleContentCell
        cell.setCellData(l_str: dataModel.titStrArr[indexPath.row], m_str: dataModel.numberArr[indexPath.row], r_str: dataModel.priceArr[indexPath.row])
        return cell
    }
    
    func setCellData(model: StoreSummaryModel) {
        dataModel = model
        table.reloadData()
    }
    
}


class SaleContentCell: BaseTableViewCell {
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#AAAAAA")
        return view
    }()
    
    private let l_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "Sales"
        return lab
    }()
    
    private let m_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(14), .center)
        lab.text = "Total"
        return lab
    }()
    
    private let r_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(14), .right)
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "Amount"
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(l_lab)
        l_lab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(r_lab)
        r_lab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.width.equalTo((S_W - 50) / 3)
        }
        
        contentView.addSubview(m_lab)
        m_lab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    func setCellData(l_str: String, m_str: String, r_str: String) {
        l_lab.text = l_str
        m_lab.text = m_str
        r_lab.text = r_str
        
        if l_str == "Type" {
            l_lab.textColor = FONTCOLOR
            l_lab.font = BFONT(17)
            
            m_lab.textColor = FONTCOLOR
            m_lab.font = BFONT(17)
            
            r_lab.textColor = FONTCOLOR
            r_lab.font = BFONT(17)
        } else {
            l_lab.textColor = HCOLOR("#666666")
            l_lab.font = BFONT(15)
            
            m_lab.textColor = .black
            m_lab.font = BFONT(15)
            
            r_lab.textColor = .black
            r_lab.font = BFONT(15)
        }
        
        
        if l_str == "Type" || l_str == "Revenue" || l_str == "Top up(R)" || l_str == "Cash On Hand" {
            line.isHidden = false
        } else {
            line.isHidden = true
        }
        
    }
}
