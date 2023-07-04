//
//  SaturdayController3.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/24.
//

import UIKit

class SaturdayController3: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var code: String = "" {
        didSet {
            self.idx = dataModel.nameList.firstIndex(of: code) ?? 0
        }
    }

    
     private var idx: Int = 0 {
        didSet {
            self.headView.curStep = idx
            if idx == 0 {
                lastBut.isHidden = true
                leftBut.isHidden = true
            }
        }
    }

    private var s_A: String = ""
    private var s_B: String = ""
    private var s_C: String = ""


    private let name1Arr = ["Supplier A(£)", "Supplier B(£)", "Supplier C(£)"]
    private let name2Arr = ["供貨商A", "供貨商B", "供貨商C"]

    private lazy var headView: HeaderInfoView = {
        let view = HeaderInfoView()
        view.dataModel = dataModel
        return view
    }()

    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "Saturday information"
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
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo((S_W - 55) / 2)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.height.equalTo(50)
        }
        
        view.addSubview(lastBut)
        lastBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo((S_W - 55) / 2)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.height.equalTo(50)
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

        if s_A != "" && s_B != "" && s_C != "" {

            self.dataModel.supplierList = [["name": "SupplierA", "amount": s_A], ["name": "SupplierB", "amount": s_B], ["name": "SupplierC", "amount": s_C]]
            
            if dataModel.dayList.count == 0 {
                //进入cash in
                let nextVC = CashInController()
                nextVC.dataModel = dataModel
                nextVC.code = dataModel.nameList[idx + 1]
                self.navigationController?.pushViewController(nextVC, animated: false)
            } else {
                //进入平台填写页面
                let nextVC = JustEatsController()
                nextVC.dataModel = dataModel
                nextVC.code = dataModel.nameList[idx + 1]
                self.navigationController?.pushViewController(nextVC, animated: false)
            }
        }
    }



    deinit {
        print("\(self.classForCoder) 销毁")
    }

}


extension SaturdayController3 {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataInPutCell_H") as! DataInPutCell_H

        var content: String = ""
        if indexPath.row == 0 {
            content = s_A
        }
        if indexPath.row == 1 {
            content = s_B
        }
        if indexPath.row == 2 {
            content = s_C
        }
        cell.setCellData(name1: name1Arr[indexPath.row], name2: name2Arr[indexPath.row], content: content)

        cell.editeEndBlock = { [unowned self] (msg) in
            if indexPath.row == 0 {
                self.s_A = msg
            }
            if indexPath.row == 1 {
                self.s_B = msg

            }
            if indexPath.row == 2 {
                self.s_C = msg
            }
        }

        return cell
    }



}


