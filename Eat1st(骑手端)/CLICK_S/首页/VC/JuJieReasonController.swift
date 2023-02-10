//
//  JuJieReasonController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/2.
//

import UIKit
import RxSwift
import SwiftyJSON


class JujieModel: NSObject {
    var id: String = ""
    var name: String = ""
    var key: String = ""
    
    func updateModel(json: JSON) {
        self.id = json["refuseTypeId"].stringValue
        self.name = json["refuseTypeName"].stringValue
        self.key = json["refuseTypeKey"].stringValue
    }
    
}


class UnsuccessfulReasonModel: NSObject {
    var id: String = ""
    var name: String = ""
    
    func updateModel(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
    }

    
}


class JuJieReasonController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    private let bag = DisposeBag()
    
    var orderID: String = ""
    
    private var selectIdx: Int = 100
    private var dataArr: [UnsuccessfulReasonModel] = []
    private var reasonHeight: CGFloat = 0
    ///拒接图片
    private var picImgArr: [UIImage] = []
    private var otherReason: String = ""
    
    private var sectionNum: Int = 0
    
    

    private let dealBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "To deal with", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    
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
        tableView.register(JuJieReasonCell.self, forCellReuseIdentifier: "JuJieReasonCell")
        tableView.register(JuJieInputCell.self, forCellReuseIdentifier: "JuJieInputCell")
        tableView.register(JuJieUploadImgCell.self, forCellReuseIdentifier: "JuJieUploadImgCell")
        //tableView.layer.cornerRadius = 10
        return tableView
    }()
    

    
    
    
    override func setViews() {
        view.backgroundColor = HCOLOR("#F7F7F7")
        
        view.addSubview(dealBut)
        dealBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
            $0.bottom.equalTo(view.snp.bottom).offset(-25)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom).offset(0)
            $0.bottom.equalTo(dealBut.snp.top).offset(-20)
        }
        
    
        dealBut.addTarget(self, action: #selector(clickButAction), for: .touchUpInside)
        
        self.loadData_Net()
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Unsuccessful Reason"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

    
    @objc private func clickButAction() {

        if selectIdx == 100 {
            HUD_MB.showWarnig("Please select", onView: view)
            return
        }

        let model = dataArr[selectIdx]
        if model.id == "-1" && self.otherReason == "" {
            HUD_MB.showWarnig("Please fill in the reason！", onView: view)
            return
        }
        
        if self.picImgArr.count == 0 {
            HUD_MB.showWarnig("Please upload at least one evidence picture!", onView: self.view)
            return
        }
        
        self.uploadImages_Net()

    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            if selectIdx != 100 && dataArr[selectIdx].id == "-1" {
                return 1
            } else {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return reasonHeight + 35
        }
        
        if indexPath.section == 1 {
            return 160
        }
        
        if indexPath.section == 2 {
            let w = (S_W - 80) / 5
            if picImgArr.count > 4 {
                return (w * 2 + 10) + 40
            } else {
                return w + 40
            }

        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JuJieReasonCell") as! JuJieReasonCell
            cell.setCellData(dataArr: self.dataArr, selectIdx: selectIdx)
            
            cell.selectBlock = { [unowned self] (idx) in
                self.selectIdx = idx as! Int
                self.table.reloadData()
            }
            
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JuJieInputCell") as! JuJieInputCell
            cell.setCellData(str: self.otherReason)
            cell.editeTextBlock = { [unowned self] (str) in
                self.otherReason = str as! String
            }
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JuJieUploadImgCell") as! JuJieUploadImgCell
            cell.setCellData(picArr: picImgArr)
            cell.editeImgblock = { [unowned self] (arr) in
                self.picImgArr = arr
                self.table.reloadData()
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getUnsuccessfulReason().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [UnsuccessfulReasonModel] = []
            var th: CGFloat = 0
            for jsonData in json["data"].arrayValue {
                let model = UnsuccessfulReasonModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
                
                let h = model.name.getTextHeigh(SFONT(14), S_W - 70) + 20
                th += h
            }
            self.dataArr = tArr
            self.reasonHeight = th
            self.sectionNum = 3
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
            self.backOrder_Net(imageList: par)
            
        } failure: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }
    }
    
    //订单退回
    private func backOrder_Net(imageList: [[String: String]]) {
        HTTPTOOl.orderBack(orderID: orderID, reasonID: dataArr[selectIdx].id, otherReason: otherReason, imageList: imageList).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    
    
}


class ReasonOptionCell: BaseTableViewCell {
    
    private let reasonLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "reason"
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("select_nor")
        return img
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(reasonLab)
        reasonLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-40)
        }
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    
    }
    
    func setCellData(str: String, selected: Bool) {
        self.reasonLab.text = str
        
        if selected {
            self.selectImg.image = LOIMG("select_sel")
        } else {
            self.selectImg.image = LOIMG("select_nor")
        }
    }
    
}


