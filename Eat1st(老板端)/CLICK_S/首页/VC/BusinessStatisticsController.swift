//
//  BusinessStatisticsController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/4.
//

import UIKit
import RxSwift

class BusinessStatisticsController: BaseViewController{

    ///筛选类型
    private var SXType: String = "weeks"
    
    
    
    private let bag = DisposeBag()
    
    ///1：现金、2：卡、3：现金和卡
    private var payType: String = "" {
        didSet {
            if payType == "2" {
                self.onlineSw.isOn = true
                self.cashSw.isOn = false
            }
            if payType == "1" {
                self.cashSw.isOn = true
                self.onlineSw.isOn = false
            }
            if payType == "3" {
                self.cashSw.isOn = true
                self.onlineSw.isOn = true
            }
        }
    }

    
    private let backView1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    
    private let backView2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private let totaySalesView: SalesDataView = {
        let view = SalesDataView()
        view.totalLab.text = "Today"
        return view
    }()
    
    private let weekSalesView: SalesDataView = {
        let view = SalesDataView()
        view.totalLab.text = "Last week"
        return view
    }()
    
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
            print(str as! String)
            self.SXType = str as! String
        }
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (str) in
            let date = str as! String
            print(date)
            self.queryData_Net(type: self.SXType, date: date)
        }
        
        return view
    }()
    
    private let customSalesView: SalesDataView = {
        let view = SalesDataView()
        view.line.isHidden = true
        view.totalLab.text = "Total amount"
        return view
    }()
    
 
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Accept cash payment"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Accept card payment"
        return lab
    }()
    
    
    private let cashSw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = MAINCOLOR
        return sw
    }()
    
    private let onlineSw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = MAINCOLOR
        return sw
    }()
    

    

    override func setViews() {
        setUpUI()
        self.loadData_Net()
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Business statistics"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("F7F7F7")
        

        view.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.height.equalTo(330)
        }
        

        backView1.addSubview(totaySalesView)
        totaySalesView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backView1.addSubview(weekSalesView)
        weekSalesView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(95)
            $0.top.equalTo(totaySalesView.snp.bottom)
        }
        
        backView1.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(30)
            $0.top.equalTo(weekSalesView.snp.bottom).offset(20)
        }
        
        backView1.addSubview(customSalesView)
        customSalesView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(filtrateView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        
        view.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(backView1.snp.bottom).offset(10)
            $0.height.equalTo(120)
        }
        
        backView2.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(22)
        }
        
        backView2.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-22)
        }
        
        backView2.addSubview(cashSw)
        cashSw.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView2.addSubview(onlineSw)
        onlineSw.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-10)
        }
        
        onlineSw.addTarget(self, action: #selector(clickOnlineAction), for: .touchUpInside)
        cashSw.addTarget(self, action: #selector(clickCashAciton), for: .touchUpInside)
        
    }
    
    
    @objc private func clickCashAciton() {
        if self.cashSw.isOn {
            let cash = "1"
            let card = self.onlineSw.isOn ? "1" : "2"
            self.setPayWay_Net(cash: cash, card: card)
            
        } else {
            if self.onlineSw.isOn {
                
                let cash = "2"
                let card = "1"
                self.setPayWay_Net(cash: cash, card: card)
            } else {
                HUD_MB.showWarnig("At least one!", onView: self.view)
                self.cashSw.isOn = true
            }
        }
    }
    
    @objc private func clickOnlineAction() {
        if self.onlineSw.isOn {
            let card = "1"
            let cash = self.cashSw.isOn ? "1" : "2"
            self.setPayWay_Net(cash: cash, card: card)
        } else {
            if self.cashSw.isOn {
                let card = "2"
                let cash = "1"
                self.setPayWay_Net(cash: cash, card: card)
            } else {
                HUD_MB.showWarnig("At least one!", onView: self.view)
                self.onlineSw.isOn = true
            }
        }
    }
    
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getBusinessSale().subscribe(onNext: { (json) in
            
            self.totaySalesView.setMoneyData(t_money: json["data"]["dayTotal"].stringValue, cashMoney: json["data"]["dayCash"].stringValue, cardMoney: json["data"]["dayCard"].stringValue)
            self.weekSalesView.setMoneyData(t_money: json["data"]["lastWeekTotal"].stringValue, cashMoney: json["data"]["lastWeekCash"].stringValue, cardMoney: json["data"]["lastWeekCard"].stringValue)
            self.getPayWay_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)

    }
    
    private func getPayWay_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getPayWay().subscribe(onNext: { (json) in
            self.cashSw.isOn = json["data"]["cash"].stringValue == "1" ? true : false
            self.onlineSw.isOn = json["data"]["card"].stringValue == "1" ? true : false
            
            
            let year = DateTool.getDateComponents(date: Date()).year!
            let week = DateTool.getWeekCountBy(year: year)
            let range = DateTool.getWeekRangeDateBy(year: year, week: week)
            let firstStr = range.components(separatedBy: "~").first ?? ""
            let dateStr = "\(year)-\(firstStr)"

            self.queryData_Net(type: self.SXType, date: dateStr)
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func queryData_Net(type: String, date: String)  {
        
        var dateType: String = ""
        if type == "weeks" {
            dateType = "3"
        }
        if type == "day" {
            dateType = "4"
        }
        if type == "years" {
            dateType = "1"
        }
        if type == "month" {
            dateType = "2"
        }
        
        HUD_MB.loading("", onView: view)
        HTTPTOOl.queryStoreBussiness(type: dateType, date: date).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.customSalesView.setMoneyData(t_money: json["data"]["totalAmount"].stringValue, cashMoney: json["data"]["cashAmount"].stringValue, cardMoney: json["data"]["cardAmount"].stringValue)
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    
    private func setPayWay_Net(cash: String, card: String) {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.changePayWay(card: card, cash: cash).subscribe(onNext: { (json) in
            self.getPayWay_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
}




