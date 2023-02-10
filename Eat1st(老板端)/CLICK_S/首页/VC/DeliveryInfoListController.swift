//
//  DeliveryInfoListController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/26.
//

import UIKit
import RxSwift
import SwiftyJSON

class RiderModel {
    
    var name: String = ""
    var phone: String = ""
    /// 骑手状态 1上班，2下班
    var status: String = ""
    ///id
    var id: String = ""
    ///经度 纬度
    var lng: Double = 0
    var lat: Double = 0
    
    func updateModel(json: JSON) {
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.status = json["status"].stringValue
        self.id = json["id"].stringValue
        
        let t_str = json["lngLat"].stringValue
        
        let strArr = t_str.components(separatedBy: ",")
        
        self.lng = Double(strArr.first!) ?? 0
        self.lat = Double(strArr.last!) ?? 0
        
        
    }
    
}


class DeliveryInfoListController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    private let bag = DisposeBag()
    
    private var dataArr: [RiderModel] = []
    
    
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
        tableView.register(DeliveryInfoCell.self, forCellReuseIdentifier: "DeliveryInfoCell")
    

        return tableView
    }()
    
    override func setViews() {
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalTo(naviBar.snp.bottom)
        }
        
        loadDate_Net()
        
    }
    
    override func setNavi() {
        self.naviBar.backgroundColor = MAINCOLOR
        self.naviBar.headerTitle = "Drivers"
        self.naviBar.leftImg = LOIMG("nav_back")
    }
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - 网络请求
    private func loadDate_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getRiderList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            var tArr: [RiderModel] = []
            for jsonData in json["data"].arrayValue {
                let model = RiderModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            self.dataArr = tArr
            self.table.reloadData()
            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoCell") as! DeliveryInfoCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = CheckPSYLocalController()
        nextVC.riderID = dataArr[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

}


class DeliveryInfoCell: BaseTableViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .left)
        lab.text = "PATTON"
        return lab
    }()
    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.text = "+91 2981 91999909"
        return lab
    }()
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("next_y"), for: .normal)
        return but
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .right)
        lab.text = "Delivrting"
        return lab
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 6, height: 17))
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(8)
        }
        
        backView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-30)
        }

        

        
    }
    
    func setCellData(model: RiderModel) {
        self.nameLab.text = model.name
        self.phoneLab.text = model.phone
        
        if model.status == "1" {
            //未配送
            self.line.backgroundColor = HCOLOR("#999999")
            self.tLab.textColor = HCOLOR("#999999")
            self.nextBut.setImage(LOIMG("next_g"), for: .normal)
            self.tLab.text = "Not in delivery"
            
        } else {
            //配送中
            self.line.backgroundColor = MAINCOLOR
            self.tLab.textColor = MAINCOLOR
            self.nextBut.setImage(LOIMG("next_y"), for: .normal)
            self.tLab.text = "Deliveriting"
        }
    }
    
}
