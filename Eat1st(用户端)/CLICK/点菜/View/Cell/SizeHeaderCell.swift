//
//  SizeHeaderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/14.
//

import UIKit

class SizeHeaderCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


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
        return coll
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(R_W(375) * (9/16))
            //$0.height.equalTo(SET_H(250, 375))
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(headImg.snp.bottom).offset(-40)
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
            $0.height.equalTo(14)
            $0.right.equalToSuperview().offset(-20)
        }
        
    
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(collection.snp.bottom).offset(7)
        }
    
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.left.equalTo(tlab.snp.right).offset(5)
            $0.top.equalTo(collection.snp.bottom).offset(5)
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
            $0.top.equalTo(moneyLab.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-90)
        }
        
        backView.addSubview(gmyLab)
        gmyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-70)
            $0.top.equalTo(desLab.snp.bottom).offset(20)
        }
        
        backView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 15, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(gmyLab)
        }

    }
    
    func setCellData(model: DishModel, selectCount: Int)  {
        
        if model.specification.count == 0 {
            self.tlab.text = ""
        } else {
            self.tlab.text = "from"
        }
        
        self.headImg.setImage(imageStr: model.detailImgArr[0])
        self.nameLab.text = model.name_E
        self.desLab.text = model.des
        //self.countLab.text = "\(model.sales) sold"
        self.selectView.count = selectCount
        self.gmyLab.text = "Allergen: " +  model.allergen
        
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
