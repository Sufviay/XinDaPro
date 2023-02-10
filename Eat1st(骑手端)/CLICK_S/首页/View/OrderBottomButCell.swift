//
//  OrderBottomButCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/1.
//

import UIKit

class OrderBottomButCell: BaseTableViewCell {
    
    
    private var dataModel = OrderModel()
    
    
    var clickBlock: VoidBlock?
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("EEEEEE")
        return view
    }()


    
    ///无法送达按钮
    private let unSuccessBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Unsuccessful", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()

    ///完成
    private let completeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Complete", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    ///开始按钮
    private let startBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Start", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    ///导航按钮
    private let daoHangBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Navigate", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()


    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        
        contentView.addSubview(completeBut)
        completeBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.height.equalTo(40)
            $0.width.equalTo((S_W - 60) / 3)

        }
        
        contentView.addSubview(unSuccessBut)
        unSuccessBut.snp.makeConstraints {
            $0.right.equalTo(completeBut.snp.left).offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.height.equalTo(40)
            $0.width.equalTo((S_W - 60) / 3)

        }
        
        contentView.addSubview(daoHangBut)
        daoHangBut.snp.makeConstraints {
            $0.right.equalTo(unSuccessBut.snp.left).offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.height.equalTo(40)
            $0.width.equalTo((S_W - 60) / 3)

        }
        
        contentView.addSubview(startBut)
        startBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(100))
            $0.right.equalToSuperview().offset(-R_W(100))
            $0.top.equalToSuperview().offset(0)
            $0.height.equalTo(40)
        }
    
        daoHangBut.addTarget(self, action: #selector(clickDaoHangAction), for: .touchUpInside)
        startBut.addTarget(self, action: #selector(clickStartAction), for: .touchUpInside)
        completeBut.addTarget(self, action: #selector(clickCompleteAction), for: .touchUpInside)
        unSuccessBut.addTarget(self, action: #selector(clickUnSuccessfulAction), for: .touchUpInside)
        
    }
    
    
    
    func setCellData(model: OrderModel) {
        
        self.dataModel = model
        
        //已派单
        if model.status == .paiDan {
            self.startBut.isHidden = false
            self.unSuccessBut.isHidden = true
            self.completeBut.isHidden = true
            self.daoHangBut.isHidden = true
        }
        
        
        //配送中
        if model.status == .delivery_ing {
            self.startBut.isHidden = true
            self.unSuccessBut.isHidden = false
            self.completeBut.isHidden = false
            self.daoHangBut.isHidden = false
        }
                
    }
    
    @objc private func clickStartAction() {
        clickBlock?("start")
        
    }
    
    @objc private func clickUnSuccessfulAction() {
        clickBlock?("unsuccessful")
        
    }

    
    @objc func clickCompleteAction() {
        clickBlock?("complete")
    }
        
    
    @objc func clickDaoHangAction() {
        PJCUtil.goDaohang(lat: dataModel.lat, lng: dataModel.lng)
    }

    

}
