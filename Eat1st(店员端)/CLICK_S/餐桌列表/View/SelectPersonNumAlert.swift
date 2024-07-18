//
//  SelectPersonNumAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/4/25.
//

import UIKit

class SelectPersonNumAlert: BaseAlertView, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    var selectCountBlock: VoidBlock?
    
    
    private var ad_count: Int = 100
    
    private var ch_count: Int = 100
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", HCOLOR("#000000"), BFONT(13), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 10
        return but
    }()
    
    
    lazy var colleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(NumberCell.self, forCellWithReuseIdentifier: "NumberCell")
        coll.register(NumberHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NumberHeader")
        return coll
    }()

    
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
            $0.top.equalToSuperview().offset(statusBarH + 30)
        }
        
        
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(colleciton)
        colleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalTo(confirmBut.snp.top).offset(-15)
        }
        
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickConfirmAction() {
        var adNum: Int = 0
        var chNum: Int = 0
        if ad_count != 100 {
            adNum = ad_count
        }
        if ch_count != 100 {
            chNum = ch_count
        }
        selectCountBlock?([adNum, chNum])
        disAppearAction()
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        var isSel: Bool = false
        
        if indexPath.section == 0 {
            isSel = indexPath.item == ad_count ? true : false
        }
        if indexPath.section == 1 {
            isSel = indexPath.item == ch_count ? true : false
        }
        
        cell.setCellData(text: String(indexPath.item), isSel: isSel)
        return cell
        
    }
    
    
    
    //设置分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            //分区尾
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NumberHeader", for: indexPath) as! NumberHeader
            
            if indexPath.section == 0 {
                header.titLab.text = "Number of Adult"
            }
            if indexPath.section == 1 {
                header.titLab.text = "Number of Child"
            }
    
            return header

        }

        return UICollectionReusableView()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: S_W, height: 45)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 105) / 4 , height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.item == ad_count {
                ad_count = 100
            } else {
                ad_count = indexPath.item
            }
            
        }
        if indexPath.section == 1 {
            if indexPath.item == ch_count {
                ch_count = 100
            } else {
                ch_count = indexPath.item
            }

        }
        colleciton.reloadData()
        
    }
    
}
