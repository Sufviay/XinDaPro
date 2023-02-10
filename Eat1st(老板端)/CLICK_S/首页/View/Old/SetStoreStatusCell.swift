//
//  SetStoreStatusCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit

class SetStoreStatusCell: BaseTableViewCell {
    
    var clickDSWBlock: VoidBlock?
    
    var clickCSWBlock: VoidBlock?
    
    
    private let backView1: UIView = {
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
    
    
    private let backView2: UIView = {
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
        
        view.isHidden = true
        
        return view
    }()


    private let openBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 10
        but.setCommentStyle(.zero, "Open", .white, SFONT(14), HCOLOR("#EFEFEF"))
        return but
    }()
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 10
        but.setCommentStyle(.zero, "Close", .white, SFONT(14), MAINCOLOR)
        return but
    }()
    
    private let currentLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.text = "Current status:"
        return lab
    }()

    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .left)
        lab.text = "Close"
        return lab
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Collection"
        return lab
    }()

    private let deSw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = MAINCOLOR
        return sw
    }()
    
    private let coSw: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = MAINCOLOR
        return sw
    }()
    
    
    
    
    override func setViews() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        
        contentView.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(120)
        }
        
        contentView.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(backView1.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        backView1.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(27)
        }
        
        backView1.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-27)
        }
        
        backView1.addSubview(deSw)
        deSw.snp.makeConstraints {
            $0.centerY.equalTo(deLab)
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 50, height: 25))
        }
        
        backView1.addSubview(coSw)
        coSw.snp.makeConstraints {
            $0.centerY.equalTo(coLab)
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(CGSize(width: 50, height: 25))
        }
        
        backView2.addSubview(currentLab)
        currentLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView2.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.centerY.equalTo(currentLab)
            $0.left.equalTo(currentLab.snp.right).offset(5)
        }
        
        backView2.addSubview(openBut)
        openBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(60)
            $0.height.equalTo(45)
            $0.right.equalTo(backView2.snp.centerX).offset(-5)
        }
        
        backView2.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(60)
            $0.height.equalTo(45)
            $0.left.equalTo(backView2.snp.centerX).offset(5)
        }

//        openBut.addTarget(self, action: #selector(clickOpenAction), for: .touchUpInside)
//        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        deSw.addTarget(self, action: #selector(clickDeSwAction), for: .touchUpInside)
        coSw.addTarget(self, action: #selector(clickCoSwAction), for: .touchUpInside)
        
    }
    
//    @objc func clickOpenAction() {
//        if self.openType != "0" {
//            self.clickOpenBlock?("0")
//        }
//    }
//
//
//    @objc func clickCloseAction() {
//        if self.openType != "1" {
//            self.clickOpenBlock?("1")
//        }
//
//    }
//
    
    @objc func clickDeSwAction() {
        
        if self.deSw.isOn {
            clickDSWBlock?("1")
        } else {
            clickDSWBlock?("2")
        }
    
    }
    
    @objc func clickCoSwAction() {
        
        if self.coSw.isOn {
            clickCSWBlock?("1")
        } else {
            clickCSWBlock?("2")
        }
    }
    
    func setCellData(model: StoreOpeningModel) {
        
        self.deSw.isOn = model.z_de_status
        self.coSw.isOn = model.z_co_status
        
//        self.psType = model.deliverSupport
//        self.openType = model.status
//
//        if model.status == "0" {
//            self.currentLab.text = "Current status:  Open"
//        } else {
//            self.currentLab.text = "Current status:  Close"
//        }
//
//        //1：外送、2：自取、3：外送和自取
//        if model.deliverSupport == "1" {
//            self.deSw.isOn = true
//            self.coSw.isOn = false
//        }
//        if model.deliverSupport == "2" {
//            self.deSw.isOn = false
//            self.coSw.isOn = true
//        }
//        if model.deliverSupport == "3" {
//            self.deSw.isOn = true
//            self.coSw.isOn = true
//        }
    }
}
