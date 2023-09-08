//
//  MergeOrderController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/11.
//

import UIKit
import RxSwift


class MergeOrderController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mergeID: String = ""
    
    private var dataModel = MergeModel()
    
    private let bag = DisposeBag()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .left)
        lab.text = ""
        return lab
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(11), .right)
        lab.text = ""
        return lab
    }()
    
    
    private let m_cashLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "£0"
        return lab
    }()
    
    private let m_poscardLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "£0"
        return lab
    }()

    private let m_disLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "£0"
        return lab
    }()
    
    
    private let m_tipsLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .center)
        lab.text = "£0"
        return lab
    }()


    private let cashImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("mer_cash")
        return img
    }()
    
    
    private let posImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("mer_pos")
        return img
    }()

    
    private let disImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("mer_dis")
        return img
    }()
    
    private let tipImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("mer_tip")
        return img
    }()
    
    private let slab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), SFONT(11), .left)
        lab.text = "Cash"
        return lab
    }()
    
    private let slab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), SFONT(11), .left)
        lab.text = "Pos/Card"
        return lab
    }()
    
    private let slab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), SFONT(11), .left)
        lab.text = "Discount"
        return lab
    }()
    
    private let slab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), SFONT(11), .left)
        lab.text = "Tips"
        return lab
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
        tableView.register(oderListCell.self, forCellReuseIdentifier: "oderListCell")

        return tableView
    }()


    


    
    
    
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Merge order"
    }

    
    override func setViews() {
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        orderLab.text = mergeID
        backView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(orderLab)
            $0.right.equalToSuperview().offset(-R_W(25))
        }
        
        backView.addSubview(cashImg)
        cashImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.size.equalTo(CGSize(width: 23, height: 15))
            $0.top.equalTo(orderLab.snp.bottom).offset(17)
        }
        
        backView.addSubview(posImg)
        posImg.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.size.equalTo(CGSize(width: 21, height: 19))
            $0.left.equalToSuperview().offset(R_W(105))
        }
        
        
        backView.addSubview(disImg)
        disImg.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.size.equalTo(CGSize(width: 19, height: 15))
            $0.left.equalToSuperview().offset(R_W(203))
        }
        
        backView.addSubview(tipImg)
        tipImg.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.size.equalTo(CGSize(width: 22, height: 18))
            $0.left.equalToSuperview().offset(R_W(298))
        }
        
        backView.addSubview(slab1)
        slab1.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.left.equalTo(cashImg.snp.right).offset(5)
        }
        
        
        backView.addSubview(slab2)
        slab2.snp.makeConstraints {
            $0.centerY.equalTo(posImg)
            $0.left.equalTo(posImg.snp.right).offset(5)
        }
        
        backView.addSubview(slab3)
        slab3.snp.makeConstraints {
            $0.centerY.equalTo(disImg)
            $0.left.equalTo(disImg.snp.right).offset(5)
        }
        
        backView.addSubview(slab4)
        slab4.snp.makeConstraints {
            $0.centerY.equalTo(tipImg)
            $0.left.equalTo(tipImg.snp.right).offset(5)
        }

        backView.addSubview(m_cashLab)
        m_cashLab.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(cashImg.snp.bottom).offset(10)
            $0.width.equalTo(S_W / 4)
        }
        
        backView.addSubview(m_poscardLab)
        m_poscardLab.snp.makeConstraints {
            $0.left.equalTo(m_cashLab.snp.right).offset(0)
            $0.centerY.width.equalTo(m_cashLab)
        }
        
        backView.addSubview(m_disLab)
        m_disLab.snp.makeConstraints {
            $0.left.equalTo(m_poscardLab.snp.right).offset(0)
            $0.centerY.width.equalTo(m_cashLab)
        }
        
        
        backView.addSubview(m_tipsLab)
        m_tipsLab.snp.makeConstraints {
            $0.left.equalTo(m_disLab.snp.right).offset(0)
            $0.centerY.equalTo(m_cashLab)
            $0.right.equalToSuperview()
        }

        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalToSuperview().offset(120)
        }
        
    
        loadData_Net()

    }

    
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oderListCell") as! oderListCell
        cell.orderLab.text = dataModel.orderList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //订单详情
        let detailVC = OrderDetailController()
        detailVC.orderID = dataModel.orderList[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getMergeDetail(mergeID: mergeID).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            dataModel.updateModel(json: json["data"])
            m_cashLab.text = dataModel.cashPrice
            m_poscardLab.text = dataModel.cardPrice
            m_tipsLab.text = dataModel.tipPrice
            m_disLab.text = dataModel.noPaidPrice
            timeLab.text = dataModel.createTime
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: self.bag)
    }



}


class oderListCell: BaseTableViewCell {
    
    
    let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
        lab.text = "#1550515678022548934"
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("next_blue")
        return img
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    
    override func setViews() {
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.right.equalToSuperview().offset(-R_W(25))
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.left.equalTo(line)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 10))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(line)
        }
    }
    
}


import SwiftyJSON

class MergeModel: NSObject {
    
    ///卡支付金额
    var cardPrice: String = ""
    ///现金支付
    var cashPrice: String = ""
    ///免除金额
    var noPaidPrice: String = ""
    ///小费金额
    var tipPrice: String = ""

    ///操作人
    var createBy: String = ""
    ///操作时间
    var createTime: String =  ""
    
    ///订单列表
    var orderList: [String] = []
    
    func updateModel(json: JSON) {
        self.cardPrice = D_2_STR(json["cardPrice"].doubleValue)
        self.cashPrice = D_2_STR(json["cashPrice"].doubleValue)
        self.noPaidPrice = D_2_STR(json["noPaidPrice"].doubleValue)
        self.tipPrice = D_2_STR(json["tipPrice"].doubleValue)
        self.createBy = json["createBy"].stringValue
        self.createTime = json["createTime"].stringValue
        
        var tarr: [String] = []
        for jsonData in json["orderList"].arrayValue {
            tarr.append(jsonData["orderId"].stringValue)
        }
        
        self.orderList = tarr
        
    }
    
}


