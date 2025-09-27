//
//  OrderStatusAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/7/20.
//

import UIKit

class OrderStatusAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    private var typeArr: [TypeModel] = []
    
    var selectBlock: VoidBlock?
    
    private var selectIdx: Int = 100
        
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = true
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        return tableView
    }()

    
    override func setViews() {
        
        
        let model1 = TypeModel(id: "", name: "All".local)
        let model2 = TypeModel(id: "1", name: "待支付".local)
        let model3 = TypeModel(id: "2", name: "支付中".local)
        let model4 = TypeModel(id: "3", name: "支付失敗".local)
        let model5 = TypeModel(id: "4", name: "用戶取消".local)
        let model6 = TypeModel(id: "5", name: "商家取消".local)
        let model7 = TypeModel(id: "6", name: "系统取消".local)
        let model8 = TypeModel(id: "7", name: "商家拒絕".local)
        let model9 = TypeModel(id: "8", name: "支付成功".local)
        let model10 = TypeModel(id: "9", name: "已接單".local)
        let model11 = TypeModel(id: "10", name: "已出餐".local)
        let model12 = TypeModel(id: "11", name: "已派單".local)
        let model13 = TypeModel(id: "12", name: "配送中".local)
        let model14 = TypeModel(id: "13", name: "已完成".local)
        
        typeArr = [model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14]
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 360))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    override func appearAction() {
        super.appearAction()
    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        cell.tlab.textAlignment = .left
        let isSelect = indexPath.row == selectIdx ? true : false
        cell.setCellData(str: typeArr[indexPath.row].name, isSelect: isSelect)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectBlock?(typeArr[indexPath.row])
        disAppearAction()
    }

}
