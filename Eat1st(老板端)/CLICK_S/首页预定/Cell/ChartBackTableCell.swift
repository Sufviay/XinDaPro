//
//  ChartBackTableCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit

class ChartBackTableCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    var clickBlock: VoidBlock?

    private var canPostScroll: Bool = false
    private var dataModel = BookChartDataModel()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ChatTableLabCell.self, forCellReuseIdentifier: "ChatTableLabCell")
        tableView.tag = 2
        return tableView
    }()
    
    
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
        coll.tag = 1
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(ChartTimeCollectionCell.self, forCellWithReuseIdentifier: "ChartTimeCollectionCell")
        return coll
    }()
    
    

    override func setViews() {
        
        addCenterNotification()
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(table.snp.right)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lineCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableLabCell") as! ChatTableLabCell
        cell.titLab.text = String(indexPath.row + 1)
        cell.titLab.textColor = TXTCOLOR_1
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let h = CGFloat(dataModel.lineCount) * 45
        return CGSize(width: 80, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.timeArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartTimeCollectionCell", for: indexPath) as! ChartTimeCollectionCell
        
        cell.clickBlock = { [unowned self] (model) in
            clickBlock?(model)
        }
        
        cell.setCellData(lineCount: dataModel.lineCount, timeModel: dataModel.timeArr[indexPath.item])
        return cell
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tagValue = scrollView.tag
        if tagValue == 1 {
            //滑动了发送通知
            
            if canPostScroll {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bootomOffset"), object: scrollView.contentOffset)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canPostScroll = true
    }
    
    //注册通知监听预订信息表格的滑动
    private func addCenterNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginScrol(info:)), name: NSNotification.Name(rawValue: "topOffset"), object: nil)
    }
    
    @objc private func beginScrol(info: Notification) {
        let offset = info.object as! CGPoint
        canPostScroll = false
        collection.setContentOffset(offset, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "topOffset"), object: nil)
    }
    
    
    func setCellData(model: BookChartDataModel) {
        dataModel = model
        table.reloadData()
        collection.reloadData()
    }


}


class ChatTableLabCell: BaseTableViewCell {
    
    let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_5, .center)
        lab.lineBreakMode = .byTruncatingTail
        lab.numberOfLines = 2
        return lab
    }()
    
    override func setViews() {
        
        contentView.backgroundColor = HCOLOR("#F1F8FF")
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


