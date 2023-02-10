//
//  FirstSideToolViewCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit


class SideCouponsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#144DDE"), BFONT(17), .left)
        lab.text = "New user coupons"
        return lab
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 230 , height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = true
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsHorizontalScrollIndicator = false
        coll.register(SideCouponsCollectionCell.self, forCellWithReuseIdentifier: "SideCouponsCollectionCell")
        return coll
    }()
    
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(110)
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "SideCouponsCollectionCell", for: indexPath)
        return cell
    }
}


class SideCouponsCollectionCell: UICollectionViewCell {
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("side_coupon")
        return img
    }()

    private let clickBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "click", HCOLOR("#144DDE"), SFONT(14), .clear)
        return but
    }()
    
    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#144DDE"), BFONT(28), .left)
        lab.text = "20"
        return lab
    }()
    
    private let s_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#144DDE"), SFONT(14), .left)
        lab.text = "£"
        return lab
    }()
    
    ///满减条件
    private let tjLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Full £60 minus"
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        contentView.addSubview(clickBut)
        clickBut.snp.makeConstraints {
            $0.centerY.right.equalToSuperview()
            $0.width.equalTo(230 / 4)
            $0.height.equalTo(50)
        }
        
        
        contentView.addSubview(tjLab)
        tjLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.left.equalToSuperview().offset(15)
        }
        
    
        contentView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(s_lab)
        s_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalTo(moneylab.snp.bottom).offset(-4)
        }
        
        clickBut.addTarget(self, action: #selector(clickAciton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 点击领取
    @objc private func clickAciton() {
        
    }

}


class SideOptionCell: BaseTableViewCell {
    
    
    private let l_img: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("side_next")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        return lab
    }()
    

    override func setViews() {
        
        contentView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 22, height: 22))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()

        }

        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(48)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
        
    }
    
    func setCellData(imgStr: String, titStr: String) {        
        self.l_img.image = LOIMG(imgStr)
        self.titLab.text = titStr
    }
    
    
    
}
