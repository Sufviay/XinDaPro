//
//  OrderDetailGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/12/19.
//

import UIKit

class OrderDetailGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var tagArr: [DishTagsModel] = []
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        return img
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.numberOfLines = 0
        lab.text = "Dish Name 1"
        return lab
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(15), .right)
        lab.text = "10.9"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .right)
        lab.text = "x2"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "options,options,options,options"
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
        return coll
    }()
    
    
    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "£4.8"
        return lab
    }()
    
    private let disLine: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#666666")
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

    
    private let freeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("free_d")
        return img
    }()
    

    

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 55))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }

        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-110)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.height.equalTo(15)
            $0.top.equalTo(nameLab.snp.bottom).offset(2)
            $0.right.equalToSuperview().offset(-110)
        }

        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalTo(nameLab).offset(0)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
        
        backView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.top.equalTo(moneyLab.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(18)
            $0.right.equalToSuperview().offset(-110)
        }
        
        
        backView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 13))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(moneyLab.snp.bottom)
        }
        
        disBackImg.addSubview(discountScaleLab)
        discountScaleLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(disMoneyLab)
        disMoneyLab.snp.makeConstraints {
            $0.centerY.equalTo(disBackImg)
            $0.right.equalTo(disBackImg.snp.left).offset(-2)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
        }
        
        
        backView.addSubview(freeImg)
        freeImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 36, height: 13))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(moneyLab.snp.bottom)
        }

    }
    
    
   

    func setOrderCellData(model: OrderDishModel) {
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des_E
        self.countLab.text = "x\(model.count)"
        self.tagArr = model.tagList//.filter{ $0.tagImg != "" }
        
        if !model.isGive {
            
            freeImg.isHidden = true
            
            if model.discountType == "2" {
                //有优惠
                self.moneyLab.text = D_2_STR(model.discountPrice)
                self.disMoneyLab.text = "£\(model.subFee)"
                self.discountScaleLab.text = "\(model.discountSale)%OFF"
                self.disMoneyLab.isHidden = false
                self.disBackImg.isHidden = false
                
                
            } else {
                //无优惠
                self.moneyLab.text = D_2_STR(model.subFee)
                self.disMoneyLab.text = ""
                self.discountScaleLab.text = ""
                self.disMoneyLab.isHidden = true
                self.disBackImg.isHidden = true

            }
            
        } else {
            
            freeImg.isHidden = false
            moneyLab.text = "0"
            self.disMoneyLab.text = ""
            self.discountScaleLab.text = ""
            self.disMoneyLab.isHidden = true
            self.disBackImg.isHidden = true
        }
            
        self.collection.reloadData()

    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tag = tagArr[indexPath.item]
        if tag.tagType == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
            cell.nameLab.text = tag.tagName
            if tag.tagImg == "" {
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
                return CGSize(width: textW, height: 14)
            } else {
                //从缓存中查找图片
                let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)

                if img == nil {
                    return CGSize(width: textW, height: 14)
                }
                //根据图片计算宽度
                let img_W = (img!.size.width * 14) / img!.size.height
                return  CGSize(width: img_W + textW + 2 , height: 14)
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

}
