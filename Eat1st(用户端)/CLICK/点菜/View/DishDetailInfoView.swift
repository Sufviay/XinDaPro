//
//  DishDetailInfoView.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/17.
//

import UIKit

class DishDetailInfoView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var tagArr: [DishTagsModel] = []
    
    var countBlock: VoidBlock?

    private let headImg: CustomImgeView = {
        let img = CustomImgeView()
        return img
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.12).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3

        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Spicy burger"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(13), .left)
        lab.text = "from"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .left)
        lab.text = "£4.8"
        return lab
    }()
    
    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
        lab.text = "£4.8"
        return lab
    }()
    
    private let disLine: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#999999")
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
    
    
    
    
        
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(13), .left)
        lab.text = "Ingredients: beef"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("allergen")
        return img
    }()
    

    private let gmyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = "Allergen: peanuts、peanuts、peanuts"
        return lab
    }()

    
    private lazy var selectView: CountSelectView = {
        let view = CountSelectView()
        view.canBeZero = false
        view.countBlock = { [unowned self] (count) in
            print(count as! Int)
            freeCountLab.text = "x\(count as! Int)"
            self.countBlock?(count as! Int)
        }
        return view
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
    
    
    
    private let giveOneBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFD645").withAlphaComponent(0.12)
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    private let freeMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(11), .left)
        lab.text = "£0.00"
        return lab
    }()
    
    private let freeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("free")
        return img
    }()
    
    private let freeCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(10), .right)
        lab.text = "x2"
        return lab
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

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(R_W(375) * (9/16))
            //$0.height.equalTo(SET_H(250, 375))
        }
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(headImg.snp.bottom).offset(-50)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(nameLab.snp.bottom).offset(3)
            $0.height.equalTo(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        backView.addSubview(vipImg)
        vipImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(collection.snp.bottom).offset(5)
            $0.height.equalTo(17)
            $0.width.equalTo(87)
        }
        
        vipImg.addSubview(vipPriceLab)
        vipPriceLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(0)
            $0.height.equalTo(13)
            $0.right.equalToSuperview().offset(-7)
        }
    
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(collection.snp.bottom).offset(30)
        }
    
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(tlab.snp.right).offset(5)
            $0.bottom.equalTo(tlab.snp.bottom).offset(2)
            //$0.top.equalTo(collection.snp.bottom).offset(28)
        }
        
        backView.addSubview(disMoneyLab)
        disMoneyLab.snp.makeConstraints {
            $0.centerY.equalTo(moneyLab)
            $0.left.equalTo(moneyLab.snp.right).offset(5)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.centerY.equalToSuperview()
        }
        
        backView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 36, height: 13))
            $0.centerY.equalTo(moneyLab)
            $0.left.equalTo(disMoneyLab.snp.right).offset(8)
        }
        
        disBackImg.addSubview(discountScaleLab)
        discountScaleLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        

        
        backView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(moneyLab)
        }

        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(moneyLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-90)
        }
        
        
        backView.addSubview(giveOneBackView)
        giveOneBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-60)
            $0.height.equalTo(24)
            $0.top.equalTo(desLab.snp.bottom).offset(8)
        }
        
        
        
        giveOneBackView.addSubview(freeMoneyLab)
        freeMoneyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(6)
        }
        
        giveOneBackView.addSubview(freeImg)
        freeImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 11))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(50)
        }
        
        giveOneBackView.addSubview(freeCountLab)
        freeCountLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
        }

        
        backView.addSubview(gmyLab)
        gmyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-70)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(gmyLab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setCellData(model: DishModel, selectCount: Int, canBuy: Bool, isVip: Bool)  {
       
        if canBuy {
            selectView.isHidden = false
            if model.isGiveOne {
                giveOneBackView.isHidden = false
                freeCountLab.text = "x\(selectCount)"
                
            } else {
                giveOneBackView.isHidden = true
            }
            
        } else {
            selectView.isHidden = true
            giveOneBackView.isHidden = true
        }
        
        if model.specification.count == 0 {
            self.tlab.text = "f"
            tlab.isHidden = true
        } else {
            self.tlab.text = "from"
            tlab.isHidden = false
        }
        
        if model.detailImgArr.count != 0 {
            self.headImg.setImage(imageStr: model.detailImgArr[0])
        }
        
        self.nameLab.text = model.name
        self.desLab.text = model.des
        self.selectView.count = selectCount
        self.gmyLab.text = "Allergen: " +  model.allergen
        
        self.tagArr = model.tagList//.filter{ $0.tagImg != "" }
        self.collection.reloadData()
        
        
        
        
        if model.isHaveVipPrice {
            
//            if isVip {
//                disBackImg.isHidden = true
//                discountScaleLab.text = ""
//                
//                disMoneyLab.isHidden = false
//                disMoneyLab.text = "£" + D_2_STR(model.price)
//                
//                vipImg.isHidden = true
//                vipPriceLab.text = ""
//                
//                moneyLab.text = "£" + D_2_STR(model.vipPrice)
//                
//                tlab.snp.remakeConstraints {
//                    $0.left.equalToSuperview().offset(10)
//                    $0.top.equalTo(collection.snp.bottom).offset(7)
//                }
//                
//            } else {
                vipImg.isHidden = false
                vipPriceLab.text = "£" + D_2_STR(model.vipPrice)
                
                if model.discountType == "2" {
                    self.moneyLab.text = "£" + D_2_STR(model.discountPrice)
                    self.disMoneyLab.text = "£" + D_2_STR(model.price)
                    self.discountScaleLab.text = "\(model.discountSale)%OFF"
                    self.disMoneyLab.isHidden = false
                    self.disBackImg.isHidden = false
                    
                } else {
                    self.moneyLab.text = "£" + D_2_STR(model.price)
                    self.disMoneyLab.text = ""
                    self.discountScaleLab.text = ""
                    self.disMoneyLab.isHidden = true
                    self.disBackImg.isHidden = true
                }

                tlab.snp.remakeConstraints {
                    $0.left.equalToSuperview().offset(10)
                    $0.top.equalTo(collection.snp.bottom).offset(25)
                }
//            }
            
        } else {
            
            vipImg.isHidden = true
            vipPriceLab.text = ""
            
            
            if model.discountType == "2" {
                self.moneyLab.text = "£" + D_2_STR(model.discountPrice)
                self.disMoneyLab.text = "£" + D_2_STR(model.price)
                self.discountScaleLab.text = "\(model.discountSale)%OFF"
                self.disMoneyLab.isHidden = false
                self.disBackImg.isHidden = false
                
            } else {
                self.moneyLab.text = "£" + D_2_STR(model.price)
                self.disMoneyLab.text = ""
                self.discountScaleLab.text = ""
                self.disMoneyLab.isHidden = true
                self.disBackImg.isHidden = true
            }

            tlab.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(collection.snp.bottom).offset(5)
            }

        }
        
//        
//        
//        if model.discountType == "2" {
//            self.moneyLab.text = "£" + D_2_STR(model.discountPrice)
//            self.disMoneyLab.text = "£" + D_2_STR(model.price)
//            self.discountScaleLab.text = "\(model.discountSale)%OFF"
//            self.disMoneyLab.isHidden = false
//            self.disBackImg.isHidden = false
//            
//        } else {
//            self.moneyLab.text = "£" + D_2_STR(model.price)
//            self.disMoneyLab.text = ""
//            self.discountScaleLab.text = ""
//            self.disMoneyLab.isHidden = true
//            self.disBackImg.isHidden = true
//        }

    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
        
        let tag = tagArr[indexPath.item]
        
        if tag.tagType == "1" {
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

        return UICollectionViewCell()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tag = tagArr[indexPath.item]
        
        if tag.tagType == "1" {
            let textW = tag.tagName.getTextWidth(SFONT(11), 14)
                    
            if tag.tagImg == "" {
                return CGSize(width: textW + 6, height: 14)
            } else {
                //从缓存中查找图片
                let img = SDImageCache.shared.imageFromCache(forKey: tag.tagImg)

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

    
}
