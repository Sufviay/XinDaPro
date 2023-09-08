//
//  ComplaintsPictureCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/17.
//

import UIKit

class ComplaintsPictureCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    
    private var imgArr: [String] = []
    
    private lazy var picColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let W = (S_W - 20 - 40) / 5
        layout.itemSize = CGSize(width: W , height: W)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsVerticalScrollIndicator = false
        coll.register(PicImgCell.self, forCellWithReuseIdentifier: "PicImgCell")
        return coll
    }()
    
    

    override func setViews() {
        
        
        contentView.addSubview(picColleciton)
        picColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicImgCell", for: indexPath) as! PicImgCell
        cell.picImg.sd_setImage(with: URL(string: imgArr[indexPath.item]))
        return cell
    }
    
    
    func setCellData(imgs: [String]) {
        imgArr = imgs
        picColleciton.reloadData()
    }

    
}


class PicImgCell: UICollectionViewCell {
    
    var deleteBlock: VoidBlock?
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}


