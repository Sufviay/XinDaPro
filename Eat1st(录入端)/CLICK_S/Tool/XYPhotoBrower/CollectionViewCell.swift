//
//  CollectionViewCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/18.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    var backRemoveCallBack: (() -> Void)?
    var tapMoveCallBack:((_ view: UIView) -> Void)?
    var changeAlphaCallBack: ((_ value: CGFloat) -> Void)?
    
    
    lazy var backScroll: UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: S_W, height: S_H))
        scroll.delegate = self
        scroll.isPagingEnabled = false
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 4
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    

    
    var image: UIImage? {
        didSet {
            guard let imageV = image else {
                return
            }
            
            imgView.image = imageV
            let w = S_W
            let h = S_W / (imageV.size.width / imageV.size.height)
            
            if h > S_H {
                
                self.backScroll.contentSize = CGSize(width: S_W, height: h)
                self.backScroll.contentOffset = CGPoint(x: 0, y: 0)
                imgView.frame = CGRect(x: 0, y: 0, width: w, height: h)
            } else {
                let y = (S_H - h) / 2
                self.backScroll.contentSize = CGSize(width: S_W, height: S_H)
                self.backScroll.contentOffset = CGPoint(x: 0, y: 0)
                imgView.frame = CGRect(x: 0, y: y, width: w, height: h)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(backScroll)
        self.backScroll.addSubview(imgView)
        
        //添加点击手势
        self.addTapGesture(imageview: imgView, scroll: backScroll)
        //添加拖动手势
        self.addPanGesture(imgView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - 添加手势
extension CollectionViewCell: UIGestureRecognizerDelegate {
    
    //点击手势
    func addTapGesture(imageview: UIView, scroll: UIScrollView) {
        imgView.isUserInteractionEnabled = true
        scroll.isUserInteractionEnabled = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(imageClick(tap:)))
        doubleTap.numberOfTapsRequired = 2
        imageview.addGestureRecognizer(doubleTap)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        imageview.addGestureRecognizer(tap)
        scroll.addGestureRecognizer(tap)

        tap.require(toFail: doubleTap)
    }
    
    //拖动手势
    func addPanGesture(_ imageView: UIView) {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerAction(pan:)))
        imgView.addGestureRecognizer(pan)
        imgView.isUserInteractionEnabled = true
        pan.delegate = self

    }
    
    
    @objc func panRecognizerAction(pan: UIPanGestureRecognizer) {
        guard let imageview = pan.view else {
            return
        }
        guard let imgSuperView = imageview.superview else {
            return
        }
        let translation = pan.translation(in: imageview)
        if pan.state == .changed {
            imageview.center = CGPoint(x: imageview.center.x, y: imageview.center.y + translation.y)
            pan.setTranslation(.zero, in: imgSuperView)
            //滑动时改变背景透明度
            let alphaScale = abs(imageview.center.y - S_H / 2)
//            self.backView.backgroundColor = UIColor.black.withAlphaComponent((ScreenH - CGFloat(alphaScale)) / ScreenH)
            self.changeAlphaCallBack?(((S_H - CGFloat(alphaScale)) / S_H))
        }else if pan.state == .ended {
            
            // 如果偏移量大于某个值，直接划走消失，否则回归原位
            if imageview.center.y > S_H / 2 + 60 {
                self.imagePanRemoveAnimation(false, imageview: imageview)
            }else if imageview.center.y < S_H / 2 - 60 {
                self.imagePanRemoveAnimation(true, imageview: imageview)
            }else{
                // 回复原位
                let imgW = S_W
                let imgH = S_W * (imageview.frame.size.height) / (imageview.frame.size.width)
                let y = (S_H - imgH) / 2
                UIView.animate(withDuration: 0.3) {
                    //背景色不透明
                    self.changeAlphaCallBack?(1)
                    imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
                }
            }
        }
    }
    
    
    func imagePanRemoveAnimation(_ isTop: Bool,imageview: UIView) {
        let duration = 0.4
        if isTop {
            // 向上划走消失
            let imgW = S_W
            let imgH = S_W * (imageview.frame.size.height) / (imageview.frame.size.width)
            
            UIView.animate(withDuration: duration) {
                imageview.frame = CGRect(x: 0, y: -imgH , width: imgW, height: imgH)
            }
            
            self.backRemoveCallBack?()
        }else{
            // 向下划走消失
            let imgW = S_W
            let imgH = S_W * (imageview.frame.size.height) / (imageview.frame.size.width)
            
            UIView.animate(withDuration: duration) {
                imageview.frame = CGRect(x: 0, y: S_H, width: imgW, height: imgH)
            }
            
            self.backRemoveCallBack?()
        }
    }
    
    
    // 只允许上下起作用
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panView = gestureRecognizer.view else {
            return false
        }
        // 正在缩放的view，不支持手势
        guard panView.frame.size.width == S_W else{
            return false
        }
        // 长图不支持
        guard panView.frame.size.height <= S_H else{
            return false
        }
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let offset = panGesture.translation(in: panView)
            if offset.x == 0 && offset.y != 0 {
                return true
            }
        }
        
        return false
    }
    
}





//MARK: - 点击方法
extension CollectionViewCell {
    
    
    @objc func imageClick(tap: UITapGestureRecognizer) {
        var newscale: CGFloat = 0
        guard let scroll = tap.view?.superview as? UIScrollView else {
            return
        }
        
        if scroll.zoomScale == 1.0 {
            newscale = 3
        } else {
            newscale = 1.0
        }
        
        let zoomRect = self.zoomRectForScale(scrollview: scroll, scale: newscale, center: tap.location(in: tap.view))
        scroll.zoom(to: zoomRect, animated: true)
        
    }
    
    
    @objc func viewClick(tap: UITapGestureRecognizer) {
        if self.backScroll.zoomScale != 1 {
            let zoomRect = self.zoomRectForScale(scrollview: backScroll, scale: 1, center: self.center)
            self.backScroll.zoom(to: zoomRect, animated: true)
        } else {
            if tap.state == .recognized {
                self.tapMoveCallBack?(self.imgView)
            }
        }
    
    }
    
    
    func zoomRectForScale(scrollview: UIScrollView, scale: CGFloat,center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = scrollview.frame.size.height / scale
        zoomRect.size.width = scrollview.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
}


//MARK: UIScrollViewDelegate
extension CollectionViewCell : UIScrollViewDelegate {
    
    // 当scrollview 尝试进行缩放的时候
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    // 当缩放完毕的时候调用
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    // 将要开始缩放
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    // 当正在缩放的时候
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        获取到这个scrollview
        var centerX = self.backScroll.center.x
        var centerY = self.backScroll.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : centerY
        self.imgView.center = CGPoint(x: centerX, y: centerY)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
}
