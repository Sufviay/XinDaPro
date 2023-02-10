//
//  BuyedGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/2.
//

import UIKit

class BuyedGoodsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {


    private lazy var collection: GestureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 220 , height: 85)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        let coll = GestureCollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsHorizontalScrollIndicator = false
        coll.register(BuyedCollectionCell.self, forCellWithReuseIdentifier: "BuyedCollectionCell")
        return coll
        
    }()
    
    override func setViews() {
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "BuyedCollectionCell", for: indexPath) as! BuyedCollectionCell
        return cell
    }
    
}



class BuyedCollectionCell: UICollectionViewCell {
   
    
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = BACKCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.backgroundColor = HOLDCOLOR
        return img
    }()

    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Spicy burger"
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(13), .left)
        lab.text = "Ingredients: beef"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(11), .left)
        lab.text = "£"
        return lab
    }()
    
    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .left)
        lab.text = "4.8"
        return lab
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = HCOLOR("#EDEDED").cgColor
        // 阴影偏移，默认(0, -3)
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        contentView.layer.shadowOpacity = 1
        // 阴影半径，默认3
        contentView.layer.shadowRadius = 2

    
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 70))
            $0.left.equalToSuperview().offset(7)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(goodsImg.snp.right).offset(10)
            $0.top.equalTo(goodsImg)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(desLab.snp.bottom).offset(13)
        }
        
        contentView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.left.equalTo(s_lab.snp.right)
            $0.bottom.equalTo(s_lab).offset(2)
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
