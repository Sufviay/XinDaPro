//
//  MenuDishesCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/12/8.
//

import UIKit

class MenuDishesCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol, UICollectionViewDelegateFlowLayout{

    ///选择规格
    var optionBlock: VoidBlock?
    ///添加菜品
    var clickCountBlock: VoidBlock?
    
    
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
        coll.register(BuyOneGiveOneTagCell.self, forCellWithReuseIdentifier: "BuyOneGiveOneTagCell")
        coll.isUserInteractionEnabled = false
        return coll
    }()
    
    private let disMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(12), .left)
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
        lab.setCommentStyle(HCOLOR("#FFF8EB"), BFONT(8), .center)
        lab.text = "25%OFF"
        return lab
    }()
    
    
    private let newImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("NEW")
        return img
    }()

    
    private let giveOneBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFD645").withAlphaComponent(0.12)
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    private let freeMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(8), .left)
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
            $0.height.equalTo(15)
            $0.top.equalTo(desLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-10)
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
            $0.bottom.equalTo(moneyLab.snp.top).offset(0)
        }
        
        disMoneyLab.addSubview(disLine)
        disLine.snp.makeConstraints {
            $0.centerY.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(disBackImg)
        disBackImg.snp.makeConstraints {
            $0.bottom.equalTo(disMoneyLab).offset(0)
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

        
        contentView.addSubview(optionBut)
        optionBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 56, height: 20))
            //$0.bottom.equalTo(selectView.snp.top).offset(-6)
            $0.centerY.equalTo(moneyLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        
        contentView.addSubview(giveOneBackView)
        giveOneBackView.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(20)
            $0.top.equalTo(moneyLab.snp.bottom).offset(10)
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
            $0.left.equalToSuperview().offset(35)
        }
        
        giveOneBackView.addSubview(freeCountLab)
        freeCountLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
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
    
    

    
    func setCellData(model: DishModel, canBuy: Bool) {
        self.dataModel = model
        
        
        freeCountLab.text = "x\(model.sel_Num)"
        
        if model.isGiveOne && model.sel_Num != 0 {
            giveOneBackView.isHidden = false
            
        } else {
            giveOneBackView.isHidden = true
        }
        
        if !canBuy {
            self.un_lab.text = "Unavailable"
            self.unUseImg.isHidden = false
            optionBut.isHidden = true
            selectView.isHidden = true
        } else {
            self.un_lab.text = model.unAlbleMsg
            if model.isOn == "1" {
                self.unUseImg.isHidden = true
                
                if model.isSelect || model.dishesType == "2" {
                    optionBut.isHidden = false
                    selectView.isHidden = true
                } else {
                    optionBut.isHidden = true
                    selectView.isHidden = false
                }

            } else {
                self.unUseImg.isHidden = false
                optionBut.isHidden = true
                selectView.isHidden = true
            }
        }
        
        
        //设置是否启用
        if model.isOn == "1" {
            self.nameLab.textColor = FONTCOLOR
            self.s_lab.textColor = HCOLOR("FB5348")
            self.moneyLab.textColor = HCOLOR("FB5348")
        } else {
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
        }
    
        //设置商品买卖数量
        selectView.count = model.sel_Num
        
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
        self.nameLab.text = model.name
        self.desLab.text = model.des
        
        
        self.tagArr = model.tagList//.filter{ $0.tagImg != "" }
        self.collection.reloadData()
    }
    
}



class DishTagCell: UICollectionViewCell {
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(11), .right)
        return lab
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        //contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-3)
            $0.top.bottom.equalToSuperview()
        }

        
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(3)
        }
        
    }
    
    
    func setImage(img: UIImage?) {
        sImg.image = img
        
        if img == nil {
            sImg.isHidden = true
        } else {
            sImg.isHidden = false
            
            let img_w = (img!.size.width * 14) / img!.size.height
            sImg.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(3)
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(img_w)
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BuyOneGiveOneTagCell: UICollectionViewCell {
    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("oneone")
        return img
    }()
    
//    private let msgLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("333333"), BFONT(5), .left)
//        lab.text = "BUY ONE GET ONE FREE"
//        return lab
//    }()
//
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        contentView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        backImg.addSubview(msgLab)
//        msgLab.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(17)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}






