//
//  StoreFirstPageButCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/3/16.
//

import UIKit

class StoreFirstPageButCell: BaseTableViewCell {

    private var dataModel = StoreInfoModel()
    
    private var isDine: Bool = false
    
    var clickBlock: VoidStringBlock?
    
    private let plCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(13), .left)
        lab.text = "(456)"
        return lab
    }()
    
    
    private let deBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F5F5F5")
        //but.setCommentStyle(.zero, "", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let coBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F5F5F5")
        //but.setCommentStyle(.zero, "Collection", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let orderBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F5F5F5")
        //but.setCommentStyle(.zero, "Orders", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    private let bookingBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#F5F5F5")
        //but.setCommentStyle(.zero, "Orders", .white, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()

    
    private let deImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_wm")
        return img
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_zq")
        return img
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Collection"
        return lab
    }()

    
    private let orderImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_first")
        return img
    }()
    
    private let orderLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Orders"
        return lab
    }()
    
    
    private let bookingImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("book")
        return img
    }()
    
    private let bookingLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Booking"
        return lab
    }()
    

    
    override func setViews() {
        
        
        contentView.addSubview(deBut)
        deBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.height.equalTo(105)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalTo(contentView.snp.centerX).offset(-5)
        }
        
        contentView.addSubview(coBut)
        coBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-R_W(25))
            $0.height.equalTo(100)
            $0.top.equalTo(deBut)
            $0.left.equalTo(contentView.snp.centerX).offset(5)
        }

        
        contentView.addSubview(orderBut)
        orderBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.right.equalToSuperview().offset(-R_W(25))
            $0.height.equalTo(55)
            $0.top.equalTo(coBut.snp.bottom).offset(10)
        }
        
        
        contentView.addSubview(bookingBut)
        bookingBut.snp.makeConstraints {
            $0.size.equalTo(orderBut)
            $0.top.equalTo(orderBut.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }


        deBut.addSubview(deImg)
        deImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 35))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(22)
        }

        deBut.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }


        coBut.addSubview(coImg)
        coImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 25))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        }

        coBut.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }

        orderBut.addSubview(orderImg)
        orderImg.snp.makeConstraints {
            $0.right.equalTo(orderBut.snp.centerX).offset(-20)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalToSuperview()
        }

        orderBut.addSubview(orderLab)
        orderLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(orderImg.snp.right).offset(10)
        }
        
        
        bookingBut.addSubview(bookingImg)
        bookingImg.snp.makeConstraints {
            $0.right.equalTo(bookingBut.snp.centerX).offset(-20)
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.centerY.equalToSuperview()
        }

        bookingBut.addSubview(bookingLab)
        bookingLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(bookingImg.snp.right).offset(10)
        }
        

        orderBut.addTarget(self, action: #selector(clickOrderAction), for: .touchUpInside)
        deBut.addTarget(self, action: #selector(clickDeAction), for: .touchUpInside)
        coBut.addTarget(self, action: #selector(clickCoAction), for: .touchUpInside)
        //bookingBut.addTarget(self, action: #selector(clickBookingAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDeAction()  {

        //配送
        let menuVC = StoreMenuOrderController()
        menuVC.storeID = dataModel.storeID
        PJCUtil.currentVC()?.navigationController?.pushViewController(menuVC, animated: true)
        
    }
    
    @objc private func clickCoAction()  {
        //自取
        let menuVC = StoreMenuOrderController()
        menuVC.storeID = dataModel.storeID
        PJCUtil.currentVC()?.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    @objc private func clickOrderAction()  {
        if isDine {
            clickBlock?("dinein")
        } else {
            clickBlock?("order")
        }    
    }
    
    
//    @objc private func clickBookingAction() {
//        //预定
//        let nextVC = OccupyController()
//        nextVC.storeID = dataModel.storeID
//        nextVC.storeName = dataModel.name
//        nextVC.storeDes = dataModel.des
//        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
//        
//    }
    
    func setCellData(data: StoreInfoModel, isDinein : Bool, typeArr: [String]) {
        
        ///1外卖，2自取，3堂食
        self.dataModel = data
        isDine = isDinein
        if isDinein {
            orderLab.text = "Dine-in"
            //bookingBut.isHidden = false
        } else {
            orderLab.text = "Orders"
            //bookingBut.isHidden = true
        }
        
        if typeArr.contains("1") {
            //可以外卖
            deBut.isUserInteractionEnabled = true
            deImg.image = LOIMG("store_wm")
            deLab.textColor = HCOLOR("333333")
        } else {
            //不可外卖
            deBut.isUserInteractionEnabled = false
            deImg.image = LOIMG("store_wm_nusel")
            deLab.textColor = HCOLOR("999999")
        }
        
        if typeArr.contains("2") {
            //可以自取
            coBut.isUserInteractionEnabled = true
            coImg.image = LOIMG("store_zq")
            coLab.textColor = HCOLOR("333333")
        } else {
            //不可自取
            coBut.isUserInteractionEnabled = false
            coImg.image = LOIMG("store_zq_nusel")
            coLab.textColor = HCOLOR("999999")
        }
        
    }
    

}
