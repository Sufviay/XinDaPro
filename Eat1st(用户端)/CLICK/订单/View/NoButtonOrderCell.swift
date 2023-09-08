//
//  NoButtonOrderCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/17.
//

import UIKit

class NoButtonOrderCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    private var dataModel = OrderListModel()

    private var imgArr: [String] = [] {
        didSet {
            self.collection.reloadData()
        }
    }

    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_logo")
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(13), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "name"
        return lab
    }()
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "Completed"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .right)
        lab.text = "10.9"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .right)
        lab.text = "x2"
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HOLDCOLOR
        return view
    }()
    
    private let orderIDLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .left)
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(10), .right)
        return lab
    }()
    
    
    private let co_W: CGFloat = (S_W - 125 - 15) / 4

    
    
    private lazy var collection: GestureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: co_W , height: co_W)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = GestureCollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.isUserInteractionEnabled = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsHorizontalScrollIndicator = false
        coll.register(ImgCollectionCell.self, forCellWithReuseIdentifier: "ImgCollectionCell")
        return coll
    }()
    

    private let typeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(16), .left)
        lab.text = "Delivery"
        return lab
    }()

    
    private let goImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("GO")
        return img
    }()
    
    
    override func setViews() {
        self.contentView.backgroundColor = .white
        
        
//        contentView.addSubview(backView)
//        backView.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(-10)
//        }
        
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-95)
            $0.height.equalTo(co_W)
            $0.top.equalToSuperview().offset(80)
        }
        
        contentView.addSubview(typeLab)
        typeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(goImg)
        goImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 20))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        
        contentView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
            $0.top.equalTo(typeLab.snp.bottom).offset(15)
        }

        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalTo(statusLab.snp.left).offset(-20)
            $0.centerY.equalTo(statusLab)
        }
                
        contentView.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.right.equalTo(nameLab.snp.left).offset(-3)
            $0.centerY.equalTo(nameLab)
        }
        
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(collection.snp.top).offset(10)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.bottom.equalTo(moneyLab).offset(-3)
            $0.right.equalTo(moneyLab.snp.left).offset(-2)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.top.equalTo(moneyLab.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(orderIDLab)
        orderIDLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(collection.snp.bottom).offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(orderIDLab)
            $0.right.equalToSuperview().offset(-10)
        }
        
    }
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "ImgCollectionCell", for: indexPath) as! ImgCollectionCell
        cell.picImg.sd_setImage(with: URL(string: imgArr[indexPath.item]), placeholderImage: HOLDIMG)
        return cell
    }

    
    func setCellData(model: OrderListModel) {
        self.dataModel = model
        self.imgArr = model.dishImgArr
        self.nameLab.text = model.name
        self.statusLab.text = model.statusStr
        self.countLab.text = "x\(model.dishCount)"
        self.moneyLab.text = D_2_STR(model.amountTotal)
        self.orderIDLab.text = "#" + model.orderID
        self.timeLab.text = model.createTime
        
        if model.prizeStatus {
            self.goImg.isHidden = false
        } else {
            self.goImg.isHidden = true
        }
        
        
        if model.type == "1" {
            typeLab.text = "Delivery"
        }
        if model.type == "2" {
            typeLab.text = "Collection"
        }
        if model.type == "3" {
            typeLab.text = "Dine-in"
        }
        
        let status_W = model.statusStr.getTextWidth(BFONT(15), 20)
        self.statusLab.snp.updateConstraints {
            $0.width.equalTo(status_W + 5)
        }
    

    }

    
}


class ImgCollectionCell: UICollectionViewCell {
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.backgroundColor = HOLDCOLOR
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


