//
//  BookingTimeView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/2/17.
//

import UIKit

class BookingTimeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var canPostScroll: Bool = false
    
    private var dataArr: [ChartBookTimeModel] = []
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_3, TIT_5, .center)
        lab.text = "NUMBER"
        lab.backgroundColor = HCOLOR("#F1F8FF")
        return lab
    }()
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 80, height: 40)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = HCOLOR("#DFEFFF")
        coll.showsHorizontalScrollIndicator = false
        coll.register(TimeHeadCollectCell.self, forCellWithReuseIdentifier: "TimeHeadCollectCell")
        return coll
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCenterNotification()
        
        addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.top.bottom.left.equalToSuperview()
        }
        
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(tlab.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeHeadCollectCell", for: indexPath) as! TimeHeadCollectCell
        cell.titLab.text = dataArr[indexPath.item].reserveTime
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(canPostScroll)
        
        if canPostScroll {
            //滑动了发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topOffset"), object: scrollView.contentOffset)
        }
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canPostScroll = true
    }
    
    func setData(timeArr: [ChartBookTimeModel]) {
        
        dataArr = timeArr
        collection.reloadData()
    }
    
    
    //注册通知监听预订信息表格的滑动
    private func addCenterNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginScrol(info:)), name: NSNotification.Name(rawValue: "bootomOffset"), object: nil)
    }
    
    @objc private func beginScrol(info: Notification) {
        let offset = info.object as! CGPoint
        canPostScroll = false
        collection.setContentOffset(offset, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "bootomOffset"), object: nil)
    }
    
    
}




class TimeHeadCollectCell: UICollectionViewCell {
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_5, .center)
        return lab
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E5E5E5")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E5E5E5")
        return view
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = HCOLOR("#DFEFFF")
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
