//
//  SystemSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/15.
//

import UIKit

class SystemSettingController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {


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
        self.biaoTiLab.text = "System settings".local
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingOptionCell") as! SettingOptionCell
        
        if indexPath.row == 0 {
            cell.setCellData(imgStr: "language", titStr: "Change language".local, msgStr: "")
        }
        if indexPath.row == 1 {
            cell.setCellData(imgStr: "password", titStr: "Change password".local, msgStr: "")
        }
        if indexPath.row == 2 {
            cell.setCellData(imgStr: "pageset", titStr: "Home setting".local, msgStr: "")
        }
        if indexPath.row == 3 {
            cell.setCellData(imgStr: "fontsize", titStr: "Font size".local, msgStr: "")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //切換語言
            lanAlert.appearAction()
        }
        
        if indexPath.row == 1 {
            //修改密碼
            let cpVC = ChangePasswordController()
            navigationController?.pushViewController(cpVC, animated: true)
        }
        
        if indexPath.row == 2 {
            //修改首頁數據顯示
            let syVC = ChangFirstPageShowController()
            navigationController?.pushViewController(syVC, animated: true)
        }
        
        if indexPath.row == 3 {
            //修改字体大小
            fontAlert.appearAction()
        }
    }
    
}




class SettingOptionCell: BaseTableViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("set_next")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        return lab
    }()
    
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    private let messageLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .right)
        lab.text = "30 days"
        return lab
    }()
    
    
    override func setViews() {
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(messageLab)
        messageLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(nextImg.snp.left).offset(-15)
        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        
    }
    
    
    func setCellData(imgStr: String, titStr: String, msgStr: String) {
        sImg.image = LOIMG(imgStr)
        titLab.text = titStr
        messageLab.text = msgStr
    }
    
}
