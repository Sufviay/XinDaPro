//
//  ListTagView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit

class ListTagView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    var selectTagItemBlock: VoidIntBlock?
    
    private var titleArr: [String] = ["Confirmed", "Check In", "Cancelled", "Record"]

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
        coll.backgroundColor = HCOLOR("F5F7F9")
        coll.showsHorizontalScrollIndicator = false
        coll.register(ListTagCollectionCell.self, forCellWithReuseIdentifier: "ListTagCollectionCell")
        return coll
    }()
    
    
    private var selectIdx: Int = 0
    

 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListTagCollectionCell", for: indexPath) as! ListTagCollectionCell
            
        cell.setCellData(titStr: titleArr[indexPath.item], isSel: (selectIdx == indexPath.item ? true : false))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = titleArr[indexPath.item].getTextWidth(BFONT(14), 15) + 25
        return CGSize(width: w, height: 35)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != selectIdx {
            selectIdx = indexPath.item
            selectTagItemBlock?(indexPath.item)
            collectionView.reloadData()
        }
    }
    
}

class ListTagCollectionCell: UICollectionViewCell {
    
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(13), .center)
        lab.text = "New"
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        view.layer.cornerRadius = 1
        return view
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 2))
            $0.top.equalTo(titlab.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellData(titStr: String, isSel: Bool) {
        if isSel {
            contentView.backgroundColor = .white
            titlab.textColor = HCOLOR("465DFD")
            line.isHidden = false
        } else {
            contentView.backgroundColor = HCOLOR("F5F7F9")
            titlab.textColor = HCOLOR("5C5D70")
            line.isHidden = true

        }
        
        titlab.text = titStr
    }
    
    
}
