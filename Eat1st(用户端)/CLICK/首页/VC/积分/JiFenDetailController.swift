//
//  JiFenDetailController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/8.
//

import UIKit
import RxSwift
import MJRefresh

class JiFenDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let bag = DisposeBag()
    private var page: Int = 1
    
    private var dataArr: [JiFenDetalModel] = []
    
    ///1全部。2过期
    private var type: String = "1" {
        didSet {
            if type == "1" {
                self.line1.isHidden = false
                self.line2.isHidden = true
                self.allBut.setTitleColor(.black, for: .normal)
                self.expBut.setTitleColor(HCOLOR("999999"), for: .normal)
            }
            if type == "2" {
                self.line2.isHidden = false
                self.line1.isHidden = true
                self.allBut.setTitleColor(HCOLOR("999999"), for: .normal)
                self.expBut.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = self.table.bounds
        return view
    }()

    
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jf_head")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let tImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jf_money")
        return img
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(18), .center)
        lab.text = "Point Center"
        return lab
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    private let tLab1: UILabel = {
        let lab = UILabel()
        //lab.setCommentStyle(.white, BFONT(18), .left)
        lab.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        lab.textColor = .white
        lab.text = "MY POINT"
        return lab
    }()
    
    private let jifenLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.init(name: "Helvetica-BoldOblique", size: 50)
        lab.textColor = .white
        lab.text = ""
        lab.textAlignment = .left
        return lab
    }()
    
//    private let tView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 12
//        view.backgroundColor = HCOLOR("#FFEAC5")
//        view.isHidden = false
//        return view
//    }()
    
    private let expireLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.init(name: "Helvetica-BoldOblique", size: 16)
        lab.textColor = .white
        lab.isHidden = true
        lab.text = "1000 TO EXPIRE"
        lab.textAlignment = .center
        return lab
    }()
    
    
    private let allBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "DETAIL OF POINT", .black, BFONT(15), .clear)
        return but
    }()
    
    private let expBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "ABOUT TO EXPIRE", HCOLOR("#999999"), BFONT(15), .clear)
        return but
    }()

    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()

    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.isHidden = true
        return view
    }()

    
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(JiFenDetailCell.self, forCellReuseIdentifier: "JiFenDetailCell")
        return tableView
    }()
    
    
    
    
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }
    
    
    private func setUpUI() {
        self.naviBar.isHidden = true
        
        view.backgroundColor = HCOLOR("#F7F7F7")
        
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(SET_H(290, 375))
        }
        
        headImg.addSubview(tImg)
        tImg.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalTo(R_W(115))
            $0.height.equalTo(SET_H(148, 115))
            $0.bottom.equalToSuperview().offset(-R_H(35))
        }
    
        
        view.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalToSuperview().offset(statusBarH)
            $0.centerX.equalToSuperview()
        }
        
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(titlab)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        
        headImg.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-155)
        }
        
        headImg.addSubview(jifenLab)
        jifenLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
            $0.top.equalTo(tLab1.snp.bottom)
        }
        
//        headImg.addSubview(tView)
//        tView.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 155, height: 24))
//            $0.top.equalTo(jifenLab.snp.bottom)
//            $0.left.equalToSuperview().offset(20)
//        }
        
        headImg.addSubview(expireLab)
        expireLab.snp.makeConstraints {
            $0.left.equalTo(jifenLab)
            $0.top.equalTo(jifenLab.snp.bottom)
        }
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
            $0.top.equalTo(headImg.snp.bottom).offset(-55)
        }
        
        
        backView.addSubview(allBut)
        allBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(35)
        }
        
        backView.addSubview(expBut)
        expBut.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(35)
        }
    
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 3))
            $0.centerX.equalTo(allBut)
            $0.bottom.equalTo(allBut)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 3))
            $0.centerX.equalTo(expBut)
            $0.bottom.equalTo(expBut)
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(55)
        }
        
        table.mj_header = MJRefreshNormalHeader() { [unowned self] in
            self.loadData_Net()
        }
        
        table.mj_footer = MJRefreshBackNormalFooter() { [unowned self] in
            self.loadDataMore_Net()
        }

        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        allBut.addTarget(self, action: #selector(clickAllAction), for: .touchUpInside)
        expBut.addTarget(self, action: #selector(clickExpAction), for: .touchUpInside)
    }
    
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickAllAction() {
        if type != "1" {
            self.type = "1"
            self.loadData_Net()
        }
        
    }
    
    @objc private func clickExpAction() {
        if type != "2" {
            self.type = "2"
            self.loadData_Net()
        }
    }
    
    
}




extension JiFenDetailController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JiFenDetailCell") as! JiFenDetailCell
        cell.setCellData(model: dataArr[indexPath.row], type: self.type)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataArr[indexPath.row].orderID != "" {
            let nextVC = OrderDetailController()
            nextVC.orderID = dataArr[indexPath.row].orderID
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    

}


extension JiFenDetailController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        //获取积分信息
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getJiFenCount().subscribe(onNext: { (json) in
            self.jifenLab.text = json["data"]["pointsNum"].stringValue
            let gq_jifen = json["data"]["expireNum"].intValue
            if gq_jifen != 0 {
                self.expireLab.isHidden = false
            } else {
                self.expireLab.isHidden = true
            }
            self.expireLab.text = "\(gq_jifen) TO EXPIRE"
            
            //获取积分明细
            HTTPTOOl.getJiFenDetailList(page: 1, type: self.type).subscribe(onNext: { (json) in
                
                HUD_MB.dissmiss(onView: self.view)
                self.page = 2
                var tArr: [JiFenDetalModel] = []
                
                for jsondata in json["data"].arrayValue {
                    let model = JiFenDetalModel()
                    model.updateModel(json: jsondata)
                    tArr.append(model)
                }
                self.dataArr = tArr
                if self.dataArr.count == 0 {
                    self.table.addSubview(self.noDataView)
                } else {
                    self.noDataView.removeFromSuperview()
                }

                self.table.reloadData()
                self.table.mj_header?.endRefreshing()
                self.table.mj_footer?.resetNoMoreData()

            }, onError: { (error) in
                self.table.mj_header?.endRefreshing()
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
            
        }, onError: { (error) in
            self.table.mj_header?.endRefreshing()
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func loadDataMore_Net() {
        HTTPTOOl.getJiFenDetailList(page: page, type: type).subscribe(onNext: { (json) in
            
            if json["data"].arrayValue.count == 0 {
                self.table.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
                for jsonData in json["data"].arrayValue {
                    let model = JiFenDetalModel()
                    model.updateModel(json: jsonData)
                    self.dataArr.append(model)
                }
                self.table.reloadData()
                self.table.mj_footer?.endRefreshing()
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            self.table.mj_footer?.endRefreshing()
        }).disposed(by: self.bag)
        
    }
    
}

