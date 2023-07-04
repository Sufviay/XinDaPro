//
//  AfterSalesController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/29.
//

import UIKit
import RxSwift
import CoreAudio
import SwiftyJSON

class AfterSalesController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var orderID: String = ""
    
    //订单菜品列表
    private var dishesArr: [PlaintDishModel] = []
    
    //原因列表
    private var reasonArr: [PlaintReasonModel] = []
    

    private let bag = DisposeBag()
    
    ///投诉图片
    private var picImgArr: [UIImage] = []
    ///投诉信息
    private var otherText: String = ""
    ///投诉菜品
    private var complaintDishArr: [[String: Any]] = []
    ///选择原因的下标
    private var selectIdx: Int = 10000
    ///选择次级原因的下标
    private var nextSelectIdx: Int = 10000
    
    private var sectionNum: Int = 0
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
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
        tableView.bounces = false
        
        
        tableView.register(AfterSalesMessageCell.self, forCellReuseIdentifier: "AfterSalesMessageCell")
        tableView.register(AfterSalesTitleCell.self, forCellReuseIdentifier: "AfterSalesTitleCell")
        tableView.register(AfterSalesSelectGoodsCell.self, forCellReuseIdentifier: "AfterSalesSelectGoodsCell")
        tableView.register(AfterSalesCornersCell.self, forCellReuseIdentifier: "AfterSalesCornersCell")
        tableView.register(AfterSalesSelectReasonCell.self, forCellReuseIdentifier: "AfterSalesSelectReasonCell")
        tableView.register(AfterSalesItemJieShaoCell.self, forCellReuseIdentifier: "AfterSalesItemJieShaoCell")
        tableView.register(AfterSalesDetailReasonCell.self, forCellReuseIdentifier: "AfterSalesDetailReasonCell")
        tableView.register(AfterSalesUploadCell.self, forCellReuseIdentifier: "AfterSalesUploadCell")
        tableView.register(AfterSalesInPutCell.self, forCellReuseIdentifier: "AfterSalesInPutCell")
        
        //tableView.register(AfterSalesGoodsCell.self, forCellReuseIdentifier: "AfterSalesGoodsCell")
        //tableView.register(AfterSalesReasonCell.self, forCellReuseIdentifier: "AfterSalesReasonCell")
        
        

        return tableView
    }()
    
    
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: R_W(230), height: 50), byRoundingCorners: [.topLeft, .bottomLeft], radii: 25)
        return view
    }()
    
    private let sureBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(17), MAINCOLOR)
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: R_W(125), height: 50), byRoundingCorners: [.topRight, .bottomRight], radii: 25)
        return but
    }()
    
    
    private let tLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .left)
        lab.text = "Selected amount"
        return lab
    }()

    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
        lab.text = "It might be different"
        return lab
    }()
    
    private let tLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
        lab.text = "£"
        return lab
    }()
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(20), .left)
        lab.text = "0.0"
        return lab
    }()

    
    
    
    override func setNavi() {
        self.naviBar.headerTitle = "After sales"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }
    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        setUpUI()
        self.getOrderInfo_Net()
    }
    
    
    override func clickLeftButAction() {
                
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setUpUI() {
        
        view.addSubview(tView)
        tView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(10))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.width.equalTo(R_W(230))
            $0.height.equalTo(50)
        }
        
        tView.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(20))
            $0.top.equalToSuperview().offset(10)
        }
        
        tView.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.left.equalTo(tLab1)
            $0.top.equalTo(tLab1.snp.bottom).offset(0)
        }
        
        tView.addSubview(tLab3)
        tLab3.snp.makeConstraints {
            $0.left.equalTo(tLab1.snp.right).offset(5)
            $0.centerY.equalTo(tLab1)
        }
        
        tView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(tLab3.snp.right).offset(1)
            $0.bottom.equalTo(tLab3.snp.bottom).offset(2)
            
        }
        
        view.addSubview(sureBut)
        sureBut.snp.makeConstraints {
            $0.centerY.equalTo(tView)
            $0.size.equalTo(CGSize(width: R_W(125), height: 50))
            $0.left.equalTo(tView.snp.right)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(0)
            $0.bottom.equalTo(tView.snp.top).offset(-10)
        }
        
        sureBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        
    }
    
    
    
    
    
    //MARK: - 提交投诉
    @objc private func clickConfirmAction() {
        self.complaintDishArr = self.getSelectedDish()
        
        if self.complaintDishArr.count == 0 {
            HUD_MB.showWarnig("Please choose dishes！", onView: self.view)
            return
        }
        if self.selectIdx == 10000 {
            HUD_MB.showWarnig("Please select a reason for your complaint！", onView: self.view)
            return
        }
        if self.picImgArr.count == 0 {
            HUD_MB.showWarnig("Please upload at least one evidence picture!", onView: self.view)
            return
        }
        
        if reasonArr[selectIdx - 5].reasonID == "-1" && self.otherText == "" {
            HUD_MB.showWarnig("Please fill in the reason for the complaint!", onView: self.view)
            return
        }
        
        if reasonArr[selectIdx - 5].hopeList.count != 0 && nextSelectIdx == 10000 {
            HUD_MB.showWarnig("Place choose your prefereed outcome!", onView: self.view)
            return

        }
        
        self.uploadImages_Net()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        
        else if indexPath.section == 1 || indexPath.section == 4 {
            return 50
        }
        
        else if indexPath.section == 2 {
            return dishesArr[indexPath.row].dish_H
        }
        
        else if indexPath.section == 3 || indexPath.section == sectionNum - 1 {
            return 20
        }
        
        else if indexPath.section == sectionNum - 2 {
            return 100
        }
        
        else if indexPath.section == sectionNum - 3 {
            let w = (S_W - 80) / 5

            if picImgArr.count > 4 {
                return (w * 2 + 10) + 20 + 30
            } else {
                return w + 20 + 30
            }
        }
        else {
            
            if indexPath.row == 0 {
                
                let h = reasonArr[indexPath.section - 5].reasonName.getTextHeigh(SFONT(14),  S_W - 130)
                return h + 20
            
            }
            
            else if indexPath.row == 1 {
                return 40
            }
            
            else {
                let h = reasonArr[indexPath.section - 5].hopeList[indexPath.row - 2]["name"].stringValue.getTextHeigh(SFONT(14),  S_W - 85)
                return h + 20
            }
                    
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == sectionNum - 2 {

            if selectIdx != 10000 {
                if reasonArr[selectIdx - 5].reasonID == "-1" {
                    return 1
                } else {
                    return 0
                }

            } else {
                return 0
            }
            
        }
        
        else if section == 0 || section == 1 || section == 3 || section == 4 || section == sectionNum - 1  || section == sectionNum - 3 {
            return 1
        }
        
        else if section == 2 {
            return dishesArr.count
        } else {
            if reasonArr[section - 5].hopeList.count != 0  && selectIdx  == section {
                return reasonArr[section - 5].hopeList.count + 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesMessageCell") as! AfterSalesMessageCell
            cell.titlab.text = "We are sorry you haven't experienced the service you deserve. Please tell us more about your experience"
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesTitleCell") as! AfterSalesTitleCell
            cell.titlab.text = "Please select the dishes"
            cell.sImg.isHidden = true
            return cell
        }
        
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesSelectGoodsCell") as! AfterSalesSelectGoodsCell
            cell.setCellData(model: dishesArr[indexPath.row])
            
            cell.clickCountBlock = { [unowned self] (count) in
                self.dishesArr[indexPath.row].selectCount = count as! Int
                self.moneyLab.text = self.getGoodsPrice()
            }
            
            return cell
        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesCornersCell") as! AfterSalesCornersCell
            return cell
        }
        
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesTitleCell") as! AfterSalesTitleCell
            cell.titlab.text = "Reason"
            cell.sImg.isHidden = false
            return cell
        }
        
        
        else if indexPath.section == sectionNum - 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesUploadCell") as! AfterSalesUploadCell
            cell.setCellData(picArr: self.picImgArr)

            cell.editeImgblock = { [unowned self] (arr) in
                self.picImgArr = arr
                self.table.reloadData()
            }
            return cell

        }
        
        else if indexPath.section == sectionNum - 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesInPutCell") as! AfterSalesInPutCell
            cell.setCellData(other: self.otherText)

            cell.editeTextBlock = { [unowned self] (str) in
                self.otherText = str as! String
            }
            return cell
            
        }
        
        else if indexPath.section == sectionNum - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesCornersCell") as! AfterSalesCornersCell
            return cell
        }
        
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesSelectReasonCell") as! AfterSalesSelectReasonCell
                let isSel = selectIdx == indexPath.section ? true : false
                cell.setCellData(model: reasonArr[indexPath.section - 5], isSelect: isSel)
                return cell
            }
            
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesItemJieShaoCell") as! AfterSalesItemJieShaoCell
                cell.titlab.text = "Please choose your preferred outcome and we will review your claim, this may not be approved"
                return cell
            }
            
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesDetailReasonCell") as! AfterSalesDetailReasonCell
                let isSel = nextSelectIdx == indexPath.row ? true : false
                let name = reasonArr[indexPath.section - 5].hopeList[indexPath.row - 2]["name"].stringValue
                cell.setCellData(nameStr: name, isSelect: isSel)
                return cell
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section != 0 && indexPath.section != 1 && indexPath.section != 2 && indexPath.section != 3 && indexPath.section != 4 && indexPath.section != sectionNum - 1 && indexPath.section != sectionNum - 2 && indexPath.section != sectionNum - 3 {
            
            if indexPath.row == 0 {
                
                if selectIdx != indexPath.section {
                    selectIdx = indexPath.section
                    nextSelectIdx = 10000
                    self.table.reloadData()
                }
            }
            
            if indexPath.row != 0 && indexPath.row != 1 {
                
                if nextSelectIdx != indexPath.row {
                    nextSelectIdx = indexPath.row
                    self.table.reloadData()
                }
            }
            
        }
    }

}


extension AfterSalesController {
    
    
    //MARK: - 网络请求
    
    
    ///请求订单信息
    private func getOrderInfo_Net() {
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getPlaintOrderDishesAndReason(orderID: orderID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var t1: [PlaintDishModel] = []
            var t2: [PlaintReasonModel] = []
            
            for jsonData in json["data"]["dishesList"].arrayValue {
                let model = PlaintDishModel()
                model.updateModel(json: jsonData)
                t1.append(model)
            }
            
            for jsondata in json["data"]["reasonList"].arrayValue {
                let model = PlaintReasonModel()
                model.updateModel(json: jsondata)
                t2.append(model)
                
//                let h = model.reasonName.getTextHeigh(SFONT(14), S_W - 100) + 20
//                th += h
            }
            self.dishesArr = t1
            self.reasonArr = t2
//            self.reasonHight = th
                        
            self.sectionNum = self.reasonArr.count + 8
            
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    
    ///上传图片
    private func uploadImages_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.uploadImages(images: self.picImgArr) { json in
            var par: [[String: String]] = []
            for jsonData in json["data"].arrayValue {
                let dic = ["url": jsonData["imageUrl"].stringValue]
                par.append(dic)
            }
            self.complaint_Net(imageUrl: par)
        } failure: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }
    }
    
    
    ///投诉
    private func complaint_Net(imageUrl: [[String: String]]) {
        
        var hopeID: String = ""
        
        if reasonArr[selectIdx - 5].hopeList.count != 0 {
            hopeID = reasonArr[selectIdx - 5].hopeList[nextSelectIdx - 2]["id"].stringValue
        }
        
        HTTPTOOl.complaintsDishes(other: self.otherText, orderID: self.orderID, dishes: self.complaintDishArr, reasonID: self.reasonArr[selectIdx - 5].reasonID, imageUrl: imageUrl, hopeID: hopeID).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success!", onView: self.view)
            //NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)

            DispatchQueue.main.after(time: .now() + 1) {
                //返回订单详情
                
                for controller in self.navigationController!.viewControllers {
                    if controller.isKind(of: OrderDetailController.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                    }
                }
                
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
   
    
    //计算选择商品的价格
    private func getGoodsPrice() -> String {
        
        var tNum: Double = 0
        
        for model in self.dishesArr {
            if model.selectCount != 0 {
                tNum += model.price * Double(model.selectCount)
            }
        }
        return String(format: "%.2f", tNum)
    }
    
    //选择的菜品及数量
    private func getSelectedDish() -> [[String: Any]] {
        
        var tArr: [[String: Any]] = []
        for model in self.dishesArr {
            if model.selectCount != 0 {
                let dic: [String: Any] = ["num": model.selectCount, "orderDishesId": model.dishID]
                tArr.append(dic)
            }
        }
        return tArr
    }
    
    
    
}
