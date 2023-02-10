//
//  MenuGoodsCell_Big.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/26.
//

import UIKit

//MARK: - 无规格
class Big_MenuGoodsNoSizeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol {
    
    
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
            $0.top.equalTo(desLab.snp.bottom).offset(30)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right).offset(1)
            $0.bottom.equalTo(s_lab.snp.bottom).offset(1)
        }
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(desLab.snp.bottom).offset(50)
//            $0.centerY.equalTo(moneyLab)
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
        } else {
            self.selectView.isHidden = true
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
            self.unUseImg.isHidden = false
        }
        
        selectView.count = model.sel_Num
        
        self.moneyLab.text = D_2_STR(model.price)
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des
        self.un_lab.text = model.unAlbleMsg
        
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        
        self.collection.reloadData()
        
        //        if model.cart.count == 0 {
        //            self.selectView.count = 0
        //        } else {
        //            self.selectView.count = model.cart[0].cartCount
        //        }

        
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
class Big_MenuGoodsSizeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol {
    
    ///添加规格菜品
    var jiaBlock: VoidBlock?
    
    ///减少菜品规格
    var jianBlock: VoidBlock?
    
    
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
    private let selectBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Select", FONTCOLOR, BFONT(13), MAINCOLOR)
        but.layer.cornerRadius = 7
        return but
    }()
    
    
    private lazy var selectView: CountSelect_NoC_View = {
        let view = CountSelect_NoC_View()
        view.countBlock = { [unowned self] (par) in
            
            let dic = par as![String: Any]
            let type = dic["type"] as! String
            if type == "+" {
                self.jiaBlock?("")
            } else {
                self.jianBlock?("")
            }
            

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
            $0.top.equalTo(desLab.snp.bottom).offset(30)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right).offset(1)
            $0.bottom.equalTo(s_lab.snp.bottom).offset(1)
        }
        
        contentView.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 56, height: 20))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(desLab.snp.bottom).offset(55)
            //$0.centerY.equalTo(moneyLab)
        }
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(desLab.snp.bottom).offset(50)
            //$0.centerY.equalTo(moneyLab)
        }
        
        selectBut.addTarget(self, action: #selector(clickSelectAction), for: .touchUpInside)
        
        
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

    
    
    
    @objc private func clickSelectAction()  {
        self.jiaBlock?("")
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
            self.selectBut.isHidden = false
            self.nameLab.textColor = FONTCOLOR
            self.s_lab.textColor = HCOLOR("FB5348")
            self.moneyLab.textColor = HCOLOR("FB5348")
            self.unUseImg.isHidden = true
            
            if model.sel_Num != 0 {
                self.selectView.isHidden = false
                self.selectBut.isHidden = true
            } else {
                self.selectView.isHidden = true
                self.selectBut.isHidden = false
            }
            
        } else {
            self.selectBut.isHidden = true
            self.selectView.isHidden = true
            self.nameLab.textColor = HCOLOR("#AAAAAA")
            self.s_lab.textColor = HCOLOR("#AAAAAA")
            self.moneyLab.textColor = HCOLOR("AAAAAA")
            self.unUseImg.isHidden = false
        }
        
        self.selectView.count = model.sel_Num
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: HOLDIMG)
        self.nameLab.text = model.name_E
        self.desLab.text = model.des
        self.moneyLab.text = D_2_STR(model.price)
        self.un_lab.text = model.unAlbleMsg
        
        self.tagArr = model.tagList.filter{ $0.tagImg != "" }
        self.collection.reloadData()
    }
    
}
