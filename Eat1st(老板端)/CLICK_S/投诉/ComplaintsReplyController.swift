//
//  ComplaintsReplyController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/28.
//

import UIKit
import RxSwift


class ComplaintsReplyController: HeadBaseViewController, UITableViewDataSource, UITableViewDelegate {

    private let bag = DisposeBag()
    
    var complaintsData = ComplaintsModel()
    
    private var wayArr: [ComplaintsDealWayModel] = []
    
    private var sectionNum: Int = 0
    
    
    private var selectWayID: String = ""
    ///退款流 1 余额 2 卡 3 现金
    private var refundFlow: String = ""
    ///退款模式 2全部 3申请的菜品退款 4自定义金额退款
    private var refundMode: String = ""
    ///退款金额
    private var refundAmount: String = ""
    ///再来一单选择的菜品
    private var selectDishesArr: [OrderDishModel] = []
    
    
    private lazy var refundAlert: ComplaintsRefundAlert = {
        let view = ComplaintsRefundAlert()
        
        view.clickConfirmBlock = { [unowned self] (par) in
            let info = par as! [String: String]
            
            selectWayID = "4"
            refundFlow = info["flow"]!
            refundMode = info["mode"]!
            refundAmount = info["amount"]!
            table.reloadData()
            
        }
        
        return view
    }()
    
    
    private lazy var dishesAlert: ComplaintsDishesAlert = {
        let view = ComplaintsDishesAlert()
        
        view.clickConfirmBlock = { [unowned self] (par) in
            selectWayID = "5"
            selectDishesArr = par as! [OrderDishModel]
            table.reloadData()
        }
        
        return view
    }()
    
    
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
        tableView.register(ComplaintsNameCell.self, forCellReuseIdentifier: "ComplaintsNameCell")
        tableView.register(ComplaintsReasonCell.self, forCellReuseIdentifier: "ComplaintsReasonCell")
        tableView.register(ComplaintsPictureCell.self, forCellReuseIdentifier: "ComplaintsPictureCell")
        tableView.register(ComplaintsContentCell.self, forCellReuseIdentifier: "ComplaintsContentCell")
        tableView.register(ComplaintsTitleCell.self, forCellReuseIdentifier: "ComplaintsTitleCell")
        tableView.register(ComplaintsDealCell.self, forCellReuseIdentifier: "ComplaintsDealCell")
        tableView.register(ComplaintsDealRefundCell.self, forCellReuseIdentifier: "ComplaintsDealRefundCell")
        tableView.register(DishesShowCell.self, forCellReuseIdentifier: "DishesShowCell")
        return tableView
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 15
        return but
    }()
    
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Complaint handling"
    }

    
    override func setViews() {
        setUpUI()
        getComplaintsDetail_Net()
    }
    
    
    
    
    private func setUpUI() {
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(confirmBut.snp.top).offset(-10)
            $0.top.equalToSuperview().offset(20)

        }
        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func clickConfirmAction() {
        if selectWayID != "" {
            doComplaints_Net()
        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        else if section == 1 {
            return 1
        }
        
        else if section == 2 {
            if complaintsData.plaintImgs.count == 0 {
                return 0
            } else {
                return 1
            }
        }
        else if section == 3 {
            if complaintsData.userHope == "" {
                return 0
            } else {
                return 1
            }
        }
        else if section == 4 {
            return 1
        }
        else {
            let id = wayArr[section - 5].id
            // 4 商家退款
            if id == "4" {
                if id == selectWayID {
                    return 2
                } else {
                    return 1
                }
            }
            //5 再送一单
            else if id == "5" {
                if id == selectWayID {
                    return selectDishesArr.count + 1
                } else {
                    return 1
                }
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 60
        }
        else if indexPath.section == 1 {
            return complaintsData.reason_H
        }
        else if indexPath.section == 2 {
            return complaintsData.picture_H
        }
        else if indexPath.section == 3 {
            return complaintsData.hope_H
        }
        else if indexPath.section == 4 {
            return 40
        } else {
            // 4 商家退款 5 再送一单
            
            let model = wayArr[indexPath.section - 5]
            if indexPath.row == 0 {
                return model.name_H
            } else {

                if model.id == "4" {
                    return 35
                }
                else if model.id == "5" {
                    return selectDishesArr[indexPath.row - 1].showCell_H
                } else {
                    return 0
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsNameCell") as! ComplaintsNameCell
            cell.setCellData(name: complaintsData.name, orderNum: complaintsData.orderId, tsNum: complaintsData.plaintNum, xdNum: complaintsData.buyNum, time: complaintsData.createTime)
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsReasonCell") as! ComplaintsReasonCell
            cell.setCellData(model: complaintsData)
            return cell

        }
        
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsPictureCell") as! ComplaintsPictureCell
            cell.setCellData(imgs: complaintsData.plaintImgs)
            return cell

        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsContentCell") as! ComplaintsContentCell
            cell.setCellData(content: complaintsData.userHope)
            return cell
        }
        
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsTitleCell") as! ComplaintsTitleCell
            return cell
        } else {
            
            let model = wayArr[indexPath.section - 5]
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsDealCell") as! ComplaintsDealCell
                let sel = model.id == selectWayID ? true : false
                cell.setCellData(title: model.name, selected: sel)
                return cell
            } else {
                
                if model.id == "4" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsDealRefundCell") as! ComplaintsDealRefundCell
                   
                    var way: String = ""
                    if refundFlow == "1" {
                        way = "wallet"
                    }
                    if refundFlow == "2" {
                        way = "card"
                    }
                    if refundFlow == "3" {
                        way = "cash"
                    }
                    
                    cell.setCellData(way: way, money: refundAmount)
                    
                    return cell
                    
                }
                
                else if model.id == "5" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DishesShowCell") as! DishesShowCell
                    cell.setCellData(model: selectDishesArr[indexPath.row - 1], isShow: true)
                    return cell
                }
                
                else {
                    let cell = UITableViewCell()
                    return cell
                }
            }
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 && indexPath.section != 1 && indexPath.section != 2 && indexPath.section != 3 && indexPath.section != 4 {
            
            if indexPath.row == 0 {
                
                let model = wayArr[indexPath.section - 5]
                
                if model.id == "4" {
                    //退款 弹出退款提示框
                    refundAlert.setRefundData(mode: refundMode, flow: refundMode, allMoney: complaintsData.orderPrice, partMoney: complaintsData.plaintAmount)
                    refundAlert.appearAction()
                }
                
                else if model.id == "5" {
                    //再来一单
                    dishesAlert.dishArr = complaintsData.plaintDishes
                    dishesAlert.appearAction()
                }
                
                else {
                    
                    if selectWayID != model.id {
                        selectWayID = model.id
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}




extension ComplaintsReplyController {
    
    private func getComplaintsDetail_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getComplatinsDetail(id: complaintsData.plaintId).subscribe(onNext: { [unowned self] (json) in
            complaintsData.isShow = true
            complaintsData.updateModel_Detail(json: json["data"])
            getDealWay_Net()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    private func getDealWay_Net() {
        HTTPTOOl.getComplaintDealContent().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            var tArr: [ComplaintsDealWayModel] = []
            for jsonData in json["data"].arrayValue {
                let model = ComplaintsDealWayModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            wayArr = tArr
            sectionNum = wayArr.count + 5
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    private func doComplaints_Net() {
        
        var mode = selectWayID == "4" ? refundMode : ""
        var flow = selectWayID == "4" ? refundFlow : ""
        var amount = mode == "4" ? refundAmount : ""
        
        var info: [[String: String]] = []
        if selectWayID == "5" {
            //再送一单
            for model in selectDishesArr {
                let dic = ["orderDishesId": model.orderDishesId, "num": "\(model.selectCount)"]
                info.append(dic)
            }
            
        }
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.doComplaints(plaintId: complaintsData.plaintId, handleType: selectWayID, refundMode: mode, amount: amount, refundFlow: flow, plaintDishesList: info).subscribe(onNext: { [unowned self] (json) in
            
            HTTPTOOl.getComplatinsDetail(id: complaintsData.plaintId).subscribe(onNext: { [unowned self] (json) in
                HUD_MB.showSuccess("Success", onView: view)
                complaintsData.updateModel_Detail(json: json["data"])
                navigationController?.popViewController(animated: true)
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            }).disposed(by: bag)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
}
