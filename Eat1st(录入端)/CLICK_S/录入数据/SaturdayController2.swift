//
//  SaturdayController2.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/24.
//

import UIKit

class SaturdayController2: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    
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
        tableView.register(DataInPutCell_S.self, forCellReuseIdentifier: "DataInPutCell_S")
        return tableView
    }()


    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        if idx == 0 {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
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

        if dataModel.wagesBank != "" && dataModel.wagesCash != "" && dataModel.staffFull != "" && dataModel.staffPart != "" {
            let nextVC = SaturdayController3()
            nextVC.dataModel = dataModel
            nextVC.code = dataModel.nameList[idx + 1]
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }


}



extension SaturdayController2 {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DataInPutCell_S") as! DataInPutCell_S
        if indexPath.row == 0 {
            cell.setCellData(name1: "Wages Bank(£)", name2: "銀行過帳工資", content: dataModel.wagesBank)
        }
        if indexPath.row == 1 {
            cell.setCellData(name1: "Wages Cash(£)", name2: "現金工資", content: dataModel.wagesCash)
        }

        if indexPath.row == 2 {
            cell.setCellData(name1: "Staff No.(full)", name2: "全職人數", content: dataModel.staffFull)
        }
        if indexPath.row == 3 {
            cell.setCellData(name1: "staff No.(part)", name2: "兼職人數", content: dataModel.staffPart)
        }

        cell.editeEndBlock = { [unowned self] (msg) in
            if indexPath.row == 0 {
                self.dataModel.wagesBank = msg
            }
            if indexPath.row == 1 {
                self.dataModel.wagesCash = msg
            }
            if indexPath.row == 2 {
                self.dataModel.staffFull = msg
            }
            if indexPath.row == 3 {
                self.dataModel.staffPart = msg
            }
        }

        return cell


    }


}



