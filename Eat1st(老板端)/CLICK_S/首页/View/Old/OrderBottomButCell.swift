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

    

    
    ///拒接
    private let juJieBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Reject", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()
    
    ///接单
    private let jieDanBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Accept", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    ///已出餐
    private let chuCanBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Ready", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    ///已配送
    private let peiSongBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    ///已送达
    private let songDaBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Finish", .white, SFONT(14), MAINCOLOR)
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

    
    ///以取餐
    private let quCanBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Finish", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    ///查看投诉
    private let checkTSBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Dispose", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()



    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.height.equalTo(1)
//            $0.top.equalToSuperview()
//        }
        
        contentView.addSubview(jieDanBut)
        jieDanBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
            $0.left.equalTo(contentView.snp.centerX).offset(8)
        }
        
        contentView.addSubview(juJieBut)
        juJieBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.right.equalTo(contentView.snp.centerX).offset(-8)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(chuCanBut)
        chuCanBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        contentView.addSubview(peiSongBut)
        peiSongBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(songDaBut)
        songDaBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
            $0.left.equalTo(contentView.snp.centerX).offset(8)
        }
        
        contentView.addSubview(quCanBut)
        quCanBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(daoHangBut)
        daoHangBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.right.equalTo(contentView.snp.centerX).offset(-8)
            $0.bottom.equalToSuperview().offset(-10)
        }
    
        
        contentView.addSubview(checkTSBut)
        checkTSBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-10)
        }
           
        jieDanBut.addTarget(self, action: #selector(clickJieDanAction), for: .touchUpInside)
        juJieBut.addTarget(self, action: #selector(clickJuJieAction), for: .touchUpInside)
        peiSongBut.addTarget(self, action: #selector(clickPeiSongAction), for: .touchUpInside)
        chuCanBut.addTarget(self, action: #selector(clickChuCanAction), for: .touchUpInside)
        songDaBut.addTarget(self, action: #selector(clickSongDaAction), for: .touchUpInside)
        quCanBut.addTarget(self, action: #selector(clickQuCanAction), for: .touchUpInside)
        checkTSBut.addTarget(self, action: #selector(clickCheckTSAction), for: .touchUpInside)
        daoHangBut.addTarget(self, action: #selector(clickDaoHangAction), for: .touchUpInside)
    }
    
    
    // 1待接单。 接单、拒接单
    // 4拒接单  拒接原因
    // 5已接单  已出餐、以配送
    //6 已出餐  7 配送中   已送达、以取餐
    //8已取餐 9已送达   无按钮
    //10 已评价  评价内容
    //11投诉未处理。 处理按钮。投诉原因
    //12投诉已处理。 投诉内容。 投诉结果
    
    
    // 6待接单。 接单、拒接单
    // 5拒接单  拒接原因
    // 7已接单  已出餐按钮
    // 8已出餐 配货员开始配送按钮
    // 9配送中  无按钮
    // 10 完成。 没有评价 没有投诉 没有按钮
    // 评价展示评价内容 时间 星级
    // 投诉了 展示查看投诉按钮
    
     //1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
    
    
    func setCellData(type: String, model: OrderModel) {
        
        self.dataModel = model
        
        //待接单 拒接 接单
        if model.status == .pay_success {
            self.juJieBut.isHidden = false
            self.jieDanBut.isHidden = false
            
            self.songDaBut.isHidden = true
            self.daoHangBut.isHidden = true
            self.peiSongBut.isHidden = true
            
            self.quCanBut.isHidden = true
            self.chuCanBut.isHidden = true
            self.checkTSBut.isHidden = true
            
        }
        
        //已接单。 已出餐
        if model.status == .takeOrder {
            self.juJieBut.isHidden = true
            self.jieDanBut.isHidden = true
            
            self.songDaBut.isHidden = true
            self.daoHangBut.isHidden = true
            self.peiSongBut.isHidden = true
            
            self.quCanBut.isHidden = true
            self.chuCanBut.isHidden = false
            self.checkTSBut.isHidden = true

        }
        
        //已出餐。如果是外卖的订单展示开始配送按钮。 如果是自取订单展示已取餐按钮
        if model.status == .cooked {
            if type == "1" {
                //外卖
                self.juJieBut.isHidden = true
                self.jieDanBut.isHidden = true
                
                self.songDaBut.isHidden = true
                self.daoHangBut.isHidden = true
                self.peiSongBut.isHidden = false
                
                self.quCanBut.isHidden = true
                self.chuCanBut.isHidden = true
                self.checkTSBut.isHidden = true
            }
            
            if type == "2" {
                //自取
                self.juJieBut.isHidden = true
                self.jieDanBut.isHidden = true
                
                self.songDaBut.isHidden = true
                self.daoHangBut.isHidden = true
                self.peiSongBut.isHidden = true
                
                self.quCanBut.isHidden = false
                self.daoHangBut.isHidden = true

                self.chuCanBut.isHidden = true
                self.checkTSBut.isHidden = true
            }
        }
        
        //配送中 已送达按钮
        if model.status == .delivery_ing {
            self.juJieBut.isHidden = true
            self.jieDanBut.isHidden = true
            
            self.songDaBut.isHidden = false
            self.daoHangBut.isHidden = false
            self.peiSongBut.isHidden = true
            
            self.quCanBut.isHidden = true
            self.chuCanBut.isHidden = true
            self.checkTSBut.isHidden = true
        }
        
        //完成 投诉处理按钮
        if model.status == .finished  && model.tsStatus == "2" {
            self.juJieBut.isHidden = true
            self.jieDanBut.isHidden = true
            
            self.songDaBut.isHidden = true
            self.daoHangBut.isHidden = true
            self.peiSongBut.isHidden = true
            
            self.quCanBut.isHidden = true
            self.chuCanBut.isHidden = true
            self.checkTSBut.isHidden = false
        }
            
    }
    
    @objc private func clickJuJieAction() {
        clickBlock?("jujie")
        
    }
    
    @objc private func clickJieDanAction() {
        clickBlock?("jiedan")
        
    }
    
    @objc private func clickPeiSongAction() {
        clickBlock?("peisong")
    }
    
    @objc func clickChuCanAction() {
        clickBlock?("chucan")
    }
    
    
    @objc private func clickSongDaAction() {
        clickBlock?("songda")
    }
    
    @objc func clickQuCanAction() {
        clickBlock?("qucan")
    }
    
    @objc func clickCheckTSAction() {
        clickBlock?("ts")
    }
    
    
    @objc func clickDaoHangAction() {
        PJCUtil.goDaohang(lat: dataModel.lat, lng: dataModel.lng)
    }

    

}
