//
//  ChangeDistanceController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/11.
//

import UIKit
import RxSwift


class ChangeDistanceController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    private let bag = DisposeBag()
    
    
    ///配送费方式
    private var feeType: String = "1" {
        didSet {
            //距离
            if feeType == "1" {
                postcodeBut.backgroundColor = .clear
                postcodeBut.setTitleColor(HCOLOR("ADADAD"), for: .normal)
                radiusBut.backgroundColor = HCOLOR("465DFD")
                radiusBut.setTitleColor(.white, for: .normal)
            }
            //邮编
            if feeType == "2" {
                radiusBut.backgroundColor = .clear
                radiusBut.setTitleColor(HCOLOR("ADADAD"), for: .normal)
                postcodeBut.backgroundColor = HCOLOR("465DFD")
                postcodeBut.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    
    private var radiusDataArr: [DeliveryFeeModel] = []
    private var postCodeDataArr: [DeliveryFeeModel] = []

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    

//    private let titLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .left)
//        lab.numberOfLines = 0
//        lab.text = "1. The delivery distance shall be at most one decimal point and must be greater than 0. The delivery fee can be 0.\n2. Delivery distance and delivery fee must be increasing.\n3. The farthest distance is the maximum distribution distance of the store."
//        return lab
//    }()
    
    
    private let selectBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let radiusBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Radius", HCOLOR("#ADADAD"), BFONT(11), .clear)
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let postcodeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Postcode", HCOLOR("#ADADAD"), BFONT(11), .clear)
        but.layer.cornerRadius = 5
        return but
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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
        
        tableView.register(DistanceChargeCell.self, forCellReuseIdentifier: "DistanceChargeCell")
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
        return tableView
        
    }()
    
    private lazy var editeView: DistanceEditeView = {
        let view = DistanceEditeView()
        
        view.clickSaveBlock = { [unowned self] _ in
            self.getData_Net()
        }
        
        return view
    }()

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Change distance limit"
    
    }

    
    override func setViews() {
        setUpUI()
        getData_Net()
    }
    
    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        

        backView.addSubview(selectBackView)
        selectBackView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 140, height: 30))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        selectBackView.addSubview(radiusBut)
        radiusBut.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        
        selectBackView.addSubview(postcodeBut)
        postcodeBut.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(selectBackView.snp.bottom).offset(20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(0)
            $0.bottom.equalToSuperview()
        }
        
        
        leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        radiusBut.addTarget(self, action: #selector(clickRaAction), for: .touchUpInside)
        postcodeBut.addTarget(self, action: #selector(clickPosAction), for: .touchUpInside)
    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickRaAction() {
        if feeType != "1" {
            feeType = "1"
            self.table.reloadData()
            if radiusDataArr.count != 0 {
                setDeliveryType_Net()
            }
            
        }
        
    }
    
    @objc private func clickPosAction() {
        if feeType != "2" {
            feeType = "2"
            self.table.reloadData()
            if postCodeDataArr.count != 0 {
                setDeliveryType_Net()
            }
        }
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if feeType == "1" {
                return radiusDataArr.count
            }
            if feeType == "2" {
                return postCodeDataArr.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceChargeCell") as! DistanceChargeCell
                
            let model = feeType == "1" ? radiusDataArr[indexPath.row] : postCodeDataArr[indexPath.row]
            cell.setCellData(model: model, type: feeType)
            cell.clickDeleteBlock = { [unowned self] (_) in
                
                //二次确认
                self.showSystemChooseAlert("Alert", "Delete it?", "YES", "NO") {
                    self.deleteData_Net(id: (self.feeType == "1" ? self.radiusDataArr[indexPath.row].id : self.postCodeDataArr[indexPath.row].id))
                }

            }
            
            cell.editeBlock = { [unowned self] (_) in
                //编辑
                
                let model = feeType == "1" ? radiusDataArr[indexPath.row] : postCodeDataArr[indexPath.row]
                editeView.feeType = feeType
                editeView.setEditeValueWith(milesOrPostcode: (feeType == "1" ? String(model.distance) : model.postCode), pound: String(model.amount), id: model.id)
                editeView.isEdite = true
                editeView.appearAction()
            }

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as! AddItemCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            editeView.isEdite = false
            editeView.feeType = feeType
            editeView.appearAction()
        }
    }
    
}

extension ChangeDistanceController {
    
    //MARK: - 网络请求
    private func getData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getDeliveryFeeListAndType().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.feeType = json["data"]["feeType"].stringValue
            var tarr: [DeliveryFeeModel] = []
            
            for jsonData in json["data"]["deliveryFeeList"].arrayValue {
                let model = DeliveryFeeModel()
                model.updateModel(json: jsonData)
                tarr.append(model)
            }
                
            self.radiusDataArr = tarr.filter { $0.type == "1" }
            self.postCodeDataArr = tarr.filter { $0.type == "2" }
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

    
    //删除一条
    func deleteData_Net(id: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteDeliveryFee(id: id).subscribe(onNext: { (json) in
            self.getData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    //设置配送方式
    func setDeliveryType_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setDeliveryType(type: feeType).subscribe(onNext: { json in
            HUD_MB.dissmiss(onView: self.view)
        }, onError: {error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
}



