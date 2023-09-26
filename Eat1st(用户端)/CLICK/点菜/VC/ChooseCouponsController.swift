//
//  ChooseCouponsController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/27.
//

import UIKit

//class ChooseCouponsController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
//
//
//
//    private lazy var mainTable: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .clear
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.bounces = true
////
////        tableView.register(OrderSelectTagCell.self, forCellReuseIdentifier: "OrderSelectTagCell")
//
//        return tableView
//    }()
//
//
//    private let sureBut: UIButton = {
//        let but = UIButton()
//        but.setCommentStyle(.zero, "Apply", .white, SFONT(14), MAINCOLOR)
//        but.layer.cornerRadius = 45 / 2
//        return but
//    }()
//
//
//
//
//    override func setViews() {
//
//    }
//
//    override func setNavi() {
//        self.naviBar.headerTitle = "Voucher"
//        self.naviBar.leftImg = LOIMG("nav-back")
//        self.naviBar.rightBut.isHidden = true
//    }
//
//
//
//
//
//    func setUpUI() {
//
//        view.backgroundColor = HCOLOR("#F7F7F7")
//
//    }
//
//
//}
//
//
//extension ChooseCouponsController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        return cell
//    }
//
//}
