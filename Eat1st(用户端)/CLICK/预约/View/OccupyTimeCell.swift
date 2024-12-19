//
//  OccupyTimeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2024/4/9.
//

import UIKit

class OccupyTimeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var dataArr: [OccupyTimeModel] = []
    
    private var selectedID: String = ""
    
    private var reserveNum: Int = 0
    
    var selectTimeBlock: VoidStringBlock?

    private lazy var collection: GestureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let w = (S_W - 60) / 3
        layout.itemSize = CGSize(width: w , height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = GestureCollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsHorizontalScrollIndicator = false
        coll.register(OccupyTimeOptionCell.self, forCellWithReuseIdentifier: "OccupyTimeOptionCell")
        return coll
        
    }()

    
    
    
    override func setViews() {
        
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(40)
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OccupyTimeOptionCell", for: indexPath) as! OccupyTimeOptionCell
        
        var canSelect: Bool = true
        var isSel: Bool = false
        
        let model = dataArr[indexPath.item]
        
        if model.expire {
            canSelect = false
        } else {
            if model.reserveNum < reserveNum {
                canSelect = false
            } else {
                canSelect = true
                if model.reserveId == selectedID {
                    isSel = true
                } else {
                    isSel = false
                }
            }
        }
        
        cell.setCellData(model: model, isSelect: isSel, canSel: canSelect)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.item]
        if !model.expire {
            if model.reserveNum >= reserveNum {
                if selectedID == model.reserveId {
                    selectedID = ""
                } else {
                    selectedID = model.reserveId
                }
            }
        }
        collectionView.reloadData()
        selectTimeBlock?(selectedID)
    }
    

    
    
    func setCellData(arr: [OccupyTimeModel], selID: String, inputNum: Int) {
        
        dataArr = arr
        selectedID = selID
        reserveNum = inputNum
        collection.reloadData()
    }
    
    
}
