//
//  SelectTypeAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/7/19.
//

import UIKit


class PayTypeAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    

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
        let model3 = TypeModel(id: "1", name: "Cash")
        let model4 = TypeModel(id: "2", name: "Card")
        let model5 = TypeModel(id: "3", name: "Pos")
        let model6 = TypeModel(id: "4", name: "Cash&Pos")
        let model7 = TypeModel(id: "5", name: "WX")
        let model8 = TypeModel(id: "6", name: "Wallet Spent")
        
        typeArr = [model1, model3, model4, model5, model6, model7, model8]
        
        
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
