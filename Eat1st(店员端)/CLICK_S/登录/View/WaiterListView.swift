//
//  WaiterListView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/6/5.
//

import UIKit
import SwiftyJSON



class WaiterModel: NSObject {
    ///账号[...]
    var account: String = ""
    /// 姓名[...]
    var name: String = ""
    
    func updateModel(json: JSON) {
        account = json["account"].stringValue
        name = json["name"].stringValue
    }
}


class WaiterListView: UIView, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {

    
    var dataArr: [WaiterModel] = []

    var selectBlock: VoidStringBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        return tableView
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置背景透明 不影响子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 250, height: 500))
        }

        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
        cell.setCellData(title: dataArr[indexPath.row].account)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        selectBlock?(model.account)
        disAppearAction()
    }

    
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        
        self.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        removeFromSuperview()
    }

}
