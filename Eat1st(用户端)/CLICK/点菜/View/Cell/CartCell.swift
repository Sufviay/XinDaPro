//
//  CartCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/2/20.
//

import UIKit


//MARK: - 购物车
class MenuCartGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var tagArr: [DishTagsModel] = []

    var clickCountBlock: VoidBlock?
    
    var clickDeleteBlock: VoidBlock?
    
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
        return img
    }()
    
    private let tview: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let unlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(15), .center)
        lab.text = "not available"
        return lab
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
        lab.numberOfLines = 0
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
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("unavailable_delete"), for: .normal)
        return but
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
            $0.left.equalToSuperview().offset(20)
        }
        
        goodsImg.addSubview(tview)
        tview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tview.addSubview(unlab)
        unlab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        

        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(desLab)
            $0.height.equalTo(14)
            $0.top.equalTo(desLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-20)
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
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(moneyLab)
        }
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalTo(moneyLab)
            $0.right.equalToSuperview().offset(-15)
        }
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    func setCellData(model: CartDishModel)  {
        
        
        if model.isOn == "1" {
            //可用
            self.selectView.isHidden = false
            self.deleteBut.isHidden = true
            self.tview.isHidden = true
            self.nameLab.textColor = FONTCOLOR
            self.desLab.textColor = HCOLOR("#666666")
            self.s_lab.textColor = HCOLOR("#FB5348")
            self.moneyLab.textColor = HCOLOR("#FB5348")
            
        } else {
            //不可用
            self.selectView.isHidden = true
            self.deleteBut.isHidden = false
            self.tview.isHidden = false
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.desLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("#AAAAAA")
            
        }

        
        
        
        selectView.count = model.cartCount
        self.moneyLab.text = D_2_STR(model.fee)
        self.goodsImg.sd_setImage(with: URL(string: model.dishImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.dishName
        self.desLab.text = model.selectOptionStr
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }

        self.collection.reloadData()
        
    }
    
    
    @objc private func clickDeleteAction() {
        self.clickDeleteBlock?("")
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



class CartComboGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var clickCountBlock: VoidBlock?
    
    var clickDeleteBlock: VoidBlock?
    
    
    private var tagArr: [DishTagsModel] = []
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4").withAlphaComponent(0.5)
        return view
    }()

    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = MAINCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
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
        lab.numberOfLines = 0
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), SFONT(13), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FB5348"), BFONT(15), .right)
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
    
    private let tview: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let unlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(15), .center)
        lab.text = "not available"
        return lab
    }()
    
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("unavailable_delete"), for: .normal)
        return but
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
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(15)
            $0.height.equalTo(SET_H(110, 335))
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-150)
            $0.top.equalTo(goodsImg.snp.bottom).offset(15)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.top.equalTo(goodsImg.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab)
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
            
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-150)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(desLab)
            $0.height.equalTo(14)
            $0.top.equalTo(desLab.snp.bottom).offset(5)
            $0.width.equalTo(S_W / 2)
        }
        
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(goodsImg.snp.bottom).offset(40)

        }
        
        
        
        goodsImg.addSubview(tview)
        tview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tview.addSubview(unlab)
        unlab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalTo(selectView)
            $0.right.equalToSuperview().offset(-20)
        }
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    
    }

    
    @objc private func clickDeleteAction() {
        self.clickDeleteBlock?("")
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

    func setCellData(model: CartDishModel) {
        
        if model.isOn == "1" {
            //可用
            self.selectView.isHidden = false
            self.deleteBut.isHidden = true
            self.tview.isHidden = true
            self.nameLab.textColor = FONTCOLOR
            self.desLab.textColor = HCOLOR("#666666")
            self.s_lab.textColor = HCOLOR("#FB5348")
            self.moneyLab.textColor = HCOLOR("#FB5348")
            
        } else {
            //不可用
            self.selectView.isHidden = true
            self.deleteBut.isHidden = false
            self.tview.isHidden = false
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.desLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("#AAAAAA")
            
        }

        
        
        
        selectView.count = model.cartCount
        self.moneyLab.text = D_2_STR(model.fee)
        self.goodsImg.sd_setImage(with: URL(string: model.dishImg), placeholderImage: HOLDIMG_L)
        self.nameLab.text = model.dishName
        self.desLab.text = model.selectComboStr
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        self.collection.reloadData()
        
    }
    
    
    

    
    
}


