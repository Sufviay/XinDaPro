//
//  BookingTimeCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit

class BookingTimeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {


    var selectItemBlock: VoidStringBlock?
    
    private var timeArr: [BookingTimeModel] = []
    
    ///选择的下标
    //private var selectIdx: Int = 1000
    
    private var selectID: String = ""
    
    ///填写的预约人数
    private var reserveNum: Int = 0

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Please choose a time below"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (S_W - 60) / 3, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(TimeCollCell.self, forCellWithReuseIdentifier: "TimeCollCell")
        return coll
    }()

    
    


    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
            $0.bottom.equalToSuperview().offset(-20)
        }
        

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollCell", for: indexPath) as! TimeCollCell
        
        var canSel: Bool = true
        var isSel: Bool = false
        
        let model = timeArr[indexPath.item]
        
        if model.expire {
            canSel = false
        } else {
            canSel = true
            if model.reserveId == selectID {
                isSel = true
            } else {
                isSel = false
            }
        }
        cell.setCellData(time: timeArr[indexPath.item].reserveTime, isSelect: isSel, canSelect: canSel)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = timeArr[indexPath.item]
        
        if !model.expire {
                            
            if selectID == model.reserveId {
                selectID = ""
            } else {
                selectID = model.reserveId
            }
            
            collectionView.reloadData()
            selectItemBlock?(selectID)
                
        }
        
    }
    
    func setCellData(timeList: [BookingTimeModel], inputCount: Int, timeID: String) {
        timeArr = timeList
        reserveNum = inputCount
        selectID = timeID
        collection.reloadData()
    }
    
    
    
}

class TimeCollCell: UICollectionViewCell {
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(10), .center)
        lab.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 3
        lab.layer.borderColor = HCOLOR("#465DFD").cgColor
        return lab
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(time: String, isSelect: Bool, canSelect: Bool) {
        titlab.text = time
        
        if canSelect {
            if isSelect {
                titlab.textColor = .black
                titlab.layer.borderWidth = 1
            } else {
                titlab.textColor = .black
                titlab.layer.borderWidth = 0
            }
        } else {
            titlab.textColor = HCOLOR("#CCCCCC")
            titlab.layer.borderWidth = 0
        }
        

    }
    
    
}
