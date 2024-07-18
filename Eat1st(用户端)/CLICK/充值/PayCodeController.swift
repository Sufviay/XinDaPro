//
//  PayCodeController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/15.
//

import UIKit
import RxSwift



class PayCodeController: BaseViewController {

    ///计时器
    var timer: Timer?
    var codeTimer: DispatchSourceTimer?
    
    private let bag = DisposeBag()
    
    var storeID: String = ""
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F6F6F6")
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 40, height: 55), byRoundingCorners: [.topLeft, .topRight], radii: 15)
        return view
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.isHidden = true
        return img
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
        lab.text = ""
        lab.isHidden = true
        return lab
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = ""
        return lab
    }()
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Membership"
        return lab
    }()

    
    
    private let txCodeImg: UIImageView = {
        let img = UIImageView()
//        
//        let m = LBXScanWrapper.createCode128(codeString: "aaaaaaaa", size: CGSize(width: R_W(290), height: SET_H(80, 290)), qrColor: .black, bkColor: .clear)
//        img.image = m
        return img
    }()
    
    private let txCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(17), .center)
        lab.text = ""
        return lab
    }()
    
    
    private let ewCodeImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let ewCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.text = ""
        return lab
    }()
    
    
    private let TCBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "APP Terms and Conditions", MAINCOLOR, SFONT(14), .clear)
        return but
    }()

    
    override func setNavi() {
        naviBar.headerBackColor = MAINCOLOR
        naviBar.leftImg = LOIMG("nav_back")
        naviBar.rightBut.isHidden = true
    }
    
    
    override func setViews() {
        setUpUI()
        loadData(isRepeat: false)
    }
    
    override func clickLeftButAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = MAINCOLOR
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(naviBar.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
        }
        
        backView.addSubview(TCBut)
        TCBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 30))
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalToSuperview()
        }
        
        
        backView.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        headView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        headView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        headView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalTo(numberLab)
            $0.right.equalTo(numberLab.snp.left).offset(-2)
        }
        
        backView.addSubview(txCodeImg)
        txCodeImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headView.snp.bottom).offset(45)
            $0.size.equalTo(CGSize(width: R_W(290), height: SET_H(80, 290)))
        }
        
        backView.addSubview(ewCodeImg)
        ewCodeImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(210), height: R_W(210)))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(txCodeImg.snp.bottom).offset(50)
        }
        
        backView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(headView.snp.bottom).offset(20)
        }
        
        backView.addSubview(txCodeLab)
        txCodeLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(txCodeImg.snp.bottom).offset(8)
        }
        
        backView.addSubview(ewCodeLab)
        ewCodeLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ewCodeImg.snp.bottom).offset(20)
        }
        
        TCBut.addTarget(self, action: #selector(clickTCAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickTCAction() {
        let webVC = ServiceController()
        webVC.titStr = "APP Terms and Conditions"
        webVC.webUrl = TCURL
        self.present(webVC, animated: true, completion: nil)
    }
    
    
    //MARK: - 定时相关
    private func startTimer(second: Double) {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: second, repeats: false, block: { [unowned self] (_) in
            //获取刷新的数据
            loadData(isRepeat: true)
        })
    }
    
    private func invalidateTimer() {
        print("定时结束")
        if timer != nil {
            timer!.invalidate()
            timer = nil
            print("invalidateTimer")
        }
    }
    
    
    private func loadData(isRepeat: Bool) {
        HUD_MB.loading("", onView: view)
        
        HTTPTOOl.getUserPayToken().subscribe(onNext: { [unowned self] (json) in
            let token = json["data"]["token"].stringValue
            let txImg = LBXScanWrapper.createCode128(codeString: token, size: CGSize(width: R_W(290), height: SET_H(80, 290)), qrColor: .black, bkColor: .clear)
            
            let ewImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: token, size: CGSize(width: R_W(210), height: R_W(210)), qrColor: .black, bkColor: .clear)
            txCodeImg.image = txImg
            ewCodeImg.image = ewImg
            
            txCodeLab.text = token
            //ewCodeLab.text = token
            
            nameLab.text = UserDefaults.standard.userName ?? ""
            
            if storeID != "" {
                numberLab.isHidden = false
                sImg.isHidden = false

                //请求充值余额
                HTTPTOOl.getUserRechargeAmount(storeID: storeID).subscribe(onNext: { [unowned self] (json2) in
                    HUD_MB.dissmiss(onView: view)
                    numberLab.text = D_2_STR(json2["data"]["amount"].doubleValue)
                }, onError: { [unowned self] (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
                }).disposed(by: bag)
            } else {
                HUD_MB.dissmiss(onView: view)
                numberLab.isHidden = true
                sImg.isHidden = true
            }
            
            
            startTimer(second: (json["data"]["timeout"].doubleValue == 0 ? 120 : json["data"]["timeout"].doubleValue))
            
            var s = json["data"]["timeout"].intValue == 0 ? 120 : json["data"]["timeout"].intValue
            
            codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
            codeTimer!.schedule(deadline: .now(), repeating: .milliseconds(1000))
 
            codeTimer!.setEventHandler {
                s -= 1
                DispatchQueue.main.async {
                    self.ewCodeLab.text = "Refresh in \(s) seconds"
                }
                if s == 0 {
                    self.codeTimer!.cancel()
                    self.codeTimer = nil
                }
            }
            codeTimer!.activate()
        
        }, onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }
    
    
    
    deinit {
        print("\(self.classForCoder)销毁了")
        invalidateTimer()
        codeTimer = nil
    }

}
