//
//  FirstTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit

class FirstTagView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {


    private var tagArr: [String] = ["Booking", "Store revenue", "Live Reporting", "Menu items"]
    //, "Customer analysis"

    var selectIdx: Int = 0 {
        didSet {
            selectTagItemBlock?(selectIdx)
            collection.contentOffset
            collection.reloadData()
        }
    }
    
    var selectTagItemBlock: VoidIntBlock?
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: S_W / 3, height: 50)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(TagCollectionCell.self, forCellWithReuseIdentifier: "TagCollectionCell")
        return coll
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        
        
        self.addSubview(collection)
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionCell", for: indexPath) as! TagCollectionCell
        let isSelect = selectIdx == indexPath.item ? true : false
        cell.setCell(str: tagArr[indexPath.item], isSelect: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectIdx != indexPath.item {
            selectIdx = indexPath.item
        }
    }
    
    
    

}



class TagCollectionCell: UICollectionViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#05CBE7")
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    let taglab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#6F7FAF"), BFONT(13), .center)
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        
        contentView.addSubview(taglab)
        taglab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-3)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 4))
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(str: String, isSelect: Bool)  {
        self.taglab.text = str
        if isSelect {
            self.taglab.textColor = HCOLOR("#080808")
            self.line.isHidden = false
        } else {
            self.taglab.textColor = HCOLOR("#6F7FAF")
            self.line.isHidden = true
        }
        
    }
    
}

