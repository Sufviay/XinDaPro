//
//  HaveButtonOrderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/17.
//

import UIKit

class HaveButtonOrderCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {


    var clickBlock: VoidBlock?
    
    private var dataModel = OrderListModel()

    private var imgArr: [String] = [] {
        didSet {
            self.collection.reloadData()
        }
    }

    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_logo")
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .left)
        lab.text = "name"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "Completed"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .right)
        lab.text = "10.9"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "x2"
        return lab
    }()
    
    private let orderIDLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .left)
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .right)
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()
    
    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(16), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    
    private let goImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("GO")
        return img
    }()

    
    
    private let co_W: CGFloat = (S_W - 125 - 15) / 4
    
    
    
    private lazy var collection: GestureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: co_W , height: co_W)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = GestureCollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.isUserInteractionEnabled = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsHorizontalScrollIndicator = false
        coll.register(ImgCollectionCell.self, forCellWithReuseIdentifier: "ImgCollectionCell")
        return coll
        
    }()
    
    
    //取消
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 5
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()
    
    
    private let t_cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", MAINCOLOR, SFONT(14), .white)
        but.layer.cornerRadius = 5
        but.layer.borderWidth = 1
        but.layer.borderColor = MAINCOLOR.cgColor
        return but
    }()
    
    //支付按钮
    private let payBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "To pay for", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
    }()
    
    
    
    //确认按钮
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
    }()
    
    
    //评价
    private let evaluationBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Review", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
    }()
    
    //再来一单按钮
    private let buyAgainBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Order it again ", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
    }()
    
    //再来一单按钮
    private let t_buyAgainBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Order it again ", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 5
        return but
    }()

    

    override func setViews() {
        self.contentView.backgroundColor = .white
        
        
//        contentView.addSubview(backView)
//        backView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(-10)
//        }
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-95)
            $0.height.equalTo(co_W)
            $0.top.equalToSuperview().offset(80)
        }
        
        contentView.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        
        contentView.addSubview(goImg)
        goImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 20))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.top.equalTo(typeLab.snp.bottom).offset(10)
        }

        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalTo(statusLab.snp.left).offset(-20)
            $0.top.equalTo(typeLab.snp.bottom).offset(10)
        }
                
        contentView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.right.equalTo(nameLab.snp.left).offset(-3)
            $0.centerY.equalTo(nameLab)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(collection.snp.top).offset(10)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-3)
            $0.right.equalTo(moneyLab.snp.left).offset(-2)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.top.equalTo(moneyLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(orderIDLab)
        orderIDLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(collection.snp.bottom).offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(orderIDLab)
            $0.right.equalToSuperview().offset(-10)
        }
        
            
        contentView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 75, height: 30))
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(t_cancelBut)
        t_cancelBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 75, height: 30))
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview().offset(-120)
        }

        
        contentView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 75, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(buyAgainBut)
        buyAgainBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 30))
            //$0.right.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-120)
            $0.bottom.equalToSuperview().offset(-20)
            
        }
        
        contentView.addSubview(t_buyAgainBut)
        t_buyAgainBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 30))
            $0.right.equalToSuperview().offset(-10)
            //$0.right.equalToSuperview().offset(-120)
            $0.bottom.equalToSuperview().offset(-20)
            
        }

        
        contentView.addSubview(evaluationBut)
        evaluationBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 30))
            $0.bottom.equalToSuperview().offset(-20)
            //$0.right.equalToSuperview().offset(-140)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(payBut)
        payBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 30))
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        
        evaluationBut.addTarget(self, action: #selector(clickEvaluationAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        t_cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        payBut.addTarget(self, action: #selector(clickPayAction), for: .touchUpInside)
        buyAgainBut.addTarget(self, action: #selector(clickBuyAgainAction), for: .touchUpInside)
        t_buyAgainBut.addTarget(self, action: #selector(clickBuyAgainAction), for: .touchUpInside)
    }
    
    
    @objc private func clickCancelAction() {
        clickBlock?("qx")
    }
    
    
    @objc private func clickConfirmAction() {
        clickBlock?("qr")
        
    }
    
    @objc private func clickEvaluationAction() {
        clickBlock?("pj")
        
    }
    
    @objc private func clickPayAction() {
        clickBlock?("zf")
    }
    
    @objc private func clickBuyAgainAction() {
        clickBlock?("zlyd")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "ImgCollectionCell", for: indexPath) as! ImgCollectionCell
        cell.picImg.sd_setImage(with: URL(string: imgArr[indexPath.item]), placeholderImage: HOLDIMG)
        return cell
    }

    
    func setCellData(model: OrderListModel) {
        
                
        self.dataModel = model
        self.imgArr = model.dishImgArr
        self.nameLab.text = model.name
        self.statusLab.text = model.statusStr
        self.countLab.text = "x\(model.dishCount)"
        self.moneyLab.text = D_2_STR(model.amountTotal)
        self.orderIDLab.text = "#" + model.orderID
        self.timeLab.text = model.createTime
        
        if model.prizeStatus {
            self.goImg.isHidden = false
        } else {
            self.goImg.isHidden = true
        }
        
        if model.type == "1" {
            typeLab.text = "Delivery"
        }
        if model.type == "2" {
            typeLab.text = "Collection"
        }
        if model.type == "3" {
            typeLab.text = "Dine-in"
        }
        
        
        let status_W = model.statusStr.getTextWidth(BFONT(15), 20)
        self.statusLab.snp.updateConstraints {
            $0.width.equalTo(status_W + 5)
        }
        
        
        if model.status == .pay_wait || model.status == .pay_fail {
            ///待支付
            self.cancelBut.isHidden = true
            self.payBut.isHidden = false
            self.t_cancelBut.isHidden = false
            self.evaluationBut.isHidden = true
            self.confirmBut.isHidden = true
            self.buyAgainBut.isHidden = true
            t_buyAgainBut.isHidden = true
        }
        
        if model.status == .pay_ing {
            ///支付中
            self.cancelBut.isHidden = true
            self.payBut.isHidden = false
            self.t_cancelBut.isHidden = true
            self.evaluationBut.isHidden = true
            self.confirmBut.isHidden = true
            self.buyAgainBut.isHidden = true
            t_buyAgainBut.isHidden = true
        }

        
        if model.status == .pay_success {
            ///支付成功（待接单）
            self.cancelBut.isHidden = false
            self.payBut.isHidden = true
            self.t_cancelBut.isHidden = true
            self.evaluationBut.isHidden = true
            self.confirmBut.isHidden = true
            self.buyAgainBut.isHidden = true
            t_buyAgainBut.isHidden = true
        }
        
//        if model.status == .cooked && model.type == "2" {
//            ///已出餐 如果是自取订单展示确认按钮
//            self.cancelBut.isHidden = true
//            self.payBut.isHidden = true
//            self.t_cancelBut.isHidden = true
//            self.evaluationBut.isHidden = true
//            self.confirmBut.isHidden = false
//            self.buyAgainBut.isHidden = true
//        }
        
//        if model.status == .delivery_ing {
//            //配送中
//            self.cancelBut.isHidden = true
//            self.payBut.isHidden = true
//            self.t_cancelBut.isHidden = true
//            self.evaluationBut.isHidden = true
//            self.confirmBut.isHidden = false
//        }
        
        
        if model.status == .finished {
            self.cancelBut.isHidden = true
            self.payBut.isHidden = true
            self.t_cancelBut.isHidden = true
            self.confirmBut.isHidden = true
            
            if model.type == "3" {
                self.buyAgainBut.isHidden = true
                t_buyAgainBut.isHidden = true
            } else {
                self.buyAgainBut.isHidden = false
                t_buyAgainBut.isHidden = false
            }

            if model.plaintStatus == "1" && model.evaluateStatus == "1" {
                //完成的订单 当 未投诉  未评价 展示评价按钮
                self.evaluationBut.isHidden = false
                buyAgainBut.isHidden = false
                t_buyAgainBut.isHidden = true
            } else {
                self.evaluationBut.isHidden = true
                buyAgainBut.isHidden = true
                t_buyAgainBut.isHidden = false
                
            }

        }
        
//        if model.status == .finished && model.plaintStatus == "1" && model.evaluateStatus == "1" {
//            //完成的订单 当 未投诉  未评价 展示评价按钮
//            self.cancelBut.isHidden = true
//            self.payBut.isHidden = true
//            self.t_cancelBut.isHidden = true
//            self.evaluationBut.isHidden = false
//            self.confirmBut.isHidden = true
//        }

    }

}
