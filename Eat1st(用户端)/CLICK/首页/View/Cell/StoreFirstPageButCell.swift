//
//  StoreFirstPageButCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/3/16.
//

import UIKit

class StoreFirstPageButCell: BaseTableViewCell {

    private var dataModel = StoreInfoModel()
    
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
    
    private let deImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_wm")
        return img
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(15), .center)
        lab.text = "Delivery".localized
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
    

    
    override func setViews() {
        
        
        contentView.addSubview(deBut)
        deBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(105)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalTo(contentView.snp.centerX).offset(-10)
        }
        
        contentView.addSubview(coBut)
        coBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(100)
            $0.top.equalTo(deBut)
            $0.left.equalTo(contentView.snp.centerX).offset(10)
        }

        
        contentView.addSubview(orderBut)
        orderBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(55)
            $0.top.equalTo(coBut.snp.bottom).offset(20)
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
        

        orderBut.addTarget(self, action: #selector(clickOrderAction), for: .touchUpInside)
        deBut.addTarget(self, action: #selector(clickDeAction), for: .touchUpInside)
        coBut.addTarget(self, action: #selector(clickCoAction), for: .touchUpInside)

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
        let nextVC =  OrderListController()
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    

}
