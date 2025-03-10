//
//  TakeOutDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/3.
//

import UIKit

class TakeOutDataCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    private var dataModel = SalesDataModel()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        
        view.layer.shadowColor = HCOLOR("#252275").withAlphaComponent(0.3).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#304FFF")
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(15), .left)
        lab.text = "Takeaway".local
        return lab
    }()
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let w = (S_W - 90) / 2
        layout.itemSize = CGSize(width: w, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DataInfoCollectionCell.self, forCellWithReuseIdentifier: "DataInfoCollectionCell")
        return coll
    }()
    


    override func setViews() {
        
        
        //30 85 90
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 4, height: 15))
            $0.top.equalToSuperview().offset(25)
        }
        
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalTo(line.snp.right).offset(10)
            $0.centerY.equalTo(line)
        }
        
        backView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-25)
            $0.top.equalToSuperview().offset(60)
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataInfoCollectionCell", for: indexPath) as! DataInfoCollectionCell
        
        if indexPath.row == 0 {
            cell.setCellData(titStr: "Sales".local, number: "£" + D_2_STR(dataModel.de_totalPrice), compareNum: D_2_STR(dataModel.de_prevTotalPrice), floatingType: dataModel.de_prevTotalPriceType, week: dataModel.weekStr)
        }
        if indexPath.row == 1 {
            cell.setCellData(titStr: "Order".local, number: String(dataModel.de_totalOrders), compareNum: String(dataModel.de_prevTotalOrders), floatingType: dataModel.de_prevTotalOrdersType, week: dataModel.weekStr)
        }
    
        return cell
        
    }

    
    ///1今日，2本周，3本月
    func setCellData(model: SalesDataModel) {
        dataModel = model
        collection.reloadData()
        
    }

    
}
