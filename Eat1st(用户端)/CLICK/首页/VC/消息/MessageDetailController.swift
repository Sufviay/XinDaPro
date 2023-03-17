//
//  MessageDetailController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit

class MessageDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataModel = MessageModel()
    
    private var web_H: CGFloat = 50
    
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
        tableView.register(MessageHeaderCell.self, forCellReuseIdentifier: "MessageHeaderCell")
        tableView.register(MessageBottomCell.self, forCellReuseIdentifier: "MessageBottomCell")
        tableView.register(BottomCornersCell.self, forCellReuseIdentifier: "BottomCornersCell")
        return tableView
    }()


    override func setNavi() {
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.headerTitle = "Message details"
        self.naviBar.rightBut.isHidden = true
    }
    
    override func setViews() {
        setUpUI()
    }

    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        self.view.backgroundColor = HCOLOR("#F7F6F9")
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}


extension MessageDetailController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return dataModel.t_H_detail + 20
        }
        if indexPath.row == 1 {
            return web_H
        }
        if indexPath.row == 2 {
            
            if dataModel.sikpType == "1" {
                return 20
            } else {
                return 40
            }
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHeaderCell") as! MessageHeaderCell
            cell.setCellData(model: dataModel)
            return cell
        }
        if indexPath.row == 1 {
            
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "richTextCell")
            if cell == nil {

                cell = UITableViewCell(style: .default, reuseIdentifier: "richTextCell")
                cell?.selectionStyle = .none
                cell?.contentView.backgroundColor = .clear
                cell?.backgroundColor = .clear
                
                let backView = UIView()
                backView.backgroundColor = .white
                cell?.contentView.addSubview(backView)
                backView.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(10)
                    $0.right.equalToSuperview().offset(-10)
                    $0.top.bottom.equalToSuperview()
                }
                
                let richTextView = RichTextView(frame: .zero, fromVC: self)
                richTextView.webHeight = { [unowned self] height in
                    self.web_H = height
                    self.table.reloadData()
                }
                //放在cell中不要让webView滚动
                richTextView.isScrollEnabled = false

                richTextView.richText = dataModel.content
                backView.addSubview(richTextView)
                richTextView.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(10)
                    $0.right.equalToSuperview().offset(-10)
                    $0.top.equalToSuperview().offset(5)
                    $0.bottom.equalToSuperview().offset(0)
                }
            }
            return cell!
        }
        
        if indexPath.row == 2 {
            
            if dataModel.sikpType == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BottomCornersCell") as! BottomCornersCell
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBottomCell") as! MessageBottomCell
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if dataModel.sikpType == "2" {
                //跳转店铺
                let nextVC = StoreMenuOrderController()
                nextVC.storeID = dataModel.sikpContent
                self.navigationController?.setViewControllers([FirstController(), nextVC], animated: true)
            }
            
            if dataModel.sikpType == "3" {
                //跳转链接
                let webVC = ServiceController()
                webVC.titStr = ""
                webVC.webUrl = dataModel.sikpContent
                self.present(webVC, animated: true, completion: nil)

                
            }
        }
    }
    
}
