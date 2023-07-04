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

    
    private var tabKey: String = ""
    //private var curRow: Int = 0
    
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
        tableView.register(OrderBottomButCell.self, forCellReuseIdentifier: "OrderBottomButCell")
        tableView.register(OrderRemarkCell.self, forCellReuseIdentifier: "OrderRemarkCell")
        tableView.register(OrderContentCell.self, forCellReuseIdentifier: "OrderContentCell")
        tableView.register(OrderContentMoneyCell.self, forCellReuseIdentifier: "OrderContentMoneyCell")
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
    
    func setCelllData(model: OrderModel, tabKey: String) {
        self.dataModel = model
        self.mainTabel.backgroundColor = .white
        self.tabKey = tabKey
        
        self.mainTabel.reloadData()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 3 {
            if tabKey == "SENDING" {
                return 1
            }
            return 0
        }
        
        if section == 1 {
            
            if dataModel.paymentMethod == "1" {
                //现金
                return 1
            } else {
                return 0
            }
        }
        
        if section == 2 {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return dataModel.content_H
        }
        if indexPath.section == 3 {
            return 50
        }
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderContentCell") as! OrderContentCell
            cell.setCellData(model: dataModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderContentMoneyCell") as! OrderContentMoneyCell
            cell.setCellData(type: "Cash", money: D_2_STR(dataModel.payPrice))
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderContentMoneyCell") as! OrderContentMoneyCell
            cell.setCellData(type: "Delivery fee", money: D_2_STR(dataModel.deliveryFee))
            return cell
        }

        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBottomButCell") as! OrderBottomButCell
            cell.setCellData(model: dataModel)

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
        
        if tabKey == "SENDING" {
            nextVC.haveBut = true
        } else {
            nextVC.haveBut = false
        }
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
}






class OtherOderCell: BaseTableViewCell {
    
    
    var clickBlock: VoidStringBlock?
    
    private var dataModel = OtherOrderModel()
    
    private var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(15), .left)
        lab.text = "#1647883633409781761"
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(10), .right)
        lab.text = "Estimated time"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .right)
        lab.text = "11:03-12:05"
        return lab
    }()
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(13), .right)
        lab.text = "13940159904"
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    private let phoneBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("phone"), for: .normal)
        return but
    }()
    
    
    private let postCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(18), .left)
        lab.text = "MK8 8AN"
        return lab
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "3 Medhurst，Two Mile Ash"
        return lab
    }()
    
    
    ///完成
    private let completeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Complete", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    ///开始按钮
    private let startBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Start", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    ///导航按钮
    private let daoHangBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Navigate", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()
    
    
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(35)
        }
        
        backView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.right.equalTo(tlab.snp.left).offset(-5)
            $0.bottom.equalTo(tlab.snp.bottom).offset(2)
        }
        
        backView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(55)
        }


        backView.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalTo(phoneLab)
            $0.right.equalTo(phoneLab.snp.left).offset(-3)
        }
        
        
        backView.addSubview(postCodeLab)
        postCodeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(50)
        }
        
        backView.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-170)
        }

        
        
        
        backView.addSubview(startBut)
        startBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(100))
            $0.right.equalToSuperview().offset(-R_W(100))
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
        }
        
        
        backView.addSubview(completeBut)
        completeBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.width.equalTo((S_W - 80) / 2)

        }
        
        backView.addSubview(daoHangBut)
        daoHangBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.width.equalTo((S_W - 80) / 2)
        }
        
        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickPhoneAction))
        phoneLab.addGestureRecognizer(tap)
        
        daoHangBut.addTarget(self, action: #selector(clickDaoHangAction), for: .touchUpInside)
        completeBut.addTarget(self, action: #selector(clickCompleteAction), for: .touchUpInside)
        startBut.addTarget(self, action: #selector(clickStartAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickPhoneAction() {
        PJCUtil.callPhone(phone: dataModel.phone)
    }
    
    
    
    @objc private func clickStartAction() {
        clickBlock?("start")
        
    }

    
    @objc func clickCompleteAction() {
        clickBlock?("complete")
    }
        
    
    @objc func clickDaoHangAction() {
        PJCUtil.goDaohang(lat: dataModel.lat, lng: dataModel.lng)
    }

    
    
    func setCellData(model: OtherOrderModel) {
        self.dataModel = model
        self.numberLab.text = "#\(model.orderCode)"
        
        self.timeLab.text = model.riderStartTime + "-" + model.riderEndTime
        self.postCodeLab.text = model.postCode
        self.addressLab.text = model.address
        self.phoneLab.text = model.phone
        
        if model.riderStartTime == "" {
            self.timeLab.isHidden = true
            self.tlab.isHidden = true
        } else {
            self.timeLab.isHidden = false
            self.tlab.isHidden = false

        }
        
        if model.orderStatus == "2" {
            //可以点击start
            self.startBut.isHidden = false
            self.daoHangBut.isHidden = true
            self.completeBut.isHidden = true
        }
        
        if model.orderStatus == "3" {
            self.startBut.isHidden = true
            self.daoHangBut.isHidden = false
            self.completeBut.isHidden = false

        }
        
    }
    
    
}
