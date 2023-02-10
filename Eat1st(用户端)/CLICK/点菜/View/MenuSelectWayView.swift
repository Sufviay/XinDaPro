//
//  MenuSelectWayView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/13.
//

import UIKit

class MenuSelectWayView: UIView {
    
    var clickCheckPSBlock: VoidBlock?
    var clickBlock: VoidBlock?
    
    // 1 配送  2 自取
    private var type: String = ""

    private let de_But: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery", FONTCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let co_But: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Collection", MAINCOLOR, BFONT(14), .clear)
        return but
    }()
    
    private let deline: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    private let coline: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
//    private let psMoneyLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, SFONT(13), .left)
//        //lab.text = "delivery fee £4.8-£4.8"
//        return lab
//    }()
    
//    private let checkPSBut: UIButton = {
//        let but = UIButton()
//        but.setImage(LOIMG("s_about"), for: .normal)
//        return but
//    }()
    
//    private let qsLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
//        //lab.text = "no min. order"
//        return lab
//    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), SFONT(12), .right)
        lab.text = ""
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        de_But.isHidden = true
        co_But.isHidden = true
        deline.isHidden = true
        coline.isHidden = true
        
        
        self.addSubview(de_But)
        de_But.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(7)
        }
        
        self.addSubview(co_But)
        co_But.snp.makeConstraints {
            $0.centerY.equalTo(de_But)
            $0.left.equalTo(de_But.snp.right).offset(20)
        }
        
        self.addSubview(deline)
        deline.snp.makeConstraints {
            $0.centerX.equalTo(de_But)
            $0.top.equalTo(de_But.snp.bottom).offset(0)
            $0.size.equalTo(CGSize(width: 35, height: 2))
        }
        
        self.addSubview(coline)
        coline.snp.makeConstraints {
            $0.centerX.equalTo(co_But)
            $0.top.equalTo(co_But.snp.bottom).offset(0)
            $0.size.equalTo(CGSize(width: 35, height: 2))
        }
        
        
        
//        self.addSubview(psMoneyLab)
//        psMoneyLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.bottom.equalToSuperview().offset(-10)
//        }
//
//        self.addSubview(checkPSBut)
//        checkPSBut.snp.makeConstraints {
//            $0.centerY.equalTo(psMoneyLab)
//            $0.left.equalTo(psMoneyLab.snp.right).offset(5)
//        }
//
//        self.addSubview(qsLab)
//        qsLab.snp.makeConstraints {
//            $0.centerY.equalTo(psMoneyLab)
//            $0.right.equalToSuperview().offset(-10)
//        }
        
        self.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(de_But)
            $0.right.equalToSuperview().offset(-10)
        }
        
        de_But.addTarget(self, action: #selector(clickDeAction), for: .touchUpInside)
        co_But.addTarget(self, action: #selector(clickCoAction), for: .touchUpInside)
                
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickDeAction() {
        print("aaaa")
        if self.type != "1" {
            clickBlock?("1")
        }
    }
    
    @objc private func clickCoAction() {
        print("bbbb")
        if type != "2" {
            clickBlock?("2")
        }
    }
    

    @objc private func clickCheckPSFee() {
        self.clickCheckPSBlock?("")
    }
    
    
    func setData(model: StoreInfoModel)  {
        
        de_But.isHidden = false
        co_But.isHidden = false
        deline.isHidden = true
        coline.isHidden = true
        


        
        //可配送 可自取
        if model.deStatus == "1" && model.coStatus == "1" {
            de_But.setTitle("Delivery", for: .normal)
            co_But.setTitle("Collection", for: .normal)
            de_But.isEnabled = true
            co_But.isEnabled = true
            
        }
        //可配送 不可自取
        if model.deStatus == "1" && model.coStatus == "2" {
            de_But.setTitle("Delivery", for: .normal)
            co_But.setTitle("No collection", for: .normal)
            de_But.setTitleColor(FONTCOLOR, for: .normal)
            co_But.setTitleColor(HCOLOR("#999999"), for: .normal)
            de_But.isEnabled = false
            co_But.isEnabled = false
            deline.isHidden = false
            coline.isHidden = true

        }
        //不可配送 可自取
        if model.deStatus == "2" && model.coStatus == "1" {
            de_But.setTitle("No delivery", for: .normal)
            co_But.setTitle("Collection", for: .normal)
            de_But.setTitleColor(HCOLOR("#999999"), for: .normal)
            co_But.setTitleColor(FONTCOLOR, for: .normal)
            de_But.isEnabled = false
            co_But.isEnabled = false
            deline.isHidden = true
            coline.isHidden = false

        }
        //不可配送 不可自取
        if model.deStatus == "2" && model.coStatus == "2" {
            de_But.setTitle("Closed", for: .normal)
            co_But.setTitle("Closed", for: .normal)
            de_But.setTitleColor(FONTCOLOR, for: .normal)
            co_But.setTitleColor(FONTCOLOR, for: .normal)
            de_But.isEnabled = false
            co_But.isEnabled = false
            co_But.isHidden = true
            deline.isHidden = false
            coline.isHidden = true

        }
        
        
        
//        checkPSBut.isHidden = false
//        self.qsLab.text = model.minCharge
        
//        if model.maxDelivery == 0 {
//            if model.minDelivery == 0 {
//                //没有起送费
//                self.psMoneyLab.text = "No delivery fee"
//                self.psMoneyLab.textColor = HCOLOR("#666666")
//                self.checkPSBut.isHidden = true
//            } else {
//                //设置的配送费
//                self.psMoneyLab.text = "Delivery £\(model.minDelivery)"
//                self.psMoneyLab.textColor = HCOLOR("#666666")
//                self.checkPSBut.isHidden = true
//            }
//        } else {
//            self.psMoneyLab.text = "Delivery from £\(model.minDelivery)-£\(model.maxDelivery)"
//            self.psMoneyLab.textColor = MAINCOLOR
//            self.checkPSBut.isHidden = false
//        }
        
    }
    
    func setButStyle(type: String, model: StoreInfoModel) {
        self.type = type
        if model.deStatus == "1" && model.coStatus == "1" {
            //配送
            if type == "1" {
                self.de_But.setTitleColor(FONTCOLOR, for: .normal)
                self.deline.isHidden = false
                self.co_But.setTitleColor(MAINCOLOR, for: .normal)
                self.coline.isHidden = true
                self.timeLab.text = "Delivers in \(model.deMin)-\(model.deMax) mins"
            }
            
            //自取
            if type == "2" {
                self.de_But.setTitleColor(MAINCOLOR, for: .normal)
                self.deline.isHidden = true
                self.co_But.setTitleColor(FONTCOLOR, for: .normal)
                self.coline.isHidden = false
                self.timeLab.text = "Collect in \(model.coMin)-\(model.coMax) mins"
            }
        }
        
        if model.deStatus == "1" && model.coStatus == "2" {
            //可配送 不可自取
            self.timeLab.text = "Delivers in \(model.deMin)-\(model.deMax) mins"
        }
        
        if model.deStatus == "2" && model.coStatus == "1" {
            //不可配送 可自取
            self.timeLab.text = "Collect in \(model.coMin)-\(model.coMax) mins"
        }
        
        if model.deStatus == "2" && model.coStatus == "2" {
            //关闭状态
            self.timeLab.text = ""
        }
        
    }
}
