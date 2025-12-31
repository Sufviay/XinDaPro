//
//  PromotionSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/12/17.
//

import UIKit

class PromotionSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
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
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: "SettingOptionCell")
        return tableView
    }()


    private lazy var lanAlert: LanguageAlert = {
        let alert = LanguageAlert()
        return alert
    }()
    
    
    private lazy var fontAlert: FontAlert = {
        let alert = FontAlert()
        return alert
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Promotion Management".local
    }

    
    override func setViews() {
        setUpUI()
    }

    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.bottom.equalToSuperview()
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)

    }
    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingOptionCell") as! SettingOptionCell
        
        if indexPath.row == 0 {
            cell.setCellData(imgStr: "cou", titStr: "Coupon Management".local, msgStr: "")
        }
        if indexPath.row == 1 {
            cell.setCellData(imgStr: "fullgift", titStr: "Order full gift Management".local, msgStr: "")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //优惠券管理
            let couVC = PromotionListController()
            navigationController?.pushViewController(couVC, animated: true)
        }
        
        if indexPath.row == 1 {
            //订单满赠管理
            let giftVC = FullGiftListController()
            navigationController?.pushViewController(giftVC, animated: true)
        }
    }

}
