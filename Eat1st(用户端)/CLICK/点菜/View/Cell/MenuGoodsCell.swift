//
//  MenuGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/3.
//

import UIKit


//MARK: - 无规格
class MenuGoodsNoSizeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol {
    
    
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
        layout.itemSize = CGSize(width: 8, height: 14)
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

    
    func setCellData(model: DishModel)  {
        
        self.dataModel = model
        
        if model.isOn == "1" {
            self.selectView.isHidden = false
            self.nameLab.textColor = FONTCOLOR
            self.s_lab.textColor = HCOLOR("#FB5348")
            self.moneyLab.textColor = HCOLOR("#FB5348")
            self.unUseImg.isHidden = true
            
            self.newImg.isHidden = false
            self.disBackImg.isHidden = false
            self.disMoneyLab.isHidden = false
            
            
        } else {
            self.selectView.isHidden = true
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
            self.unUseImg.isHidden = false
            
            self.newImg.isHidden = true
            self.disBackImg.isHidden = true
            self.disMoneyLab.isHidden = true
        }
        
        selectView.count = model.sel_Num
        
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des
        self.un_lab.text = model.unAlbleMsg
        self.newImg.isHidden = !model.isNew
        
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
        
        
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        
        self.collection.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
        cell.sImg.sd_setImage(with: URL(string: tagArr[indexPath.item].tagImg))
        return cell
    }
    
}






//MARK: - 有规格
class MenuGoodsSizeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol {
    
    ///添加规格菜品
    var jiaBlock: VoidBlock?
    
    ///减少菜品规格
    var jianBlock: VoidBlock?
    ///点开选项
    var optionBlock: VoidBlock?
    
    
    private var tagArr: [DishTagsModel] = []
    
    private var dataModel = DishModel()
    
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
    
    
//    private lazy var selectView: CountSelect_NoC_View = {
//        let view = CountSelect_NoC_View()
//        view.countBlock = { [unowned self] (par) in
//
//
//            let dic = par as![String: Any]
//            let type = dic["type"] as! String
//            let count = dic["num"] as! Int
//
//            if type == "+" {
//                self.jiaBlock?(count)
//            } else {
//                self.jianBlock?("")
//            }
//
//
//        }
//        view.isHidden = true
//        return view
//    }()
    
    
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
        layout.itemSize = CGSize(width: 8, height: 14)
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
        
        
//        contentView.addSubview(selectBut)
//        selectBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 56, height: 20))
//            $0.right.equalToSuperview().offset(-10)
//            $0.centerY.equalTo(moneyLab)
//        }
        
//        contentView.addSubview(selectView)
//        selectView.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 90, height: 30))
//            $0.right.equalToSuperview().offset(-10)
//            $0.centerY.equalTo(moneyLab)
//        }
        
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
        cell.sImg.sd_setImage(with: URL(string: tagArr[indexPath.item].tagImg))
        return cell
    }
    
    func setCellData(model: DishModel) {
        self.dataModel = model
        if model.isOn == "1" {
            self.optionBut.isHidden = false
            //self.selectView.isHidden = false
            self.nameLab.textColor = FONTCOLOR
            self.s_lab.textColor = HCOLOR("FB5348")
            self.moneyLab.textColor = HCOLOR("FB5348")
            self.unUseImg.isHidden = true
            
            self.newImg.isHidden = false
            self.disBackImg.isHidden = false
            self.disMoneyLab.isHidden = false
            
            
        } else {
            self.optionBut.isHidden = true
            //self.selectView.isHidden = true
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
            self.unUseImg.isHidden = false
            
            self.newImg.isHidden = true
            self.disBackImg.isHidden = true
            self.disMoneyLab.isHidden = true
            
        }
        
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

        
        //self.selectView.count = model.sel_Num
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.newImg.isHidden = !model.isNew
        self.nameLab.text = model.name_E
        self.desLab.text = model.des
        self.un_lab.text = model.unAlbleMsg
        
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        self.collection.reloadData()
    }
    
}





//MARK: - 购物车
class MenuCartGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        layout.itemSize = CGSize(width: 8, height: 14)
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
        cell.sImg.sd_setImage(with: URL(string: tagArr[indexPath.item].tagImg))
        return cell
    }
    
}






//class SelectSizeCountCell: BaseTableViewCell {
//
//    var selectCountBlock: VoidBlock?
//
//    private let titlab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, SFONT(13), .left)
//        lab.numberOfLines = 0
//        return lab
//    }()
//
//    private lazy var selectView: CountSelectView = {
//        let view = CountSelectView()
//        view.countBlock = { [unowned self] (count) in
//            print(count as! Int)
//            self.selectCountBlock?(count as! Int)
//        }
//        return view
//    }()
//
//    private let s_lab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, BFONT(11), .left)
//        lab.text = "£"
//        return lab
//    }()
//
//    private let moneyLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, BFONT(14), .left)
//        lab.text = "5.8"
//        return lab
//    }()
//
//
//    override func setViews() {
//
//        contentView.addSubview(selectView)
//        selectView.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 90, height: 30))
//            $0.bottom.equalToSuperview().offset(-3)
//            $0.right.equalToSuperview().offset(-10)
//        }
//
//
//        contentView.addSubview(titlab)
//        titlab.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(5)
//            $0.bottom.equalToSuperview().offset(-35)
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-70)
//        }
//
//        contentView.addSubview(s_lab)
//        s_lab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalTo(selectView)
//        }
//
//        contentView.addSubview(moneyLab)
//        moneyLab.snp.makeConstraints {
//            $0.left.equalTo(s_lab.snp.right)
//            $0.bottom.equalTo(s_lab)
//
//        }
//
//
//    }
//
//
//    func setCellData(model: CartDishModel) {
//        self.titlab.text = model.selectOptionStr
//        self.selectView.count = model.cartCount
//        self.moneyLab.text = "\(model.fee)"
//
//    }
//
//}
//

class DishTagCell: UICollectionViewCell {
    
    let sImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
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






//class MenuGoodsSizeCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
//
//    private let line: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#E4E4E4").withAlphaComponent(0.5)
//        return view
//    }()
//
//
//    private var tagArr: [DishTagsModel] = []
//
//    private var dataModel = DishModel()
//
//    ///选规格
//    var selectBlock: VoidBlock?
//    ///改变数量
//    var clickCountBlock: VoidBlock?
//
//    private lazy var sizeTable: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .white
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.register(SelectSizeCountCell.self, forCellReuseIdentifier: "SelectSizeCountCell")
//        tableView.register(MenuGoodsInfoAndSelectCell.self, forCellReuseIdentifier: "MenuGoodsInfoAndSelectCell")
//
//        tableView.isUserInteractionEnabled = false
//        return tableView
//    }()
//
//
//
//
//    override func setViews() {
//
//        contentView.addSubview(sizeTable)
//        sizeTable.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.height.equalTo(0.5)
//            $0.bottom.equalToSuperview()
//        }
//
//
//    }
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        return dataModel.cart.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.section == 0 {
//
//            let n_h = dataModel.name_C.getTextHeigh(BFONT(14), S_W - 225)
//            let d_h = dataModel.des.getTextHeigh(SFONT(11), S_W - 225)
//            let h = (n_h + d_h + 85) > 120 ? (n_h + d_h + 85) : 120
//            return h
//        } else {
//            return dataModel.cart[indexPath.row].selectOptionStr.getTextHeigh(SFONT(13), S_W - 180) + 50
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsInfoAndSelectCell") as! MenuGoodsInfoAndSelectCell
//            cell.setCellData(model: dataModel)
//
//            cell.selectBlock = { [unowned self] (_) in
//                self.selectBlock?("")
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSizeCountCell") as! SelectSizeCountCell
//            cell.setCellData(model: dataModel.cart[indexPath.row])
//
//            cell.selectCountBlock = { [unowned self] (count) in
//                let infoDic = ["count": count, "model": dataModel.cart[indexPath.row]]
//                self.clickCountBlock?(infoDic)
//            }
//
//            return cell
//        }
//
//    }
//
//
//
//    func setCellData(model: DishModel) {
//        self.dataModel = model
//        self.sizeTable.reloadData()
//    }
//}










//class MenuGoodsSizeCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    private var tagArr: [DishTagsModel] = []
//
//    private var dataModel = DishModel()
//
//    ///选规格
//    var selectBlock: VoidBlock?
//    ///改变数量
//    var clickCountBlock: VoidBlock?
//
//    private let goodsImg: CustomImgeView = {
//        let img = CustomImgeView()
//        img.clipsToBounds = true
//        img.layer.cornerRadius = 10
//        img.setTitleFont(fontNum: 10)
//        return img
//    }()
//
//    private let nameLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
//        lab.text = "Spicy burger"
//        lab.numberOfLines = 0
//        return lab
//    }()
//
//    private let desLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#999999"), SFONT(11), .left)
//        lab.numberOfLines = 0
//        lab.text = "Ingredients: beef"
//        return lab
//    }()
//
////    private let countLab: UILabel = {
////        let lab = UILabel()
////        lab.setCommentStyle(HCOLOR("#999999"), SFONT(13), .left)
////        lab.text = "63 sold"
////        return lab
////    }()
//
//    private let s_lab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, BFONT(11), .left)
//        lab.text = "from £"
//        return lab
//    }()
//
//    private let moneyLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, BFONT(18), .left)
//        lab.text = "4.8"
//        return lab
//    }()
//
//    private let selectBut: UIButton = {
//        let but = UIButton()
//        but.setCommentStyle(.zero, "Select", .white, SFONT(13), MAINCOLOR)
//        but.layer.cornerRadius = 12
//        return but
//    }()
//
//    private let unUseImg: UIImageView = {
//        let img = UIImageView()
//        img.image = LOIMG("unUse")
//        return img
//    }()
//
//
//
//
//    private lazy var sizeTable: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .white
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.tag = 1
//        tableView.register(SelectSizeCountCell.self, forCellReuseIdentifier: "SelectSizeCountCell")
//        return tableView
//    }()
//
//
//
//    private lazy var collection: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 2
//        layout.minimumLineSpacing = 2
//        layout.itemSize = CGSize(width: 8, height: 14)
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
//    override func setViews() {
//
//        contentView.backgroundColor = .white
//        contentView.addSubview(goodsImg)
//        goodsImg.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 100, height: 100))
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalToSuperview().offset(10)
//        }
//
//
//
//        goodsImg.addSubview(unUseImg)
//        unUseImg.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-15)
//            $0.left.equalToSuperview()
//        }
//
//
//        contentView.addSubview(nameLab)
//        nameLab.snp.makeConstraints {
//            $0.left.equalTo(goodsImg.snp.right).offset(10)
//            $0.top.equalTo(goodsImg).offset(5)
//            $0.right.equalToSuperview().offset(-15)
//        }
//
//        contentView.addSubview(desLab)
//        desLab.snp.makeConstraints {
//            $0.left.equalTo(nameLab)
//            $0.top.equalTo(goodsImg).offset(27)
//            $0.right.equalToSuperview().offset(-15)
//        }
//
////        contentView.addSubview(countLab)
////        countLab.snp.makeConstraints {
////            $0.left.equalTo(nameLab)
////            $0.top.equalTo(goodsImg).offset(48)
////        }
//
//        contentView.addSubview(collection)
//        collection.snp.makeConstraints {
//            $0.left.equalTo(desLab)
//            $0.height.equalTo(14)
//            $0.top.equalTo(desLab.snp.bottom).offset(5)
//            $0.right.equalToSuperview().offset(-20)
//        }
//
//
//
//        contentView.addSubview(s_lab)
//        s_lab.snp.makeConstraints {
//            $0.left.equalTo(nameLab)
//            $0.top.equalTo(goodsImg).offset(75)
//        }
//
//        contentView.addSubview(moneyLab)
//        moneyLab.snp.makeConstraints {
//            $0.left.equalTo(s_lab.snp.right)
//            $0.bottom.equalTo(s_lab.snp.bottom).offset(3)
//        }
//
//        contentView.addSubview(selectBut)
//        selectBut.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 65, height: 24))
//            $0.right.equalToSuperview().offset(-10)
//            $0.centerY.equalTo(moneyLab)
//        }
//
//        contentView.addSubview(sizeTable)
//        sizeTable.snp.makeConstraints {
//            $0.left.right.bottom.equalToSuperview()
//            $0.top.equalTo(goodsImg.snp.bottom).offset(10)
//        }
//
//        selectBut.addTarget(self, action: #selector(clickSelectAction), for: .touchUpInside)
//    }
//
//
//    @objc private func clickSelectAction()  {
//        selectBlock?("")
//    }
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataModel.cart.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return dataModel.cart[indexPath.row].selectOptionStr.getTextHeigh(SFONT(13), S_W - 180) + 50
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSizeCountCell") as! SelectSizeCountCell
//        cell.setCellData(model: dataModel.cart[indexPath.row])
//
//        cell.selectCountBlock = { [unowned self] (count) in
//            let infoDic = ["count": count, "model": dataModel.cart[indexPath.row]]
//            self.clickCountBlock?(infoDic)
//        }
//
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return tagArr.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishTagCell", for: indexPath) as! DishTagCell
//        cell.sImg.sd_setImage(with: URL(string: tagArr[indexPath.item].tagImg))
//        return cell
//    }
//
//
//    func setCellData(model: DishModel) {
//
//        if model.isOn {
//            self.selectBut.isHidden = false
//            self.nameLab.textColor = FONTCOLOR
//            self.s_lab.textColor = MAINCOLOR
//            self.moneyLab.textColor = MAINCOLOR
//            self.unUseImg.isHidden = true
//        } else {
//            self.selectBut.isHidden = true
//            self.nameLab.textColor = HCOLOR("#999999")
//            self.s_lab.textColor = HCOLOR("#999999")
//            self.moneyLab.textColor = HCOLOR("999999")
//            self.unUseImg.isHidden = false
//        }
//
//
//        self.dataModel = model
//        self.goodsImg.setImage(imageStr: model.listImg)
//
//        self.nameLab.text = model.name_E
//        self.desLab.text = model.des
//        //self.countLab.text = "\(model.sales) sold"
//        self.moneyLab.text = "\(model.price)"
//        self.sizeTable.reloadData()
//
//        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
//        self.collection.reloadData()
//
//    }
//}

