//
//  MenuDishCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/21.
//

import UIKit

class MenuDishCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var dataModel = DishModel()
    
    ///菜品类型。dis 菜。add附加。fre赠品
    private var dataType: PageType = .dish
    
    var clickMoreBlock: VoidStringBlock?

    private var tagArr: [String] = ["beef", "beef"]
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_4
        return view
    }()
    
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.numberOfLines = 0
        lab.text = "Sesame Prawn on Toast"
        return lab
    }()
    
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        lab.text = "芝麻大蝦吐司"
        return lab
    }()
    
    
    
    private let moreBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_more"), for: .normal)
        return but
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TXT_1, .left)
        lab.text = "£ 23.63"
        return lab
    }()
    
//    private let disCountImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("dish_discount")
//        return img
//    }()
    
    private let kuCunLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_4, TXT_2, .left)
        lab.text = "Stock: 9 "
        return lab
    }()
    
    
    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_2, .left)
        lab.text = "£4.8"
        return lab
    }()
    
    private let disLine: UIView = {
        let view = UIView()
        view.backgroundColor = TXTCOLOR_2
        return view
    }()
    
    private let disBackImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("disback")
        return img
    }()
    
    private let discountScaleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFF8EB"), BFONT(7), .center)
        lab.text = "25%OFF"
        return lab
    }()

    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_4, TIT_3, .right)
        lab.text = "Sold out indefinitely".local
        return lab
    }()
    
    
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DishTagCell.self, forCellWithReuseIdentifier: "DishTagCell")
        return coll
    }()
    
    
    
    private lazy var alertView: MoreAlert = {
        let alert = MoreAlert()
        alert.clickBlock = { [unowned self] (type) in
            self.clickMoreBlock?(type)
        }
        return alert
    }()
    
    

    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-200)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-200)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
        contentView.addSubview(moreBut)
        moreBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(kuCunLab)
        kuCunLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab2.snp.bottom).offset(3)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(kuCunLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(disMoneyLab)
        disMoneyLab.snp.makeConstraints {
            $0.centerY.equalTo(moneyLab)
            $0.left.equalTo(moneyLab.snp.right).offset(10)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 36, height: 13))
            $0.centerY.equalTo(moneyLab)
            $0.left.equalTo(disMoneyLab.snp.right).offset(5)
        }
        
        disBackImg.addSubview(discountScaleLab)
        discountScaleLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        contentView.addSubview(collection)
//        collection.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-70)
//            $0.top.equalTo(moneyLab.snp.bottom).offset(10)
//            $0.height.equalTo(15)
//        }
        
//        contentView.addSubview(disCountImg)
//        disCountImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 15, height: 15))
//            $0.centerY.equalTo(nameLab1)
//            $0.left.equalToSuperview().offset(S_W - 90)
//        }
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.right.equalTo(moreBut.snp.left)
        }
        
        moreBut.addTarget(self, action: #selector(clickMoreAction(sender:)), for: .touchUpInside)
    }
    
    
    @objc private func clickMoreAction(sender: UIButton) {
        
        print(sender.frame)
        
        let cret = sender.convert(sender.frame, to: PJCUtil.currentVC()?.view)
        
        print(cret)
        
        switch dataType {
        case .seach_edit:
            alertView.alertType = .dish
        case .search_onoff:
            alertView.alertType = .onoff
        case .dish:
            alertView.alertType = .dish
        case .additional:
            alertView.alertType = .additional
            alertView.statusType = dataModel.statusID
        case .gift:
            alertView.alertType = .gift
        case .combo:
            alertView.alertType = .combo
        }
        
        alertView.tap_H = cret.minY
        alertView.appearAction()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
        cell.tagLab.text = tagArr[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let str = tagArr[indexPath.item]
        let w = str.getTextWidth(BFONT(10), 15) + 20
        return CGSize(width: w, height: 15)
    }
        
    func setCellData(model: DishModel, type: PageType) {
        dataModel = model
        self.dataType = type
        self.nameLab1.text = model.name1
        self.nameLab2.text = model.name2
        
        //self.tagArr = model.tags
        self.collection.reloadData()
        
        if tagArr.count == 0 {
            self.collection.isHidden = true
        } else {
            self.collection.isHidden = false
        }
        
        //不是堂食
        if model.discountType == "2" {
            //有优惠
            self.moneyLab.text = "£ \(model.discountPrice)"
            if model.sellType == "2" {
                self.disMoneyLab.text = "£\(model.dinePrice)"
            } else {
                self.disMoneyLab.text = "£\(model.deliPrice)"
            }
            self.discountScaleLab.text = "\(model.discountSale)%OFF"
//            self.disCountImg.isHidden = false
            self.disBackImg.isHidden = false
            self.disMoneyLab.isHidden = false
        } else {
            
            if model.sellType == "2" {
                self.moneyLab.text = "£ \(model.dinePrice)"
            } else {
                self.moneyLab.text = "£ \(model.deliPrice)"
            }
            
            self.disMoneyLab.text = ""
            self.discountScaleLab.text = ""
//            self.disCountImg.isHidden = true
            self.disBackImg.isHidden = true
            self.disMoneyLab.isHidden = true
        }

        
        if model.limitBuy == "1" {
            self.kuCunLab.text = ""
        } else {
            self.kuCunLab.text = "Stock: \(model.limitNum)"
        }
        
        if model.statusID == "1" {
            //上架
            statusLab.text = "In stock".local
            statusLab.textColor = TXTCOLOR_5
        }
        if model.statusID == "2" {
            //永久下架
            statusLab.text = "Sold out indefinitely".local
            statusLab.textColor = TXTCOLOR_4
        }
        if model.statusID == "3" {
            //當天下架
            statusLab.text = "Sold out today".local
            statusLab.textColor = TXTCOLOR_4
        }
    }

//    override func reSetFrame() {
//                
//        //获取UIlabel的行数
//        let h = nameLab1.text!.getTextHeigh(BFONT(13), S_W - 120)
//        let lineNum = Int(ceil(h / nameLab1.font.lineHeight))
//
//        if lineNum > 1 {
//            disCountImg.snp.remakeConstraints {
//                $0.size.equalTo(CGSize(width: 15, height: 15))
//                $0.centerY.equalTo(nameLab1)
//                $0.left.equalToSuperview().offset(S_W - 90)
//            }
//        } else {
//            
//            let w = nameLab1.text!.getTextWidth(BFONT(13), nameLab1.font.lineHeight)
//            disCountImg.snp.remakeConstraints {
//                $0.size.equalTo(CGSize(width: 15, height: 15))
//                $0.centerY.equalTo(nameLab1)
//                $0.left.equalToSuperview().offset(w + 30)
//            }
//        }
//    }

}



class DishTagCell: UICollectionViewCell {
    

    let tagLab: UILabel = {
        let lab = UILabel()
        lab.layer.cornerRadius = 3
        lab.layer.borderColor = HCOLOR("#FEC501").cgColor
        lab.layer.borderWidth = 1
        lab.setCommentStyle(HCOLOR("FEC501"), BFONT(10), .center)
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
