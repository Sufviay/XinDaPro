//
//  OrderListCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit


// 6待接单。 接单、拒接单
// 5拒接单  拒接原因
// 7已接单  已出餐按钮
// 8已出餐 配货员开始配送按钮
// 9配送中  无按钮
// 10 完成。 没有评价 没有投诉 没有按钮
// 评价展示评价内容 时间 星级
// 投诉了 展示查看投诉按钮

class OrderListCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    var clickBlock: VoidBlock?

    private var dataModel = OrderModel() {
        didSet {
            self.mainTabel.reloadData()
        }
    }
   
//    private let backView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 10
//        view.backgroundColor = HCOLOR("#FFFBF2")
//        return view
//    }()
    
    private lazy var mainTabel: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = HCOLOR("#FFFBF2")
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OrderHeaderTypeCell.self, forCellReuseIdentifier: "OrderHeaderTypeCell")
        tableView.register(OrderNumberInfoCell.self, forCellReuseIdentifier: "OrderNumberInfoCell")
        tableView.register(OrderAddressCell.self, forCellReuseIdentifier: "OrderAddressCell")
        tableView.register(OrderGoodsCell.self, forCellReuseIdentifier: "OrderGoodsCell")
        tableView.register(OrderMoneyCell.self, forCellReuseIdentifier: "OrderMoneyCell")
        tableView.register(OrderRefuseCell.self, forCellReuseIdentifier: "OrderRefuseCell")
        tableView.register(OrderEvaluateCell.self, forCellReuseIdentifier: "OrderEvaluateCell")
        tableView.register(OrderDealButCell.self, forCellReuseIdentifier: "OrderDealButCell")
        tableView.register(OrderComplaintCell.self, forCellReuseIdentifier: "OrderComplaintCell")
        tableView.register(OrderBottomButCell.self, forCellReuseIdentifier: "OrderBottomButCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        tableView.register(OrderContentCell.self, forCellReuseIdentifier: "OrderContentCell")
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    
    override func setViews() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(mainTabel)
        mainTabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setCelllData(model: OrderModel) {
        self.dataModel = model
        self.mainTabel.backgroundColor = .white
        self.mainTabel.reloadData()
        
//        if model.type == "1" {
//            self.mainTabel.backgroundColor = .white
//        } else {
//            self.mainTabel.backgroundColor = HCOLOR("FFFBF2")
//        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            //底部按钮  1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
            if dataModel.status == .pay_success || dataModel.status == .takeOrder || dataModel.status == .cooked || dataModel.status == .delivery_ing {
                return 1
            }
            if dataModel.status == .finished && dataModel.tsStatus == "2" {
                return 1
            }
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return dataModel.h12
        }
        if indexPath.section == 1 {
            return 60
        }

        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderContentCell") as! OrderContentCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBottomButCell") as! OrderBottomButCell
            cell.setCellData(type: dataModel.type, model: dataModel)

            cell.clickBlock = { [unowned self] (type) in
                self.clickBlock?([type, dataModel.id])
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = OrderDetailController()
        nextVC.orderID = dataModel.orderNum
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
