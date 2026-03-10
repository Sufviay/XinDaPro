//
//  InController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/6/13.
//

import UIKit

class InController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    var submitData = SubmitModel()
    
    private var idx: Int = 0 {
        didSet {
            self.headView.curStep = idx
        }
    }
    
    var name: String = "" {
        didSet {
            self.nameLab.text = name
            self.idx = submitData.nameList.firstIndex(of: name) ?? 0
            self.inModel = submitData.inList[idx]
            
        }
    }
    
    ///当前页面的数据模型
    private var inModel = InModel()
    
//    private var orders: String = ""
//    private var card: String = ""
//    private var cash: String = ""
//    private var total: String = ""
    
    
    private let nameArr = ["o", "b", "b1", "b2", "c", "TT"]
    
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
        
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.height.equalTo(50)
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
        
        if inModel.o != "" && inModel.b != "" && inModel.b1 != "" && inModel.b2 != "" && inModel.c != "" {
            let nextVC = InController()
            nextVC.submitData = submitData
            nextVC.name = submitData.nameList[idx + 1]
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
        
    }

    
    deinit {
        print("\(self.classForCoder) 销毁")
    }
    
}


extension InController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataInPutCell_H") as! DataInPutCell_H
        
        var content: String = ""
        if indexPath.row == 0 {
            content = inModel.o
        }
        if indexPath.row == 1 {
            content = inModel.b
        }
        if indexPath.row == 2 {
            content = inModel.b1
        }
        if indexPath.row == 3 {
            content = inModel.b2
        }
        if indexPath.row == 4 {
            content = inModel.c
        }
        if indexPath.row == 5 {
            content = inModel.tt
        }
        cell.setCellData(name1: nameArr[indexPath.row], name2: "", content: content)
        
        cell.editeEndBlock = { [unowned self] (msg) in
            if indexPath.row == 0 {
                self.inModel.o = msg
            }
            if indexPath.row == 1 {
                self.inModel.b = msg
                self.countTotal()
            }
            if indexPath.row == 2 {
                self.inModel.b1 = msg
                self.countTotal()
            }
            if indexPath.row == 3 {
                self.inModel.b2 = msg
            }
            if indexPath.row == 4 {
                self.inModel.c = msg
            }
            
            if indexPath.row == 5 {
                inModel.tt = msg
            }
            
        }
        
        return cell
    }
    
    
    private func countTotal() {
        
        ///b = b1 + b2
        ///tt = b + c
        
        ///b发生改变 就清空b1+ b2
        
        
        ///输入b的时候
        if inModel.b1 != "" && inModel.b2 != "" {
            //清空吧b1和b2
            inModel.b1 = ""
            inModel.b2 = ""
            
            if inModel.c != "" {
                let tt = (Double(inModel.b) ?? 0) + (Double(inModel.c) ?? 0)
                inModel.tt = D_2_STR(tt)
            }
            self.table.reloadData()
            return
            
        }
        
        if inModel.b1 != "" && inModel.b2 == "" {
            //如果输入的b < b1 无效的输入 清空b
            if (Double(inModel.b) ?? 0) < (Double(inModel.b1) ?? 0) {
                inModel.b = ""
                inModel.tt = ""
                self.table.reloadData()
                return
            } else {
                //反之 可计算出b2
                let b2 = (Double(inModel.b) ?? 0) - (Double(inModel.b1) ?? 0)
                if inModel.c != "" {
                    let tt = (Double(inModel.b) ?? 0) + (Double(inModel.c) ?? 0)
                    inModel.tt = D_2_STR(tt)
                }
                self.table.reloadData()
            }
        }
        
        
        if inModel.b1 == "" && inModel.b2 != "" {
            //如果输入的b < b2 无效的输入 清空b
            if (Double(inModel.b) ?? 0) < (Double(inModel.b2) ?? 0) {
                inModel.b = ""
                inModel.tt = ""
                self.table.reloadData()
                return
            } else {
                //反之 可计算出b1
                let b1 = (Double(inModel.b) ?? 0) - (Double(inModel.b2) ?? 0)
                if inModel.c != "" {
                    let tt = (Double(inModel.b) ?? 0) + (Double(inModel.c) ?? 0)
                    inModel.tt = D_2_STR(tt)
                }
                self.table.reloadData()
            }
        }
        
        
        
        
        ///输入b1时
        if inModel.b != "" && inModel.b2 != "" {
            
        }
        
        
        
        ///输入b2时
        
        
        
        
//        if inModel.b != "" && inModel.b1 != "" {
//            //b2 = b - b1
//            
//            if
//            
//            let b2 = (Double(inModel.b) ?? 0) - (Double(inModel.b1) ?? 0)
//        }
//        
//        
//        
//        if card != "" && cash != "" {
//            let to = (Double(cash) ?? 0) + (Double(card) ?? 0)
//            total = D_2_STR(to)
//            self.table.reloadData()
//        }
    }
    
}


