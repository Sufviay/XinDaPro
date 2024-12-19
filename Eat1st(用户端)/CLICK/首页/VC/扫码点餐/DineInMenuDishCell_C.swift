//
//  DineInMenuDishCell_C.swift
//  CLICK
//
//  Created by 肖扬 on 2024/5/26.
//

import UIKit

class DineInMenuDishCell_C: CollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var clickAddBlock: VoidBlock?
    
    private var tagArr: [DishTagsModel] = []
    
    private var dataModel = DishModel()
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = HCOLOR("#F7F7F7")
        return view
    }()
    
    let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    private let vatView: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(10), .center)
        lab.text = "VAT"
        lab.backgroundColor = MAINCOLOR
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 5
        return lab
    }()
    
    
    private let nameLab_C: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Spicy burger"
        lab.numberOfLines = 1
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let nameLab_E: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = "Spicy burger"
        lab.numberOfLines = 1
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(11), .left)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .left)
        lab.text = "4.8"
        return lab
    }()

    
    
    private let unUseImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("unUse")
        return img
    }()
    
    private let un_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(9), .left)
        return lab
    }()

    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DishTagCell.self, forCellWithReuseIdentifier: "DishTagCell")
        coll.register(BuyOneGiveOneTagCell.self, forCellWithReuseIdentifier: "BuyOneGiveOneTagCell")
        coll.isUserInteractionEnabled = false
        return coll
    }()
    
    private let vipImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("vipimg")
        return img
    }()
    
    
    private let vipPriceLab: UILabel = {
        let lab = UILabel()
        lab.textColor = HCOLOR("56370B")
        lab.textAlignment = .right
        lab.font = UIFont(name: "Helvetica-BoldOblique", size: 9)
        return lab
    }()
    
    
    private let oldPriceLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.isHidden = true
        return lab
    }()
    
    private let oldPriceLine: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#666666")
        return view
    }()
        
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.height.equalTo(goodsImg.snp.width)
        }
        
        goodsImg.addSubview(vatView)
        vatView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 30, height: 15))
            $0.right.equalToSuperview().offset(-2)
        }
        
        backView.addSubview(nameLab_C)
        nameLab_C.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalTo(goodsImg.snp.bottom).offset(5)
        }
        
        backView.addSubview(nameLab_E)
        nameLab_E.snp.makeConstraints {
            $0.left.right.equalTo(nameLab_C)
            $0.top.equalTo(nameLab_C.snp.bottom).offset(2)
        }
        
        
        backView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right).offset(1)
            $0.bottom.equalTo(s_lab.snp.bottom).offset(2)
        }
        
        
        backView.addSubview(oldPriceLab)
        oldPriceLab.snp.makeConstraints {
            $0.left.equalTo(s_lab)
            $0.bottom.equalTo(moneyLab.snp.top).offset(0)
        }
        
        oldPriceLab.addSubview(oldPriceLine)
        oldPriceLine.snp.makeConstraints {
            $0.left.right.centerY.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        backView.addSubview(vipImg)
        vipImg.snp.makeConstraints {
            $0.left.equalTo(s_lab)
            $0.bottom.equalTo(moneyLab.snp.top).offset(0)
            $0.height.equalTo(17)
            $0.width.equalTo(87)
        }
        
        vipImg.addSubview(vipPriceLab)
        vipPriceLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(0)
            $0.height.equalTo(13)
            $0.right.equalToSuperview().offset(-7)
        }
        
        
        goodsImg.addSubview(unUseImg)
        unUseImg.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.equalToSuperview()
        }
        
        unUseImg.addSubview(un_lab)
        un_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.bottom.equalToSuperview()
        }

        goodsImg.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(3)
            $0.height.equalTo(15)
            $0.bottom.equalToSuperview().offset(-3)
            $0.right.equalToSuperview().offset(-10)
        }

        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        goodsImg.addGestureRecognizer(tap)

        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction()  {
        clickAddBlock?("")
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tag = tagArr[indexPath.item]
        
        if tag.tagType == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
            cell.nameLab.text = tag.tagName
            
            if tagArr[indexPath.item].tagImg == "" {
                cell.setImage(img: nil)
            } else {
                //赋值图片
                let img = SDImageCache.shared.imageFromCache(forKey: tag.tagImg)
                if img == nil {
                    //下载图片
                    cell.setImage(img: nil)
                    self.downLoadImgage(url: tag.tagImg)
                } else {
                    cell.setImage(img: img)
                }
            }
            return cell
        }
        
        if tag.tagType == "2" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyOneGiveOneTagCell", for: indexPath) as! BuyOneGiveOneTagCell
            return cell
        }
        
        let cell = UICollectionViewCell()
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tag = tagArr[indexPath.item]
        
        if tag.tagType == "1" {
            let textW = tagArr[indexPath.item].tagName.getTextWidth(SFONT(11), 14)
                    
            if tagArr[indexPath.item].tagImg == "" {
                return CGSize(width: textW + 6, height: 14)
            } else {
                //从缓存中查找图片
                let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)

                if img == nil {
                    return CGSize(width: textW + 6, height: 14)
                }
                //根据图片计算宽度
                let img_W = (img!.size.width * 14) / img!.size.height
                return  CGSize(width: img_W + textW + 2 + 6, height: 14)
            }
        }
        
        if tag.tagType == "2" {
            return CGSize(width: 85, height: 15)
        }

        return CGSize.zero
        
    }
    
    
    
    //下载图片
    private func downLoadImgage(url: String) {
        SDWebImageDownloader.shared.downloadImage(with: URL(string: url)) { image, data, error, finished in
            
            SDImageCache.shared.store(image, forKey: url, toDisk: true)
            
            //判断图片
            if image != nil {
                
                //主线程刷新UI
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
                
            }
            
        }
    }
    
    
    
    func setCellData(model: DishModel, canBuy: Bool, isVip: Bool) {
        self.dataModel = model
        
        if !canBuy {
            self.un_lab.text = "Unavailable"
            self.unUseImg.isHidden = false
            self.goodsImg.isUserInteractionEnabled = false
        } else {
            self.un_lab.text = model.unAlbleMsg
            if model.isOn == "1" {
                self.unUseImg.isHidden = true
                self.goodsImg.isUserInteractionEnabled = true
            } else {
                self.unUseImg.isHidden = false
                self.goodsImg.isUserInteractionEnabled = false
            }
        }
        
        
        if model.vatType == "1" {
            vatView.isHidden = true
        }
        if model.vatType == "2" {
            vatView.isHidden = false
        }
        
        
        //设置是否启用
        if model.isOn == "1" {
            self.nameLab_C.textColor = FONTCOLOR
            self.nameLab_E.textColor = FONTCOLOR
            self.s_lab.textColor = HCOLOR("FB5348")
            self.moneyLab.textColor = HCOLOR("FB5348")
        } else {
            self.nameLab_C.textColor = HCOLOR("#AAAAAA")
            self.nameLab_E.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
        }
    
        
        
//        if isVip {
//            //是店铺的Vip
//            if model.isHaveVipPrice {
//                //菜品有VIP价格
//                vipImg.isHidden = true
//                vipPriceLab.text = ""
//                
//                oldPriceLab.isHidden = false
//                oldPriceLab.text = "£" + D_2_STR(model.price)
//                
//                moneyLab.text = D_2_STR(model.vipPrice)
//                
//            } else {
//                //没有会员价
//                vipImg.isHidden = true
//                vipPriceLab.text = ""
//                
//                oldPriceLab.isHidden = true
//                oldPriceLab.text = ""
//                
//                moneyLab.text = D_2_STR(model.price)
//            }
//            
//            
//        } else {
            
            //不是店铺的Vip 展示vip的价格
            if model.isHaveVipPrice {
                vipImg.isHidden = false
                vipPriceLab.text = "£" + D_2_STR(model.vipPrice)
                
                oldPriceLab.text = ""
                oldPriceLab.isHidden = true
                
                moneyLab.text = D_2_STR(model.price)

            } else {
                vipImg.isHidden = true
                vipPriceLab.text = ""
                
                oldPriceLab.text = ""
                oldPriceLab.isHidden = true
                
                moneyLab.text = D_2_STR(model.price)

            }
//        }
                
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab_C.text = model.name_CN
        self.nameLab_E.text = model.name_EN
        
        self.tagArr = model.tagList
        self.collection.reloadData()
    }

    

}
