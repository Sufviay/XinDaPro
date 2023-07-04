//
//  OrderDetailButCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/13.
//

import UIKit


class ButtonModel: NSObject {
    var name: String = ""
    var imgStr: String = ""

    init(name: String, imageStr: String) {
        self.name = name
        self.imgStr = imageStr
        super.init()
    }
    
    
}


class OrderDetailButCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    ///点击按钮
    var clickBlock: VoidBlock?

    private var buttonArr: [ButtonModel] = []
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    
    private lazy var butColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        
        let W = (S_W - 40) / 4
        layout.itemSize = CGSize(width: W , height: 60)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsVerticalScrollIndicator = false
        coll.register(ButtonCollectionCell.self, forCellWithReuseIdentifier: "ButtonCollectionCell")
//        coll.register(PicImgCell.self, forCellWithReuseIdentifier: "PicImgCell")
        return coll
    }()
    
   
    
    
    
    override func setViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(butColleciton)
        butColleciton.snp.makeConstraints {
            $0.left.edges.equalToSuperview()
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionCell", for: indexPath) as! ButtonCollectionCell
        cell.setCellData(model: buttonArr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = buttonArr[indexPath.item]
        clickBlock?(model.name)
    }
    
    
    func setCellData(model: OrderDetailModel) {
        self.buttonArr.removeAll()
        ///订单状态  1待支付,2支付中,3支付失败,4用户取消,5商家取消,6系统取消,7商家拒单,8支付成功,9已接单,10已出餐,11已派单,12配送中,13已完成
        
        //联系店铺
        let contectBut = ButtonModel(name: "Contact shop", imageStr: "order_contect")
        let helpBut = ButtonModel(name: "Help", imageStr: "order_help")
        
        ///待支付
        if model.status == .pay_wait  {
            
            //联系店铺  帮助 取消 支付
            let cancelBut = ButtonModel(name: "Cancel", imageStr: "order_cancel")
            let payBut = ButtonModel(name: "To pay for", imageStr: "order_pay")
            self.buttonArr = [contectBut, helpBut, cancelBut, payBut]
        }
        
        if model.status == .pay_ing {
            let payBut = ButtonModel(name: "To pay for", imageStr: "order_pay")
            self.buttonArr = [contectBut, helpBut, payBut]
        }
        
        if model.status == .pay_fail {
            let cancelBut = ButtonModel(name: "Cancel", imageStr: "order_cancel")
            let payBut = ButtonModel(name: "To pay for", imageStr: "order_pay")
            self.buttonArr = [contectBut, helpBut, cancelBut, payBut]
        }
        
        if model.status == .user_cancel {
            self.buttonArr = [contectBut, helpBut]
        }
        
        if model.status == .shops_cancel {
            self.buttonArr = [contectBut, helpBut]
        }
        
        if model.status == .system_cancel {
            self.buttonArr = [contectBut, helpBut]
        }
        
        if model.status == .reject {
            self.buttonArr = [contectBut, helpBut]
        }
        
        //支付成功
        if model.status == .pay_success {
            //联系店铺  帮助 取消
            let cancelBut = ButtonModel(name: "Cancel", imageStr: "order_cancel")
            self.buttonArr = [contectBut, helpBut, cancelBut]
        }
        
        if model.status == .takeOrder {
            self.buttonArr = [contectBut, helpBut]
        }

        if model.status == .cooked {
//            ///问题 少个确认收货按钮
//            if model.type == "2" {
//                //自取有确认按钮
//
//                let confirmBut = ButtonModel(name: "Confirm", imageStr: "order_confirm")
//
//                self.buttonArr = [contectBut, helpBut, confirmBut]
//            } else {
                self.buttonArr = [contectBut, helpBut]
//            }
        }
        
        if model.status == .paiDan {
            self.buttonArr = [contectBut, helpBut]
        }
        
        if model.status == .delivery_ing {
            self.buttonArr = [contectBut, helpBut]
        }
        
        if model.status == .finished {
            
            let againBut = ButtonModel(name: "Order it again", imageStr: "order_again")
            
            if model.pjStatus == "1" && model.tsStauts == "1" {
                let evaluteBut = ButtonModel(name: "Review", imageStr: "order_evaluation")
                //let afterBut = ButtonModel(name: "After sales", imageStr: "order_after")
                
                if model.type == "3" {
                    self.buttonArr = [contectBut, helpBut, evaluteBut]
                } else {
                    self.buttonArr = [contectBut, helpBut, evaluteBut, againBut]
                }
                
            } else {
                if model.type == "3" {
                    self.buttonArr = [contectBut, helpBut]
                } else {
                    self.buttonArr = [contectBut, helpBut, againBut]
                }
            }
            
        }
        
        self.butColleciton.reloadData()
    
        
    }
        
}



class ButtonCollectionCell: UICollectionViewCell {
    
    
    private let picImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), SFONT(10), .center)
        lab.text = "order it again"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }

        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.bottom.equalTo(nameLab.snp.top).offset(-8)
            $0.centerX.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellData(model: ButtonModel) {
        self.nameLab.text = model.name
        self.picImg.image = LOIMG(model.imgStr)
    }
    
}
