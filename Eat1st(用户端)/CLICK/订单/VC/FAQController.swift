//
//  FAQController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/2/21.
//

import UIKit
import RxSwift
import SwiftyJSON

class FAQController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var dataArr: [JSON] = []
    
    var orderID: String = ""
    
    var isHaveAfter: Bool = false
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
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
        tableView.register(ProblemCell.self, forCellReuseIdentifier: "ProblemCell")
        return tableView
    }()
    
    
    override func setViews() {
        
        self.getListData_Net()
        
    }
    
    private func configTable() {
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Help"
        self.naviBar.headerBackColor = .white
        self.naviBar.leftImg = LOIMG("nav_back")
        
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isHaveAfter {
            return self.dataArr.count + 2
        }
        
        return self.dataArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == dataArr.count {
            let h = "Suggestion / Need more help?".getTextHeigh(BFONT(15), S_W - 40)
            return h + 30
        }
        else if indexPath.row == dataArr.count + 1 {
            let h = "After Sales".getTextHeigh(BFONT(15), S_W - 40)
            return h + 30
        }
        
        else {
            let h = dataArr[indexPath.row]["title"].stringValue.getTextHeigh(BFONT(15), S_W - 40)
            return h + 30
        }
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell") as! ProblemCell
        if indexPath.row == dataArr.count {
            cell.textLab.text = "Suggestion / Need more help?"
        }
        else if indexPath.row == dataArr.count + 1 {
            cell.textLab.text = "After Sales"
        }
        else {
            cell.textLab.text = dataArr[indexPath.row]["title"].stringValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == dataArr.count + 1 {
            //售后
            let nextVC = AfterSalesController()
            nextVC.orderID = self.orderID
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else if indexPath.row == dataArr.count {
            //意见建议
            let nextVC = SuggestionController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        else {
            let nextVC = FAQDetailController()
            nextVC.helpID = dataArr[indexPath.row]["helpId"].stringValue
            nextVC.orderID = self.orderID
            nextVC.titleStr = dataArr[indexPath.row]["title"].stringValue
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    //MARK: - 网络请求
    func getListData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getHelpList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.dataArr = json["data"].arrayValue
            self.configTable()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    

    
    
}


class ProblemCell: BaseTableViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    let textLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "How Do I gong"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(textLab)
        textLab.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
}
