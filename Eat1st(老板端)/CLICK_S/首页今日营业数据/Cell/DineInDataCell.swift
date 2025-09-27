//
//  DineInDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/1/3.
//

import UIKit

class DineInDataCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    private var dataModel = SalesDataModel()
    
//    private var selectType: String = ""
    
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
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Dine-in".local
        return lab
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DataInfoCollectionCell.self, forCellWithReuseIdentifier: "DataInfoCollectionCell")
        coll.register(DataInfoCell_People.self, forCellWithReuseIdentifier: "DataInfoCell_People")
        return coll
    }()

    
    

    override func setViews() {
        
        
        //20 + 85 30 80 270
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
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
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == 1 {
            return CGSize(width: (S_W - 90) / 2, height: 80)
        }
        return CGSize(width: (S_W - 90) / 2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataInfoCell_People", for: indexPath) as! DataInfoCell_People
            cell.setCellData(number: String(dataModel.totalUserNums), crNum: String(dataModel.adultNum), etNum: String(dataModel.childNum), compareNum: String(dataModel.prevTotalUserNums), floatingType: dataModel.prevTotalUserNumsType, week: dataModel.weekStr)
            return cell
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataInfoCollectionCell", for: indexPath) as! DataInfoCollectionCell
            
            if indexPath.row == 0 {
                
                cell.setCellData(titStr: "Unpaid Amount".local, number: "£" + D_2_STR(dataModel.notSettlePrice), compareNum: "", floatingType: "", week: "")
            }
            
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Unpaid Order".local, number: String(dataModel.notSettleOrders), compareNum: "", floatingType: "", week: "")
            }
            
            if indexPath.row == 2 {
                cell.setCellData(titStr: "Sales".local, number: "£" + D_2_STR(dataModel.settlePrice), compareNum: D_2_STR(dataModel.prevSettlePrice), floatingType: dataModel.prevSettlePriceType, week: dataModel.weekStr)
            }
            
            if indexPath.row == 3 {
                cell.setCellData(titStr: "Order".local, number: String(dataModel.settleOrders), compareNum: String(dataModel.prevSettleOrders), floatingType: dataModel.prevSettleOrdersType, week: dataModel.weekStr)
            }
            
            
            if indexPath.row == 4 {
                cell.setCellData(titStr: "Avg per Customer".local, number: "£" + D_2_STR(dataModel.averagePrice), compareNum: D_2_STR(dataModel.prevAveragePrice), floatingType: dataModel.prevAveragePriceType, week: dataModel.weekStr)
            }

            

            
            if indexPath.row == 6 {
                cell.setCellData(titStr: "Avg per Table".local, number: "£" + D_2_STR(dataModel.curDeskPrice), compareNum: D_2_STR(dataModel.prevDeskPrice), floatingType: dataModel.deskPriceType, week: dataModel.weekStr)
            }

            
            if indexPath.row == 7 {
                cell.setCellData(titStr: "Table".local, number: String(dataModel.curDeskNums), compareNum: String(dataModel.prevDeskNums), floatingType: dataModel.deskNumsType, week: dataModel.weekStr)
            }

            return cell

        }
        
    }
    
    
    ///1今日，2本周，3本月
    func setCellData(model: SalesDataModel) {
        dataModel = model
        collection.reloadData()
        
    }
    
}






