//
//  OrderTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/18.
//

import UIKit
import SwiftyJSON

class StatusTagModel: NSObject {
    
    var name: String = ""
    var key: String = ""
    var id: String = ""
    var num: Int = 0
    
    func updateModel(json: JSON) {
        self.name = json["tabName"].stringValue
        self.key = json["tabKey"].stringValue
        self.id = json["tabId"].stringValue
        self.num = json["num"].intValue
    }
}


class OrderTagView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var tagArr: [StatusTagModel] = [] {
        didSet {
            self.collection.reloadData()
        }
    }
    
    var selectIdx: Int = 0 {
        didSet {
            self.collection.reloadData()
        }
    }

    var clickBlock: VoidBlock?
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
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
        
        self.backgroundColor = .clear
        
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
        //let isSelect = selectIdx == indexPath.item ? true : false
        //cell.setCell(str: tagArr[indexPath.item].name, num: tagArr[indexPath.item].num, select: isSelect)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let str = tagArr[indexPath.item].name
        let w = str.getTextWidth(BFONT(11), 11) + 50
        return CGSize(width: w, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectIdx != indexPath.item {
            self.selectIdx = indexPath.item
            collectionView.reloadData()
            clickBlock?(indexPath.item)
        }
    }

    
}




