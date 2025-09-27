//
//  OtherDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/5/7.
//

import UIKit

class OtherDataCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    private var dataModel = SalesDataModel()
    
    private var titleStr: String = "" {
        didSet {
            titLab.text = titleStr
        }
    }

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
        lab.text = "Takeaway".local
        return lab
    }()
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let w = (S_W - 90) / 2
        layout.itemSize = CGSize(width: w, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DataInfoCell_Other.self, forCellWithReuseIdentifier: "DataInfoCell_Other")
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataInfoCell_Other", for: indexPath) as! DataInfoCell_Other
        
        
        if titLab.text == "Uber Eats" {
            if indexPath.row == 0 {

                cell.setCellData(titStr: "Sales".local, number: "£" + D_2_STR(dataModel.uberPrice), compareNum: D_2_STR(dataModel.uberPrevPrice), floatingType: dataModel.uberPrevPriceType, week: dataModel.weekStr)

            }
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Order".local, number: String(dataModel.uberNums), compareNum: String(dataModel.uberPrevNums), floatingType: dataModel.uberPrevNumsType, week: dataModel.weekStr)
            }

        }
        if titLab.text == "Deliveroo" {
            
            if indexPath.row == 0 {

                cell.setCellData(titStr: "Sales".local, number: "£" + D_2_STR(dataModel.deliverooPrice), compareNum: D_2_STR(dataModel.deliverooPrevPrice), floatingType: dataModel.deliverooPrevPriceType, week: dataModel.weekStr)

            }
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Order".local, number: String(dataModel.deliverooNums), compareNum: String(dataModel.deliverooPrevNums), floatingType: dataModel.deliverooPrevNumsType, week: dataModel.weekStr)
            }

        }
        
    
        return cell
        
    }

    
    ///1今日，2本周，3本月
    func setCellData(titStr: String, model: SalesDataModel) {
        titleStr = titStr
        dataModel = model
        collection.reloadData()
        
    }



    
    
}
