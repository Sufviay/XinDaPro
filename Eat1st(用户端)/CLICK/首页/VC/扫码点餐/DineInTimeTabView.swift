//
//  DineInTimeTabView.swift
//  CLICK
//
//  Created by 肖扬 on 2024/3/26.
//

import UIKit

class DineInTimeTabView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    private var dataArr: [OpenTimeModel] = []
    private var selectIdx: Int = 100
    
    var selectBlock: VoidBlock?
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(TimeSelectCollCell.self, forCellWithReuseIdentifier: "TimeSelectCollCell")
        return coll
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collection)
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSelectCollCell", for: indexPath) as! TimeSelectCollCell
        let sel = indexPath.item == selectIdx ? true : false
        cell.setCellData(model: dataArr[indexPath.item], isSelect: sel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != selectIdx {
            selectIdx = indexPath.item
            collectionView.reloadData()
            selectBlock?(selectIdx)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if dataArr.count == 1 {
            return CGSize(width: S_W, height: 40)
        }
        if dataArr.count == 2 {
            return CGSize(width: S_W / 2, height: 40)
        }
        if dataArr.count == 3 {
            return CGSize(width: S_W / 3, height: 40)
        }
        return CGSize(width: S_W / 4 , height: 40)
        
    }
    
    
    func setData(timeArr: [OpenTimeModel], selectIdx: Int) {
        self.dataArr = timeArr
        self.selectIdx = selectIdx
        collection.reloadData()
    }

}
