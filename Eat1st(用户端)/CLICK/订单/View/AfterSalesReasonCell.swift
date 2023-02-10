//
//  AfterSalesReasonCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/6.
//

import UIKit

class AfterSalesReasonCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {


    private var dataArr: [PlaintReasonModel] = []
    private var selecIdx: Int = 10000
    
    var selectBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3

        return view
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = "Refund reason"
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("＊")
        return img
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
        tableView.bounces = false
        
        tableView.register(AfterSalesSelectReasonCell.self, forCellReuseIdentifier: "AfterSalesSelectReasonCell")
        
        return tableView
    }()
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        self.backgroundColor = .white

        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.top.equalTo(titlab).offset(5)
            $0.left.equalTo(titlab.snp.right).offset(2)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let h = dataArr[indexPath.row].reasonName.getTextHeigh(SFONT(14),  S_W - 100)
        return h + 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesSelectReasonCell") as! AfterSalesSelectReasonCell
        let isSel = selecIdx == indexPath.row ? true : false
        cell.setCellData(model: dataArr[indexPath.row], isSelect: isSel)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selecIdx == indexPath.row {
            self.selecIdx = 10000
        } else {
            self.selecIdx = indexPath.row
        }
        table.reloadData()
        self.selectBlock?(selecIdx)
    }
    
    
    func setCellData(dataArr: [PlaintReasonModel], selectIdx: Int) {
        self.dataArr = dataArr
        self.selecIdx = selectIdx
        self.table.reloadData()
    }


}


class AfterSalesSelectReasonCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Dietary Requirements not met "
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("unsel")
        return img
    }()
    
    
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-80)
        }
        
    }
    
    
    func setCellData(model: PlaintReasonModel, isSelect: Bool) {
        self.titlab.text = model.reasonName
        if isSelect {
            self.selectImg.image = LOIMG("sel")
        } else {
            self.selectImg.image = LOIMG("unsel")
        }
    }
    
    
}
