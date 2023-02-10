//
//  PSFeeDesAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/21.
//

import UIKit

class PSFeeDesAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

   
    var feeListArr: [JTFeeModel] = [] {
        didSet {
            
            orderMoneyList.removeAll()
            feeMoneyList.removeAll()
            
            for model in feeListArr {
                self.feeMoneyList.append("£\(model.fee) delivery fee")
                
                self.orderMoneyList.append("\(model.grade) mile")
            }
            self.table.reloadData()
        }
    }
    
    private var orderMoneyList: [String] = []

    private var feeMoneyList: [String] = []
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 65 / 2
        return view
    }()
    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("ps_pic")
        return img
    }()
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Determine", FONTCOLOR, BFONT(15), .clear)
        return but
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

        tableView.register(FeeListCell.self, forCellReuseIdentifier: "FeeListCell")
        
        return tableView
    }()
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 270, height: 200))
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-44)
        }
        
        backView.addSubview(headView)
        headView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 65))
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backView.snp.top)
        }
        
        headView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 38, height: 30))
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(headView.snp.bottom).offset(0)
            $0.bottom.equalTo(line.snp.top).offset(-10)
        }
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(line.snp.bottom)
        }
    
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        
    }
    
    @objc func clickCloseAction() {
        self.disAppearAction()
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
    
    
    @objc private func clickSureAction() {
        disAppearAction()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeeListCell") as! FeeListCell
        cell.setCellData(feeStr: feeMoneyList[indexPath.row], orderStr: orderMoneyList[indexPath.row])
        return cell
    }

}

class FeeListCell: BaseTableViewCell {
    
    private let orderPriceLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        return lab
    }()
    
    private let feeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .right)
        return lab
    }()

    
    override func setViews() {

        contentView.addSubview(orderPriceLab)
        orderPriceLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(feeLab)
        feeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setCellData(feeStr: String, orderStr: String) {
        orderPriceLab.text = orderStr
        feeLab.text = feeStr
    }
    
}
