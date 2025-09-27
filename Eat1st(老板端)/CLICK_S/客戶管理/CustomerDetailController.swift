//
//  CustomerDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/18.
//

import UIKit

class CustomerDetailController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var customerData = UserModel()
    
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
        tableView.register(NameCell.self, forCellReuseIdentifier: "NameCell")
        tableView.register(DishDetailMsgCell.self, forCellReuseIdentifier: "DishDetailMsgCell")
        return tableView
    }()

    private let orderBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "User Order".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Customer Detail".local
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
        
        view.addSubview(orderBut)
        orderBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(orderBut.snp.top).offset(-10)
        }

        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        orderBut.addTarget(self, action: #selector(clickOrderAction), for: .touchUpInside)
    }

    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickOrderAction() {
        let orderVC = OrderListController()
        orderVC.userID = customerData.userId
        navigationController?.pushViewController(orderVC, animated: true)

    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            let h = customerData.nickName.getTextHeigh(TIT_4, S_W - 100) + 40
            return h
        }
        if indexPath.row == 9 {
            let h = customerData.tagStr.getTextHeigh(TIT_4, S_W - 100) + 40
            return h
        }
        return 65
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! NameCell
            cell.nameLab.text = customerData.nickName
            cell.moreBut.isHidden = true
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
        if indexPath.row == 1 {
            cell.setCellData(titStr: "Phone Number".local, msgStr: customerData.phone)
        }
        if indexPath.row == 2 {
            cell.setCellData(titStr: "Email".local, msgStr: customerData.email)
        }
        if indexPath.row == 3 {
            cell.setCellData(titStr: "Latest Order Date".local, msgStr: customerData.lastOrderTime)
        }
        if indexPath.row == 4 {
            cell.setCellData(titStr: "Birthday".local, msgStr: customerData.birthday)
        }
        if indexPath.row == 5 {
            cell.setCellData(titStr: "Postcode".local, msgStr: customerData.postCode)
        }
        if indexPath.row == 6 {
            cell.setCellData(titStr: "Order Quantity".local, msgStr: customerData.orderNum)
        }
        if indexPath.row == 7 {
            cell.setCellData(titStr: "Total Order Amount".local, msgStr: "£\(D_2_STR(customerData.orderAmount))")
        }
        if indexPath.row == 8 {
            cell.setCellData(titStr: "Last Login Time".local, msgStr: customerData.loginTime)
        }
        if indexPath.row == 9 {
            cell.setCellData(titStr: "Customer Tags".local, msgStr: customerData.tagStr)
        }
        if indexPath.row == 10 {
            
            var statusStr = ""
            if customerData.status == "1" {
                //正常
                statusStr = "Normal".local
            }
            if customerData.status == "2" {
                //申請註銷
                statusStr = "Application for cancellation".local
            }
            if customerData.status == "3" {
                //禁用
                statusStr = "Disable".local
            }
            if customerData.status == "4" {
                //平台註銷
                statusStr = "Platform cancellation".local
            }
            if customerData.status == "5" {
                //用戶註銷
                statusStr = "User cancellation".local
            }
            
            cell.setCellData(titStr: "User Status".local, msgStr: statusStr)
        }

        
        return cell
    }
    
}




class NameCell: BaseTableViewCell {
    
    var clickMoreBlock: VoidStringBlock?
    
    let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_4, .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    
    let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()

    
    private lazy var editeAlert: MoreAlert = {
        let alert = MoreAlert()
        
        alert.clickBlock = { [unowned self] (type) in
            clickMoreBlock?(type)
        }
        
        return alert
    }()

    
    override func setViews() {
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-80)
        }
        
        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
    }
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        editeAlert.alertType = .promotion
        editeAlert.tap_H = cret.minY
        self.editeAlert.appearAction()
    }

    
}

