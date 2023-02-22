//
//  OrderGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit



class OrderGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    

    private var tagArr: [DishTagsModel] = []
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
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
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .right)
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
    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .right)
        lab.text = "FREE"
        return lab
    }()
    
    private let freeCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("666666"), SFONT(14), .right)
        lab.text = "x1"
        return lab
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
            $0.right.equalToSuperview().offset(-70)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.height.equalTo(14)
            $0.top.equalTo(nameLab.snp.bottom).offset(0)
            $0.right.equalToSuperview().offset(-70)
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
            $0.top.equalTo(nameLab.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-60)
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
        
        
        backView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(goodsImg.snp.centerY).offset(-2)
        }
        
        backView.addSubview(freeCountLab)
        freeCountLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(goodsImg.snp.centerY).offset(0)
        }
        
    }

   

    func setOrderCellData(model: OrderDishModel) {
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des_E
        self.countLab.text = "x\(model.count)"
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        
        
        if model.dishesType == "2" {
            //赠送的菜
            self.freeLab.isHidden = false
            self.freeCountLab.isHidden = false
            self.slab.isHidden = true
            self.moneyLab.isHidden = true
            self.disMoneyLab.isHidden = true
            self.countLab.isHidden = true
            self.disBackImg.isHidden = true
            self.moneyLab.text = ""
            self.disMoneyLab.text = ""
            self.discountScaleLab.text = ""
            
        } else {
            //正常的菜
            self.freeLab.isHidden = true
            self.freeCountLab.isHidden = true
            self.slab.isHidden = false
            self.moneyLab.isHidden = false
            self.countLab.isHidden = false

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

        }
        
    
        self.collection.reloadData()

    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
        //赋值图片
        let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)
        if img == nil {
            //下载图片
            cell.sImg.image = nil
            self.downLoadImgage(url: tagArr[indexPath.row].tagImg)
        } else {
            cell.sImg.image = img!
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //从缓存中查找图片
        let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)

        if img == nil {
            return CGSize(width: 14, height: 14)
        }
        //根据图片计算宽度
        let img_W = (img!.size.width * 14) / img!.size.height
        return  CGSize(width: img_W, height: 14)
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




class OrderConfirmGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var tagArr: [DishTagsModel] = []
    
    
    var clickCountBlock: VoidBlock?
    
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFit
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
        lab.text = "Dish Name 1"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .right)
        lab.text = "10.9"
        return lab
    }()
    
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "options,options,options,options"
        return lab
    }()
    
    
    private lazy var selectView: CountSelect_NoC_View = {
        let view = CountSelect_NoC_View()
        view.countBlock = { [unowned self] (par) in
            let dic = par as![String: Any]
            let count = dic["num"] as! Int
            self.clickCountBlock?(count)
        }
        return view
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
    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .right)
        lab.text = "FREE"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .right)
        lab.text = "x1"
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
        return coll
    }()

    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(0.5)
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
            $0.right.equalToSuperview().offset(-70)
        }
    
    
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.height.equalTo(14)
            $0.top.equalTo(nameLab.snp.bottom).offset(0)
            $0.right.equalToSuperview().offset(-70)
        }

        
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalTo(goodsImg).offset(0)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 36, height: 13))
            $0.top.equalTo(moneyLab.snp.bottom)
            $0.right.equalToSuperview().offset(-10)
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
        
        backView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-2)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
        }
                
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-110)
        }
        
        
        backView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(moneyLab.snp.bottom).offset(15)
        }

        backView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.bottom.equalTo(goodsImg.snp.centerY).offset(-2)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(goodsImg.snp.centerY).offset(0)
        }
        
    }

    func setCellData(model: CartDishModel, isCanEdite: Bool) {
        
        self.goodsImg.sd_setImage(with: URL(string: model.dishImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.dishName
        self.selectView.count = model.cartCount
        self.selectView.canClick = isCanEdite
        
        //正常购买的菜
        self.freeLab.isHidden = true
        self.countLab.isHidden = true
        self.slab.isHidden = false
        self.moneyLab.isHidden = false
        self.selectView.isHidden = false
        
        
        if model.dishesType == "2" {
            self.desLab.text = model.selectComboStr
        } else {
            self.desLab.text = model.selectOptionStr
        }
        
        if model.discountType == "1" {
            //无优惠
            self.moneyLab.text = D_2_STR(model.fee)
            self.disMoneyLab.text = ""
            self.discountScaleLab.text = ""
            self.disBackImg.isHidden = true
            self.disMoneyLab.isHidden = true
        } else {
            //有优惠
            self.moneyLab.text = D_2_STR(model.discountPrice)
            self.disMoneyLab.text = "£" + D_2_STR(model.fee)
            self.discountScaleLab.text = "\(model.discountSale)%OFF"
            self.disBackImg.isHidden = false
            self.disMoneyLab.isHidden = false
        }
        
        
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        self.collection.reloadData()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
        //赋值图片
        let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)
        if img == nil {
            //下载图片
            cell.sImg.image = nil
            self.downLoadImgage(url: tagArr[indexPath.row].tagImg)
        } else {
            cell.sImg.image = img!
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //从缓存中查找图片
        let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)

        if img == nil {
            return CGSize(width: 14, height: 14)
        }
        //根据图片计算宽度
        let img_W = (img!.size.width * 14) / img!.size.height
        return  CGSize(width: img_W, height: 14)
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
