//
//  ChangFirstPageShowController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/24.
//

import UIKit

class ChangFirstPageShowController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    
    private var titleArr: [String] = FirstPageManager.shared.pageDataTitle
    private var titleShow: [Bool] = FirstPageManager.shared.pageDataShow
    
    
    
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
        tableView.setEditing(true, animated: true)
        tableView.register(PageSettingOptionCell.self, forCellReuseIdentifier: "PageSettingOptionCell")
        return tableView
    }()
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Home setting".local
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
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }


        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        //saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func saveAction() {
        //切換英文
        FirstPageManager.shared.pageDataTitle = titleArr
        FirstPageManager.shared.pageDataShow = titleShow
        FirstPageManager.saveFirstPageData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fistPageDataChange"), object: nil)
//        HUD_MB.loading("设置中...".local, onView: view)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
//            HUD_MB.showSuccess("设置成功！".local, onView: view)
//            navigationController?.setViewControllers([BossFirstController()], animated: true)
//        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageSettingOptionCell") as! PageSettingOptionCell
        
        cell.setCellData(titStr: titleArr[indexPath.row], isShow: true)
        
        cell.clickBlock = { [unowned self] (par) in


            let num = (titleShow.filter { $0 }).count
            if num == 1 && !par {
                showSystemAlert("Alert".local, "At least keep one.".local, "OK".local)
            } else {
                titleShow[indexPath.row] = par
                saveAction()
                tableView.reloadData()
            }
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 防止缩进，使整个行可拖动
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //交換數據
        
        
        //插入
        
        let str = titleArr.remove(at: sourceIndexPath.row)
        titleArr.insert(str, at: destinationIndexPath.row)
        
        let show = titleShow.remove(at: sourceIndexPath.row)
        titleShow.insert(show, at: destinationIndexPath.row)
        
        saveAction()
        
        tableView.reloadData()
    }
    
    
    
}
