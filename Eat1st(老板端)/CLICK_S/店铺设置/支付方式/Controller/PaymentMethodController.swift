//
//  PaymentMethodController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/28.
//
import UIKit
import RxSwift

class PaymentMethodController: HeadBaseViewController {
    
    private let bag = DisposeBag()
    //数据model
    private var dataModel = ReportModel()
    
    ///现金方式 1开 2关
    private var cashWay: String = "" {
        didSet {
            if cashWay == "1" {
                self.cashBut.setImage(LOIMG("slider_on_b"), for: .normal)
            }
            if cashWay == "2" {
                self.cashBut.setImage(LOIMG("slider_off_b"), for: .normal)
            }
        }
    }
    ///卡方式 1开 2关
    private var cardWay: String = "" {
        didSet {
            if cardWay == "1" {
                self.onLineBut.setImage(LOIMG("slider_on_b"), for: .normal)
            }
            if cardWay == "2" {
                self.onLineBut.setImage(LOIMG("slider_off_b"), for: .normal)
            }

        }
    }
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    private let todayLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(17), .left)
        lab.text = "Today"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(18), .left)
        lab.text = "£"
        return lab
    }()
    
    private let mlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(25), .left)
        lab.text = "0.00"
        return lab
    }()
    
    private let cashImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_cash")
        return img
    }()
    
    private let posImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_pos")
        return img
    }()

    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_card")
        return img
    }()
    
    private let cashLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Cash"
        return lab
    }()
    
    private let posLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Pos"
        return lab
    }()
    
    private let cardLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Card"
        return lab
    }()

    private let cashNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "£ 0.00"
        return lab
    }()
    
    private let posNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "£ 0.00"
        return lab
    }()
    
    private let cardNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "£ 0.00"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()

    private let sImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("week_tag")
        return img
    }()
    
    private let sImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("week_tag")
        return img
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(16), .left)
        lab.text = "Accept cash payment"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(16), .left)
        lab.text = "Accept online payment"
        return lab
    }()

    private let cashBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_off_b"), for: .normal)
        return but
    }()
    
    private let onLineBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_off_b"), for: .normal)
        return but
    }()

    
    
    
    


    

    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Payment Method"

    }
    
    override func setViews() {
        setUpUI()
        getPayData_Net()
    }
    
    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(todayLab)
        todayLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(35)
        }

        backView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(75)
        }
        
        backView.addSubview(mlab)
        mlab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right).offset(5)
            $0.bottom.equalTo(s_lab).offset(3)
        }
        
        backView.addSubview(cashImg)
        cashImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(125)
            $0.left.equalToSuperview().offset(30)
        }
        
        backView.addSubview(posImg)
        posImg.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.left.equalToSuperview().offset(S_W / 3 + 30)
        }
        
        backView.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.left.equalToSuperview().offset(S_W / 3 * 2 + 30)
        }
        
        backView.addSubview(cashLab)
        cashLab.snp.makeConstraints {
            $0.centerY.equalTo(cashImg)
            $0.left.equalTo(cashImg.snp.right).offset(5)
        }
        
        backView.addSubview(posLab)
        posLab.snp.makeConstraints {
            $0.centerY.equalTo(posImg)
            $0.left.equalTo(posImg.snp.right).offset(5)
        }
        
        backView.addSubview(cardLab)
        cardLab.snp.makeConstraints {
            $0.centerY.equalTo(cardImg)
            $0.left.equalTo(cardImg.snp.right).offset(5)
        }
    
        backView.addSubview(cashNumLab)
        cashNumLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.left.equalTo(cashImg)
        }
        
        backView.addSubview(posNumLab)
        posNumLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.left.equalTo(posImg)
        }
        
        backView.addSubview(cardNumLab)
        cardNumLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.left.equalTo(cardImg)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalToSuperview().offset(195)
        }
        
        backView.addSubview(sImg1)
        sImg1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(line.snp.bottom).offset(30)
            
        }
        
        backView.addSubview(sImg2)
        sImg2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(line.snp.bottom).offset(80)
        }
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerY.equalTo(sImg1)
            $0.left.equalToSuperview().offset(52)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerY.equalTo(sImg2)
            $0.left.equalToSuperview().offset(52)
        }
        
        backView.addSubview(cashBut)
        cashBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalTo(sImg1)
        }
        
        backView.addSubview(onLineBut)
        onLineBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalTo(sImg2)
        }

        
        self.leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        self.cashBut.addTarget(self, action: #selector(clickCashAciton), for: .touchUpInside)
        self.onLineBut.addTarget(self, action: #selector(clickCardAciton), for: .touchUpInside)
    }
    
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func clickCashAciton() {
        if cashWay == "1" {
            cashWay = "2"
        } else {
            cashWay = "1"
        }
        setPayData_Net()
    }
    
    
    @objc private func clickCardAciton() {
        if cardWay == "1" {
            cardWay = "2"
        } else {
            cardWay = "1"
        }
        setPayData_Net()
    }

}

extension PaymentMethodController {
    //MARK: - 网络请求
    
    private func loadData_Net() {
        let dateStr: String = Date().getString("yyyy-MM-dd")
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getLiveReportingData(date: dateStr, end: "").subscribe(onNext: { (json) in
            self.dataModel.updateModel(json: json["data"])
            self.getPayData_Net()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    private func getPayData_Net() {
        HTTPTOOl.getPaymentMethod().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.cardWay = json["data"]["card"].stringValue
            self.cashWay = json["data"]["cash"].stringValue
            self.mlab.text = String(format: "%.2f", self.dataModel.orderSum_All)
            self.cardNumLab.text = String(format: "£ %.2f", self.dataModel.cardOrderSum_All)
            self.cashNumLab.text = String(format: "£ %.2f", self.dataModel.cashOrderSum_All)
            self.posNumLab.text = String(format: "£ %.2f", self.dataModel.posOrderSum_All)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    private func setPayData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.setPaymentMethod(card: cardWay, cash: cashWay).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}
