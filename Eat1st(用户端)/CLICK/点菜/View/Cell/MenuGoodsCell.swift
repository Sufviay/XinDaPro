//
//  MenuGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/3.
//

import UIKit


//MARK: - 无规格
class MenuGoodsNoSizeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol, UICollectionViewDelegateFlowLayout {
    
    
    private var tagArr: [DishTagsModel] = []
    
    private var dataModel = DishModel()

    var clickCountBlock: VoidBlock?
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4").withAlphaComponent(0.5)
        return view
    }()
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Spicy burger"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "Ingredients: beef"
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(13), .left)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .left)
        lab.text = "4.8"
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
    
    private let t_View: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
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
        coll.isUserInteractionEnabled = false
        return coll
    }()

    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
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
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let discountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFF8EB"), BFONT(9), .center)
        lab.text = "25%OFF"
        return lab
    }()
    
    
    private let newImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("NEW")
        return img
    }()
    
    

    override func setViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 110, height: 110))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        goodsImg.addSubview(t_View)
        t_View.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(newImg)
        newImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(goodsImg.snp.left).offset(-5)
            $0.top.equalTo(goodsImg.snp.top).offset(-5)
            
        }
        
        goodsImg.addSubview(unUseImg)
        unUseImg.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.left.equalToSuperview()
        }
        
        
        unUseImg.addSubview(un_lab)
        un_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.bottom.equalToSuperview()
        }

        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(desLab)
            $0.height.equalTo(14)
            $0.top.equalTo(desLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-15)
        }
    
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(desLab.snp.bottom).offset(40)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right).offset(1)
            $0.bottom.equalTo(s_lab.snp.bottom).offset(1)
        }
        
        contentView.addSubview(disMoneyLab)
        disMoneyLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.bottom.equalTo(moneyLab.snp.top).offset(-2)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.centerY.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.bottom.equalTo(disMoneyLab).offset(-2)
            $0.left.equalTo(disMoneyLab.snp.right).offset(2)
            $0.size.equalTo(CGSize(width: 47, height: 15))
        }
        
        disBackImg.addSubview(discountLab)
        discountLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(moneyLab)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        t_View.addGestureRecognizer(tap)
        
    }
    
    
    @objc private func tapAction()  {
        //放大图片
        self.showImage(self.goodsImg)
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return nil
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        if dataModel.listImg == "" {
            return nil
        } else {
            return URL(string: dataModel.listImg)
        }
    }

    
    func setCellData(model: DishModel, type: String)  {
        
        self.dataModel = model
        
        
        if type == "2" {
            //卖午餐 单品都不可买卖
            
            self.un_lab.text = "For Dinner only"
            self.selectView.isHidden = true
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
            self.unUseImg.isHidden = false

            
            
        } else {
            //晚餐 正常卖单品
            self.un_lab.text = model.unAlbleMsg

            //设置商品是否启用
            if model.isOn == "1" {
                self.selectView.isHidden = false
                self.nameLab.textColor = FONTCOLOR
                self.s_lab.textColor = HCOLOR("#FB5348")
                self.moneyLab.textColor = HCOLOR("#FB5348")
                self.unUseImg.isHidden = true
                
                
                
            } else {
                self.selectView.isHidden = true
                self.nameLab.textColor = HCOLOR("#AAAAAA")
                self.s_lab.textColor = HCOLOR("#AAAAAA")
                self.moneyLab.textColor = HCOLOR("AAAAAA")
                self.unUseImg.isHidden = false
                
            }
        }
        
        
        
        //设置商品买卖数量
        selectView.count = model.sel_Num
        
        //设置商品优惠
        if model.discountType == "2" {
            //有优惠
            self.moneyLab.text = D_2_STR(model.discountPrice)
            self.disMoneyLab.text = "£" + D_2_STR(model.price)
            self.disBackImg.isHidden = false
            self.disMoneyLab.isHidden = false
            self.discountLab.text = "\(model.discountSale)%OFF"
        } else {
            //无优惠
            self.moneyLab.text = D_2_STR(model.price)
            self.disMoneyLab.text = ""
            self.disBackImg.isHidden = true
            self.disMoneyLab.isHidden = true
            self.discountLab.text = ""
        }
        
        //这是商品是否新品
        self.newImg.isHidden = !model.isNew
        
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des

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






//MARK: - 有规格
class MenuGoodsSizeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol, UICollectionViewDelegateFlowLayout {
    
    ///添加规格菜品
    var jiaBlock: VoidBlock?
    
    ///减少菜品规格
    var jianBlock: VoidBlock?
    ///点开选项
    var optionBlock: VoidBlock?
    
    
    private var tagArr: [DishTagsModel] = []
    
    private var dataModel = DishModel()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4").withAlphaComponent(0.5)
        return view
    }()
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    

    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.text = "Spicy burger"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
        lab.text = "Ingredients: beef"
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(13), .left)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .left)
        lab.text = "4.8"
        return lab
    }()
    
    
    private let optionBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Option", FONTCOLOR, BFONT(13), MAINCOLOR)
        but.layer.cornerRadius = 7
        return but
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

    
    private let t_View: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
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
        coll.isUserInteractionEnabled = false
        return coll
    }()
    
    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
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
    
    private let discountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FFF8EB"), BFONT(9), .center)
        lab.text = "25%OFF"
        return lab
    }()
    
    
    private let newImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("NEW")
        return img
    }()

    
    
    
    override func setViews() {
        contentView.backgroundColor = .white
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }

        
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 110, height: 110))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        goodsImg.addSubview(t_View)
        t_View.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        
        goodsImg.addSubview(unUseImg)
        unUseImg.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.left.equalToSuperview()
        }
        
        unUseImg.addSubview(un_lab)
        un_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.bottom.equalToSuperview()
        }

        contentView.addSubview(newImg)
        newImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(goodsImg.snp.left).offset(-5)
            $0.top.equalTo(goodsImg.snp.top).offset(-5)
            
        }

        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(desLab)
            $0.height.equalTo(14)
            $0.top.equalTo(desLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-15)
        }
        

        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(desLab.snp.bottom).offset(40)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right).offset(1)
            $0.bottom.equalTo(s_lab.snp.bottom).offset(1)
        }
        
        
        contentView.addSubview(disMoneyLab)
        disMoneyLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.bottom.equalTo(moneyLab.snp.top).offset(-2)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.centerY.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.bottom.equalTo(disMoneyLab).offset(-2)
            $0.left.equalTo(disMoneyLab.snp.right).offset(2)
            $0.size.equalTo(CGSize(width: 47, height: 15))
        }

        disBackImg.addSubview(discountLab)
        discountLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        

        
        contentView.addSubview(optionBut)
        optionBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 56, height: 20))
            //$0.bottom.equalTo(selectView.snp.top).offset(-6)
            $0.centerY.equalTo(moneyLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        optionBut.addTarget(self, action: #selector(clickOptionAction), for: .touchUpInside)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        t_View.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction()  {
        //放大图片
        self.showImage(self.goodsImg)
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return nil
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        if dataModel.listImg == "" {
            return nil
        } else {
            return URL(string: dataModel.listImg)
        }
    }

    
    
    
    @objc private func clickOptionAction()  {
        self.optionBlock?("")
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

    
    func setCellData(model: DishModel, type: String) {
        self.dataModel = model
        
        if type == "2" {
            self.un_lab.text = "For Dinner only"
            self.optionBut.isHidden = true
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
            self.unUseImg.isHidden = false

        } else {

            self.un_lab.text = model.unAlbleMsg
            //设置是否启用
            if model.isOn == "1" {
                self.optionBut.isHidden = false
                self.nameLab.textColor = FONTCOLOR
                self.s_lab.textColor = HCOLOR("FB5348")
                self.moneyLab.textColor = HCOLOR("FB5348")
                self.unUseImg.isHidden = true
                        
            } else {
                self.optionBut.isHidden = true
                self.nameLab.textColor = HCOLOR("#AAAAAA")
                self.s_lab.textColor = HCOLOR("#AAAAAA")
                self.moneyLab.textColor = HCOLOR("AAAAAA")
                self.unUseImg.isHidden = false
                
            }
        }
    
        
        //设置优惠
        if model.discountType == "2" {
            //有优惠
            self.moneyLab.text = D_2_STR(model.discountPrice)
            self.disMoneyLab.text =  "£" + D_2_STR(model.price)
            self.disBackImg.isHidden = false
            self.disMoneyLab.isHidden = false
            self.discountLab.text = "\(model.discountSale)%OFF"
        } else {
            //无优惠
            self.moneyLab.text = D_2_STR(model.price)
            self.disMoneyLab.text = ""
            self.disBackImg.isHidden = true
            self.disMoneyLab.isHidden = true
            self.discountLab.text = ""
        }

        //设置收否新品
        self.newImg.isHidden = !model.isNew
        
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des
        
        
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        self.collection.reloadData()
    }
    
}




class DishTagCell: UICollectionViewCell {
    
    let sImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)

        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






