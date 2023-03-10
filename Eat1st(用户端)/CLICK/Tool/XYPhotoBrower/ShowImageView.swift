//
//  ShowImageView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/16.
//

import UIKit

class ShowImageView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {


    var imgArr : [UIImage] = []
    
    var dismissCallBack: (() -> Void)?
    
    //删除
    var deleteCallBack: (([UIImage]) -> Void)?
    
    let duration = 0.3
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionPageFlowLayout.init() // 给分页添加间距
        layout.sectionHeadersPinToVisibleBounds = true
        layout.scrollDirection = .horizontal

        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: S_W, height: S_H)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alwaysBounceVertical = false // 不允许上下弹跳
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        return collectionView
    }()
    
    
    private lazy var deleteBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .black.withAlphaComponent(0.4)
        but.setImage(LOIMG("shanchu"), for: .normal)
        but.layer.cornerRadius = 30
        return but
    }()
    
    
    init(imgArr: [UIImage], number: Int) {
        super.init(frame: .zero)
        
        self.frame = CGRect(x: 0, y: 0, width: S_W, height: S_H)
        self.backgroundColor = .black
        showImages(Images: imgArr, number: number)
        addDeleteBut()
    }
    
    
    func showImages(Images: [UIImage], number: Int) {
        
        self.imgArr = Images
        self.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: S_W, height: S_H)
        self.collectionView.scrollToItem(at: IndexPath(item: number, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func addDeleteBut() {
        deleteBut.frame = CGRect(x: S_W - 80, y: statusBarH + 10, width: 60, height: 60)
        self.addSubview(deleteBut)
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDeleteAction() {
        
        //当前的下标
        
        let index = Int(self.collectionView.contentOffset.x / S_W)
        print(index)
        self.imgArr.remove(at: index)
        self.collectionView.reloadData()
        self.deleteCallBack?(self.imgArr)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension ShowImageView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.image = self.imgArr[indexPath.item]
        
        // pan手势
        cell.backRemoveCallBack = { [weak self] in
            guard let `self` = self else { return }
            self.backRemoveAnimation(self.duration)
        }
        // 点击手势
        cell.tapMoveCallBack = {[weak self] (imgView) in
            guard let `self` = self else { return }
            self.removeAnimation(imgView)
        }
        cell.changeAlphaCallBack = { [weak self] (alpha) in
            guard let `self` = self else { return }
            self.changeBackAlpha(alpha: alpha)
        }

        
        return cell
    }
    
    
}


//MARK: - 动画
extension ShowImageView {
    /**
     视图将要显示时获取到第一次要显示的Cell上的ImageView来显示动画
     */
    
    public func transformAnimation() {
        //第一次弹出的动画
        collectionView.reloadData()
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        
        guard let indexpath = collectionView.indexPathForItem(at: collectionView.contentOffset) else {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexpath) as? CollectionViewCell else {
            return
        }
        
        self.showAnimation()
        self.transformScaleAnimation(fromValue: 0.3, toValue: 1, duration: 0.3, view: cell.imgView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            // 赋值方法中imageview重新布局
            self.collectionView.reloadData()
        }
        
    
    }
    
    
    
    func showAnimation() {
   
        let backAnimation = CAKeyframeAnimation()
        backAnimation.keyPath = "opacity"
        backAnimation.duration = duration
        backAnimation.values = [
            NSNumber(value: 0.10 as Float),
            NSNumber(value: 0.40 as Float),
            NSNumber(value: 0.80 as Float),
            NSNumber(value: 1.0 as Float),
        ]
        backAnimation.keyTimes = [
            NSNumber(value: 0.1),
            NSNumber(value: 0.2),
            NSNumber(value: 0.3),
            NSNumber(value: 0.4)
        ]
        backAnimation.fillMode = CAMediaTimingFillMode.forwards
        backAnimation.isRemovedOnCompletion = false
        self.layer.add(backAnimation, forKey: nil)
    }
    
    
    // 缩放
    func transformScaleAnimation(fromValue: CGFloat,toValue: CGFloat,duration: CFTimeInterval,view: UIView) {
        let scale = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.fromValue = fromValue
        scale.toValue = toValue
        scale.duration = duration
        scale.fillMode = CAMediaTimingFillMode.forwards
        scale.isRemovedOnCompletion = false
        view.layer.add(scale, forKey: nil)
    }
    
    // 背景变淡消失的动画
    func backRemoveAnimation(_ duration: CFTimeInterval) {
        let backAnimation = CAKeyframeAnimation()
        backAnimation.delegate = self
        backAnimation.keyPath = "opacity"
        backAnimation.duration = duration
        backAnimation.values = [
            NSNumber(value: 0.90 as Float),
            NSNumber(value: 0.60 as Float),
            NSNumber(value: 0.30 as Float),
            NSNumber(value: 0.0 as Float),
            
        ]
        backAnimation.keyTimes = [
            NSNumber(value: 0.1),
            NSNumber(value: 0.2),
            NSNumber(value: 0.3),
            NSNumber(value: 0.4)
        ]
        backAnimation.fillMode = CAMediaTimingFillMode.forwards
        backAnimation.isRemovedOnCompletion = false
        self.layer.add(backAnimation, forKey: nil)
    }
    
    
    // 缩放 + 淡入淡出
    func removeAnimation(_ imgView: UIView) {
        if imgView.frame.size.height <= S_H {
            self.transformScaleAnimation(fromValue: 1.0, toValue: 0.3, duration: 0.3, view: imgView)
        }
        self.backRemoveAnimation(duration)
    }
    
    
    func changeBackAlpha(alpha: CGFloat) {
        self.backgroundColor = UIColor.black.withAlphaComponent(alpha)
    }


}


extension ShowImageView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if anim.isKind(of: CAKeyframeAnimation.self) && flag {
            self.dismissCallBack?()
        }

        print("aaaaaa")
    }
    
}
