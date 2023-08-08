//
//  JustEatsController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/22.
//

import UIKit

class JustEatsController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    private var idx: Int = 0 {
        didSet {
            self.headView.curStep = idx
            if idx == 0 {
                lastBut.isHidden = true
                leftBut.isHidden = true
            }
        }
    }
    
    var code: String = "" {
        didSet {
            self.nameLab.text = code
            self.idx = dataModel.nameList.firstIndex(of: code) ?? 0
            self.ptModel = (dataModel.dayList.filter { $0.name == code }).first ?? PingTaiModel()
            
        }
    }
    
    private var ptModel = PingTaiModel()
    
    private let name1Arr = ["Orders", "Card(£)", "Cash(£)", "Total(£)"]
    private let name2Arr = ["訂單數", "卡支付", "現金支付", "合計"]
    
    private lazy var headView: HeaderInfoView = {
        let view = HeaderInfoView()
        view.dataModel = dataModel
        return view
    }()
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "Just Eat"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 1.5
        img.image = GRADIENTCOLOR(HCOLOR("#FF8E12"), HCOLOR("#FFC65E"), CGSize(width: 45, height: 3))
        return img
    }()
    
        
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DataInPutCell_H.self, forCellReuseIdentifier: "DataInPutCell_H")

        return tableView
    }()

    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func setViews() {
        setUpUI()
    }
    
    
    private func setUpUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(85)
            $0.top.equalTo(headImg.snp.bottom).offset(-30)
        }
        
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(headView.snp.bottom).offset(25)
        }
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(lastBut.snp.top).offset(-10)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }

        if idx == 0 {
            nextBut.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-40)
                $0.left.equalToSuperview().offset(40)
                $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
                $0.height.equalTo(50)
            }
        } else {
            nextBut.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-20)
                $0.width.equalTo((S_W - 55) / 2)
                $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
                $0.height.equalTo(50)
            }

        }
    }
    
    
    
    override func nextAction() {
        
        if ptModel.orders != "" && ptModel.card != "" && ptModel.cash != "" && ptModel.total != "" {
            
            let code = dataModel.nameList[idx + 1]
            
//            if code == "Cash In" {
//                let nextVC = CashInController()
            if code == "Cash Out" {
                let nextVC = CashOutController()
                nextVC.dataModel = dataModel
                nextVC.code = code
                self.navigationController?.pushViewController(nextVC, animated: false)
            } else {
                let nextVC = JustEatsController()
                nextVC.dataModel = dataModel
                nextVC.code = code
                self.navigationController?.pushViewController(nextVC, animated: false)
            }
        }
    }
    

    
    deinit {
        print("\(self.classForCoder) 销毁")
    }
    
}


extension JustEatsController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataInPutCell_H") as! DataInPutCell_H
        
        var content: String = ""
        if indexPath.row == 0 {
            content = ptModel.orders
        }
        if indexPath.row == 1 {
            content = ptModel.card
        }
        if indexPath.row == 2 {
            content = ptModel.cash
        }
        if indexPath.row == 3 {
            content = ptModel.total
        }
        cell.setCellData(name1: name1Arr[indexPath.row], name2: name2Arr[indexPath.row], content: content)
        
        cell.editeEndBlock = { [unowned self] (msg) in
            if indexPath.row == 0 {
                self.ptModel.orders = msg
            }
            if indexPath.row == 1 {
                self.ptModel.card = msg
                self.countTotal()
                
            }
            if indexPath.row == 2 {
                self.ptModel.cash = msg
                self.countTotal()
            }
            if indexPath.row == 3 {
                self.ptModel.total = msg
            }
            
        }
        
        return cell
    }
    
    
    private func countTotal() {
        if ptModel.card != "" && ptModel.cash != "" {
            let to = (Double(ptModel.cash) ?? 0) + (Double(ptModel.card) ?? 0)
            ptModel.total = D_2_STR(to)
            self.table.reloadData()
        }
    }
    
}


