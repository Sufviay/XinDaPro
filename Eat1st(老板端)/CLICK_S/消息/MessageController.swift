//
//  MessageController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/10.
//

import UIKit
import RxSwift
import MJRefresh


class MessageController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var page: Int = 1
    
    private var dataArr: [MessageModel] = []
    
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
        //tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")

        return tableView
    }()
    
    
    

    
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Message Center"
    }

    
    override func setViews() {
        
        setUpUI()
        loadMsg_Net()
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadMsg_Net()
        }

        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadMsgMore_Net()
        }
    }
    
    
    func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalToSuperview().offset(20)
        }
        
        leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let model = dataArr[indexPath.row]
        if model.mergeType == "2" {
            ///合并订单
            let mergeVC = MergeOrderController()
            mergeVC.mergeID = model.orderID
            self.navigationController?.pushViewController(mergeVC, animated: true)
        } else {
            let detailVC = OrderDetailController()
            detailVC.orderID = model.orderID
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


extension MessageController {
    
    
    func loadMsg_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getMsgList(page: 1, type: "").subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            self.page = 2
            var tArr: [MessageModel] = []
            for jsondata in json["data"].arrayValue {
                let model = MessageModel()
                model.updateModel(json: jsondata)
                tArr.append(model)
            }
            
            dataArr = tArr
            table.reloadData()
            table.mj_header?.endRefreshing()
            table.mj_footer?.resetNoMoreData()

            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
            table.mj_header?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    func loadMsgMore_Net() {
        HTTPTOOl.getMsgList(page: page, type: "").subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            
            if json["data"].arrayValue.count == 0 {
                table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = MessageModel()
                    model.updateModel(json: jsonData)
                    dataArr.append(model)
                }
                table.reloadData()
                table.mj_footer?.endRefreshing()
            }
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
            table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
    }
    
    
    
}


class MessageCell: BaseTableViewCell {
    
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("msgimg")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .left)
        lab.text = "Rejected order"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(10), .right)
        lab.text = "2021-05-16 12:45"
        return lab
    }()
    
    private let czrLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "操作人"
        return lab
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(11), .left)
        lab.text = "orderID"
        return lab
    }()
    
    private let disLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(11), .left)
        lab.text = "Orders are discounted by £5"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    private let detailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(13), .left)
        lab.text = "View order details"
        return lab
    }()

    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_black")
        return img
    }()
    
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.top.equalToSuperview().offset(20)
        }
        
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.right.equalToSuperview().offset(-25)
        }
        
        contentView.addSubview(czrLab)
        czrLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(titLab.snp.bottom).offset(15)
        }
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.centerY.equalTo(czrLab)
            $0.left.equalTo(czrLab.snp.right).offset(3)
        }
        
        contentView.addSubview(disLab)
        disLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(czrLab.snp.bottom).offset(2)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(detailLab)
        detailLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(detailLab)
        }
        
        
    }
    
    
    func setCellData(model: MessageModel) {
        czrLab.text = model.createBy
        orderLab.text = model.orderID
        timeLab.text = model.createTime
        
        if model.operateType == "1" {
            //拒接订单
            titLab.text = "Rejected order"
            disLab.text = ""
        }
        
        if model.operateType == "2" {
            //取消订单
            titLab.text = "Cancelled order"
            disLab.text = ""
        }
        
        if model.operateType == "3" {
            //修改订单
            titLab.text = "Changed order"
            disLab.text = ""
        }
        if model.operateType == "4" {
            //打折订单
            titLab.text = "Discounted order"
            disLab.text = "Orders are discounted by £\(model.discountPrice)"
        }
        
    }
    
    
}



import SwiftyJSON

class MessageModel: NSObject {
    
    var orderID: String = ""
    ///操作类型（1拒接订单，2取消订单，3修改订单，4订单折扣）
    var operateType: String = ""
    ///订单是否合并（1否，2是），若orderId未合并订单编码，否则为订单编码
    var mergeType: String = ""
    ///优惠金额（当operator_type=4时有值）
    var discountPrice: String = ""
    ///操作人
    var createBy: String = ""
    ///操作时间
    var createTime: String = ""
    
    func updateModel(json: JSON) {
        self.orderID = json["orderId"].stringValue
        self.operateType = json["operateType"].stringValue
        self.mergeType = json["mergeType"].stringValue
        self.discountPrice = D_2_STR(json["discountPrice"].doubleValue)
        self.createBy = json["createBy"].stringValue
        self.createTime = json["createTime"].stringValue
    }
    
    
}


