//
//  DateSelectView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit

class DateSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectItemBlock: VoidIntBlock?
    
    private var dateList: [DateModel] = []
    
    private var selectDate: String = ""
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: S_W / 7, height: 65)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DateScheCollCell.self, forCellWithReuseIdentifier: "DateScheCollCell")
        return coll
    }()
    
    
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
        return dateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateScheCollCell", for: indexPath) as! DateScheCollCell
        
        var isSel: Bool = false
        if dateList[indexPath.item].yearDate == selectDate {
            isSel = true
        } else {
            isSel = false
        }
        
        cell.setCellData(date: dateList[indexPath.item], isSelect: isSel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dateList[indexPath.item].yearDate != selectDate {
            selectDate = dateList[indexPath.item].yearDate
            collection.reloadData()
            selectItemBlock?(indexPath.item)
        }
        
    }

    func setData(timeList: [DateModel], curDate: String) {
        dateList = timeList
        selectDate = curDate
        collection.reloadData()
    }
    
}


class DateScheCollCell: UICollectionViewCell {
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(11), .center)
        lab.text = "web"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(11), .center)
        lab.text = "11-24"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.centerY).offset(-5)
        }
        
        contentView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentView.snp.centerY).offset(5)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(date: DateModel, isSelect: Bool) {
        tlab1.text = date.week
        tlab2.text = date.monthDate
        
        if isSelect {
            tlab1.textColor = HCOLOR("#465DFD")
            tlab2.textColor = HCOLOR("#465DFD")
        } else {
            tlab1.textColor = HCOLOR("#999999")
            tlab2.textColor = HCOLOR("#999999")
        }
    }
    
}

