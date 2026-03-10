//
//  OutController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/6/13.
//

import UIKit

class OutController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var submitData = SubmitModel()
    
    var name: String = "" {
        didSet {
            self.nameLab.text = name
        }
    }

    
    private let headView: HeaderInfoView = {
        let view = HeaderInfoView()
        view.curStep = 1
        return view
    }()
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "Just Eat"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()
    
    
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DataInPutCell_S.self, forCellReuseIdentifier: "DataInPutCell_S")

        return tableView
    }()
    

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)

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
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(headView.snp.bottom).offset(25)
            $0.size.equalTo(CGSize(width: 6, height: 13))
        }
        
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(line.snp.right).offset(10)
            $0.centerY.equalTo(line)
        }
        

                
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(nextBut.snp.top).offset(-10)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }
        
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.nextBut.addTarget(self, action: #selector(clickNextAction), for: .touchUpInside)
        
    }
    
    
    
    @objc private func clickNextAction() {
        
        
        let nextVC = OutController()
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
//        if dataModel.otherIn != "" && dataModel.dayIn != "" {
//            let nextVC = dataInputControllers[idx]
//            nextVC.dataModel = dataModel
//            self.navigationController?.pushViewController(nextVC, animated: false)
//        }
    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
        
    }

    
    deinit {
        print("\(self.classForCoder) 销毁")
    }
    

}


extension OutController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataInPutCell_S") as! DataInPutCell_S
        //cell.setCellData(code: "UO190", b: "", c: "", tt: "")
        
//        var content: String = ""
//        if indexPath.row == 0 {
//            content = orders
//        }
//        if indexPath.row == 1 {
//            content = card
//        }
//        if indexPath.row == 2 {
//            content = cash
//        }
//        if indexPath.row == 3 {
//            content = total
//        }
//        cell.setCellData(name1: nameArr[indexPath.row], content: "")
        
//        cell.editeEndBlock = { [unowned self] (msg) in
//            if indexPath.row == 0 {
//                self.orders = msg
//            }
//            if indexPath.row == 1 {
//                self.card = msg
//                self.countTotal()
//
//            }
//            if indexPath.row == 2 {
//                self.cash = msg
//                self.countTotal()
//            }
//            if indexPath.row == 3 {
//                self.total = msg
//            }
            
 //       }
        
        return cell
    }
    
    
//    private func countTotal() {
//        if card != "" && cash != "" {
//            let to = (Double(cash) ?? 0) + (Double(card) ?? 0)
//            total = D_2_STR(to)
//            self.table.reloadData()
//        }
//    }
    
}



