//
//  OrderTSImageCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/16.
//

import UIKit

class OrderTSImageCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate, CommonToolProtocol {

    private var dataMoel = OrderDetailModel()

    private lazy var picColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let W = (S_W - 80) / 5
        layout.itemSize = CGSize(width: W , height: W)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
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
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        
        contentView.addSubview(picColleciton)
        picColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataMoel.tsImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicImgCell", for: indexPath) as! PicImgCell
        cell.picImg.sd_setImage(with: URL(string: dataMoel.tsImgArr[indexPath.item]), completed: nil)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //放大图片
        self.showImage(picColleciton, self.dataMoel.tsImgArr.count, indexPath.item)
        
    }
    
    
    
    func setCellData(model: OrderDetailModel) {
        
        self.dataMoel = model
        self.picColleciton.reloadData()
                
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL(string: self.dataMoel.tsImgArr[index])
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return nil
    }

}


class PicImgCell: UICollectionViewCell {
    
    var deleteBlock: VoidBlock?
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
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
    
    @objc func clickCloseAciton() {
        deleteBlock?("")
    }
}

class AddImgCell: UICollectionViewCell {
    
    
    private let addImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("addImg")
        return img
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addImg)
        addImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
