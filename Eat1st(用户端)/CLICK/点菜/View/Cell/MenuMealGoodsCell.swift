//
//  MenuMealGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/15.
//

import UIKit

//class MenuMealGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol, UICollectionViewDelegateFlowLayout {
//
//    private var tagArr: [DishTagsModel] = []
//    private var dataModel = DishModel()
//    
//    ///点开选项
//    var optionBlock: VoidBlock?
//
//    
//    private let backView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 14
//        
//        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.12).cgColor
//        // 阴影偏移，默认(0, -3)
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        // 阴影透明度，默认0
//        view.layer.shadowOpacity = 1
//        // 阴影半径，默认3
//        view.layer.shadowRadius = 3
//        return view
//    }()
//    
//    private let goodsImg: UIImageView = {
//        let img = UIImageView()
//        img.backgroundColor = MAINCOLOR
//        img.clipsToBounds = true
//        img.layer.cornerRadius = 5
//        img.contentMode = .scaleAspectFill
//        img.isUserInteractionEnabled = true
//        return img
//    }()
//    
//    private let newImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("NEW")
//        return img
//    }()
//    
//    
//    private let t_View: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        view.isUserInteractionEnabled = true
//        return view
//    }()
//    
//
//    private let unUseImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("unUse")
//        return img
//    }()
//    
//    private let un_lab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), BFONT(9), .left)
//        return lab
//    }()
//    
//    
//    private let nameLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
//        lab.text = "Spicy burger"
//        lab.numberOfLines = 0
//        return lab
//    }()
//    
//    private let desLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .left)
//        lab.text = "Ingredients: beef"
//        lab.numberOfLines = 2
//        lab.lineBreakMode = .byTruncatingTail
//        return lab
//    }()
//    
//    
//    private let s_lab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(13), .right)
//        lab.text = "£"
//        return lab
//    }()
//    
//    private let moneyLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .right)
//        lab.text = "4.8"
//        return lab
//    }()
//    
//    private let optionBut: UIButton = {
//        let but = UIButton()
//        but.setCommentStyle(.zero, "Option", FONTCOLOR, BFONT(13), MAINCOLOR)
//        but.layer.cornerRadius = 7
//        return but
//    }()
//    
//    
//    private let disMoneyLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(12), .right)
//        lab.text = "£4.8"
//        return lab
//    }()
//    
//    private let disLine: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#666666")
//        return view
//    }()
//    
//    private let disBackImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("disback")
//        return img
//    }()
//    
//    private let discountLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#FFF8EB"), BFONT(9), .center)
//        lab.text = "25%OFF"
//        return lab
//    }()
//    
//    
//    private lazy var collection: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 2
//        layout.minimumLineSpacing = 2
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        coll.bounces = false
//        coll.delegate = self
//        coll.dataSource = self
//        coll.backgroundColor = .clear
//        coll.showsHorizontalScrollIndicator = false
//        coll.register(DishTagCell.self, forCellWithReuseIdentifier: "DishTagCell")
//        coll.isUserInteractionEnabled = false
//        return coll
//    }()
//
//    
//    
//    override func setViews() {
//        
//        contentView.backgroundColor = .white
//        
//        contentView.addSubview(backView)
//        backView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalToSuperview().offset(15)
//            $0.bottom.equalToSuperview().offset(-15)
//        }
//        
//        backView.addSubview(goodsImg)
//        goodsImg.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalToSuperview().offset(10)
//            $0.height.equalTo(SET_H(110, 335))
//        }
//        
//        
//        backView.addSubview(newImg)
//        newImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 30, height: 30))
//            $0.left.equalTo(goodsImg.snp.left).offset(-5)
//            $0.top.equalTo(goodsImg.snp.top).offset(-5)
//        }
//    
//        
//        goodsImg.addSubview(t_View)
//        t_View.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        goodsImg.addSubview(unUseImg)
//        unUseImg.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-15)
//            $0.left.equalToSuperview()
//        }
//        
//        unUseImg.addSubview(un_lab)
//        un_lab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(5)
//            $0.top.bottom.equalToSuperview()
//        }
//
//        
//        
//        
//        
//        backView.addSubview(nameLab)
//        nameLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalTo(goodsImg.snp.bottom).offset(15)
//            $0.right.equalToSuperview().offset(-140)
//        }
//        
//        backView.addSubview(desLab)
//        desLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalTo(nameLab.snp.bottom).offset(5)
//            $0.right.equalToSuperview().offset(-140)
//        }
//        
//        backView.addSubview(moneyLab)
//        moneyLab.snp.makeConstraints {
//            $0.top.equalTo(goodsImg.snp.bottom).offset(15)
//            $0.right.equalToSuperview().offset(-10)
//        }
//        
//        backView.addSubview(s_lab)
//        s_lab.snp.makeConstraints {
//            $0.bottom.equalTo(moneyLab)
//            $0.right.equalTo(moneyLab.snp.left).offset(-1)
//            
//        }
//        
//        
//        backView.addSubview(disMoneyLab)
//        disMoneyLab.snp.makeConstraints {
//            $0.bottom.equalTo(s_lab)
//            $0.right.equalTo(s_lab.snp.left).offset(-2)
//        }
//        
//        disMoneyLab.addSubview(disLine)
//        disLine.snp.makeConstraints {
//            $0.centerY.left.right.equalToSuperview()
//            $0.height.equalTo(1)
//        }
//
//        
//        contentView.addSubview(disBackImg)
//        disBackImg.snp.makeConstraints {
//            $0.centerY.equalTo(disMoneyLab)
//            $0.right.equalTo(disMoneyLab.snp.left).offset(-2)
//            $0.size.equalTo(CGSize(width: 47, height: 15))
//        }
//
//        disBackImg.addSubview(discountLab)
//        discountLab.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    
//        
//        
//        backView.addSubview(optionBut)
//        optionBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 56, height: 20))
//            $0.top.equalTo(moneyLab.snp.bottom).offset(10)
//            $0.right.equalToSuperview().offset(-10)
//        }
//        
//        
//        backView.addSubview(collection)
//        collection.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalTo(desLab.snp.bottom).offset(5)
//            $0.height.equalTo(14)
//            $0.width.equalTo(120)
//        }
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        t_View.addGestureRecognizer(tap)
//        
//        optionBut.addTarget(self, action: #selector(clickOptionAction), for: .touchUpInside)
//        
//    }
//    
//    
//    @objc private func clickOptionAction()  {
//        self.optionBlock?("")
//    }
//
//    
//    
//    @objc private func tapAction()  {
//        //放大图片
//        self.showImage(self.goodsImg)
//    }
//    
//    
//    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
//        return nil
//    }
//    
//    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
//        
//        if dataModel.listImg == "" {
//            return nil
//        } else {
//            return URL(string: dataModel.listImg)
//        }
//    }
//    
//
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return tagArr.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
//        cell.nameLab.text = tagArr[indexPath.item].tagName
//        //赋值图片
//        let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)
//        if img == nil {
//            //下载图片
//            cell.sImg.image = nil
//            self.downLoadImgage(url: tagArr[indexPath.row].tagImg)
//        } else {
//            cell.sImg.image = img!
//        }
//        
//        return cell
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let textW = tagArr[indexPath.item].tagName.getTextWidth(SFONT(11), 14)
//        
//        //从缓存中查找图片
//        let img = SDImageCache.shared.imageFromCache(forKey: tagArr[indexPath.item].tagImg)
//
//        if img == nil {
//            return CGSize(width: textW + 2, height: 14)
//        }
//        //根据图片计算宽度
//        let img_W = (img!.size.width * 14) / img!.size.height
//        return  CGSize(width: img_W + textW + 2, height: 14)
//    }
//    
//    
//    
//    //下载图片
//    private func downLoadImgage(url: String) {
//        SDWebImageDownloader.shared.downloadImage(with: URL(string: url)) { image, data, error, finished in
//            
//            SDImageCache.shared.store(image, forKey: url, toDisk: true)
//            
//            //判断图片
//            if image != nil {
//                
//                //主线程刷新UI
//                DispatchQueue.main.async {
//                    self.collection.reloadData()
//                }
//                
//            }
//            
//        }
//    }
//    
//    
//    func setCellData(model: DishModel) {
//        self.dataModel = model
//        //启用禁用的设置
//        if model.isOn == "1" {
//            self.optionBut.isHidden = false
//            self.nameLab.textColor = FONTCOLOR
//            self.s_lab.textColor = HCOLOR("FB5348")
//            self.moneyLab.textColor = HCOLOR("FB5348")
//            self.unUseImg.isHidden = true
//
//            
//        } else {
//            self.optionBut.isHidden = true
//            self.nameLab.textColor = HCOLOR("#AAAAAA")
//            self.s_lab.textColor = HCOLOR("#AAAAAA")
//            self.moneyLab.textColor = HCOLOR("AAAAAA")
//            self.unUseImg.isHidden = false
//            
//        }
//        
//        
//        //是否有优惠的设置
//        if model.discountType == "2" {
//            //有优惠
//            self.moneyLab.text = D_2_STR(model.discountPrice)
//            self.disMoneyLab.text =  "£" + D_2_STR(model.price)
//            self.disBackImg.isHidden = false
//            self.disMoneyLab.isHidden = false
//            self.discountLab.text = "\(model.discountSale)%OFF"
//        } else {
//            //无优惠
//            self.moneyLab.text = D_2_STR(model.price)
//            self.disMoneyLab.text = ""
//            self.disBackImg.isHidden = true
//            self.disMoneyLab.isHidden = true
//            self.discountLab.text = ""
//        }
//        
//        //是否为新品的设置
//        self.newImg.isHidden = !model.isNew
//
//        //基本数据赋值
//        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG_L)
//        self.nameLab.text = model.name_E
//        self.desLab.text = model.des
//        self.un_lab.text = model.unAlbleMsg
//        
//        //标签的设置
//        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
//        self.collection.reloadData()
//    }
//}
