//
//  DishEditeTagCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/24.
//

import UIKit

class DishEditeTagCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var selectBlock: VoidBlock?
    var deleteBlock: VoidBlock?
    
    private var tagArr: [DishDetailTagModel] = []

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Food tags".local
        return lab
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sj_show"), for: .normal)
        return but
    }()
    
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(DishEditeTagsCell.self, forCellWithReuseIdentifier: "DishEditeTagsCell")
        return coll
    }()
    
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(17)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview()
        }
    
        backView.addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
            $0.size.equalTo(CGSize(width: 40, height: 30))
        }
        
        backView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-50)
            $0.height.equalTo(25)
            $0.centerY.equalToSuperview()
        }
        
        selectBut.addTarget(self, action: #selector(clickSelectAciton), for: .touchUpInside)
        
    }
    
    
    @objc private func clickSelectAciton() {
        self.selectBlock?("")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishEditeTagsCell", for: indexPath) as! DishEditeTagsCell
        cell.tagLab.text = tagArr[indexPath.item].name1
        
        cell.deleteTagBlock = { [unowned self] (_) in
            self.tagArr.remove(at: indexPath.item)
            self.deleteBlock?(tagArr)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = tagArr[indexPath.item].name1.getTextWidth(TIT_3, 25) + 40
        return CGSize(width: w, height: 25)
    }
    
    func setCellData(modelArr: [DishDetailTagModel]) {
        self.tagArr = modelArr
        self.collection.reloadData()
    }
    
}




class DishEditeTagsCell: UICollectionViewCell {
    
    var deleteTagBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#465DFD")
        view.layer.cornerRadius = 25 / 2
        return view
    }()
    
    let tagLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_3, .left)
        lab.text = "beef"
        return lab
    }()
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("tag_cancel"), for: .normal)
        return but
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo((CGSize(width: 25, height: 25)))
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        
        }
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDeleteAction() {
        self.deleteTagBlock?("")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
