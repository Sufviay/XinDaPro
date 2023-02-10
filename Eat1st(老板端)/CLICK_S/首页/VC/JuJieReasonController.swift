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


class JuJieReasonController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    private let bag = DisposeBag()
    
    var orderID: String = ""
    
    private var selectIdx: Int = 100

    
    private var dataArr: [JujieModel] = []
    
    
    
    
    private let dealBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "To deal with", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
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
        tableView.register(ReasonOptionCell.self, forCellReuseIdentifier: "ReasonOptionCell")
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    private lazy var inputTF: UITextView = {
        let view = UITextView()
        view.textColor = FONTCOLOR
        view.font = SFONT(14)
        view.delegate = self
        return view
    }()
    
    private let holderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(14), .left)
        lab.text = "Fill in other details"
        return lab
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
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(naviBar.snp.bottom).offset(15)
            $0.height.equalTo(200)
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalTo(table)
            $0.top.equalTo(table.snp.bottom).offset(10)
            $0.height.equalTo(150)
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        inputTF.addSubview(holderLab)
        holderLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(10)
        }
        
        
        dealBut.addTarget(self, action: #selector(clickButAction), for: .touchUpInside)
        
        self.loadData_Net()
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Refused to reason"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text ?? "" != "" {
            self.holderLab.isHidden = true
        } else {
            self.holderLab.isHidden = false
        }
    }
    
    @objc private func clickButAction() {
        
        if selectIdx == 100 {
            HUD_MB.showWarnig("Please select", onView: view)
            return
        }
        
        let model = dataArr[selectIdx]
        if model.id == "9" && inputTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please fill in the reason！", onView: view)
            return
        }
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.jujieAciton(orderID: orderID, customReason: inputTF.text ?? "", reasonID: model.id).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonOptionCell") as! ReasonOptionCell
        let select = selectIdx == indexPath.row ? true : false
        cell.setCellData(str: dataArr[indexPath.row].name, selected: select)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectIdx == indexPath.row {
            selectIdx = 100
        } else {
            selectIdx = indexPath.row
        }
        
        if selectIdx == 100 {
            self.inputTF.text = ""
            self.backView.isHidden = true
        } else {
            let id = dataArr[selectIdx].id
            if id == "99" {
                self.backView.isHidden = false
            } else {
                self.backView.isHidden = true
                self.inputTF.text = ""
            }
        }
        tableView.reloadData()
    }
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getJuJieReason().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [JujieModel] = []
            for jsonData in json["data"].arrayValue {
                let model = JujieModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
            self.table.reloadData()
            
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


